//
//  DMNRoversTableViewController.m
//  Rover
//
//  Created by Jeremiah Hawks on 3/1/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import "DMNRoversTableViewController.h"
#import "DMNRover.h"
#import "DMNMarsRoverClient.h"
#import "DMNSolsTableViewController.h"

@interface DMNRoversTableViewController ()

@property (nonatomic, copy) NSArray *rovers;

@end

@implementation DMNRoversTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *rovers = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    DMNMarsRoverClient *client = [[DMNMarsRoverClient alloc] init];
    [client fetchAllMarsRoversWithCompletion:^(NSArray *roverNames, NSError *error) {
        if (error) {
            NSLog(@"Error fetching list of mars rovers: %@", error);
            return;
        }
        dispatch_queue_t resultsQueue = dispatch_queue_create("com.devmountain.roverFetchResultsQueue", 0);
        for (NSString *name in roverNames) {
            dispatch_group_enter(group);
            [client fetchMissionManifestForRovernamed:name completion:^(DMNRover *rover, NSError *error) {
                if (error) {
                    NSLog(@"Error fetching list of mars rovers: %@", error);
                    dispatch_group_leave(group);
                    return;
                }
                dispatch_async(resultsQueue, ^{
                    [rovers addObject:rover];
                    dispatch_group_leave(group);
                });
            }];
        }
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    self.rovers = rovers;
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rovers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roversCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.rovers[indexPath.row] name];
    return cell;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPhotosSegue"]) {
        DMNSolsTableViewController *destinationVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        destinationVC.rover = self.rovers[indexPath.row];
    }
}


@end
