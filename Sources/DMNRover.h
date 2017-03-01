//
//  DMNRover.h
//  Rover
//
//  Created by Jeremiah Hawks on 2/28/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DMNMarsRoverStatus) {
    DMNMarsRoverStatusActive,
    DMNMarsRoverStatusComplete,
};

@interface DMNRover : NSObject




- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate  *launchDate;
@property (nonatomic, copy) NSDate  *landingDate;
@property (nonatomic) NSInteger maxSol;
@property (nonatomic, copy) NSDate  *maxDate;
@property (nonatomic) DMNMarsRoverStatus status;
@property (nonatomic, readonly) NSInteger numberOfPhotos;
@property (nonatomic, strong, readonly) NSArray *solDescriptions;

@end
