//
//  DMNRover.h
//  Rover
//
//  Created by Jeremiah Hawks on 2/28/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMNRover : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate  *launchDate;
@property (nonatomic, copy) NSDate  *landingDate;
@property (nonatomic) NSInteger maxSol;
@property (nonatomic, copy) NSDate  *maxDate;
@property (nonatomic, copy) NSEnumerator *status;

@end
