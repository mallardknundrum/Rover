//
//  DMNPhoto.h
//  Rover
//
//  Created by Jeremiah Hawks on 2/28/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMNPhoto : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSInteger sol;
@property (nonatomic, copy) NSString *cameraName;
@property (nonatomic, copy) NSDate *earthDate;
@property (nonatomic, copy) NSURL *imageURL;

@end
