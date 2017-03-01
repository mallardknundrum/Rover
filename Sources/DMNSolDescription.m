//
//  DMNSolDescription.m
//  Rover
//
//  Created by Jeremiah Hawks on 2/28/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import "DMNSolDescription.h"
#import "DMNDictionaryKeys.m"

@implementation DMNSolDescription

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _sol = [dictionary[solKey] integerValue];
        _numberOfPhotos = [dictionary[numberOfPhotosKey] integerValue];
        _cameras = [dictionary[camerasKey] copy];
    }
    return self;
}

@end
