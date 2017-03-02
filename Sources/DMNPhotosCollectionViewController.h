//
//  DMNPhotosCollectionViewController.h
//  Rover
//
//  Created by Jeremiah Hawks on 3/1/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMNRover;
@class DMNSolDescription;

@interface DMNPhotosCollectionViewController : UICollectionViewController

@property (nonatomic, strong) DMNRover *rover;
@property (nonatomic, strong) DMNSolDescription *sol;

@end
