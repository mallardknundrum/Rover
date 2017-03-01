//
//  DMNPhoto.m
//  Rover
//
//  Created by Jeremiah Hawks on 2/28/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import "DMNPhoto.h"
#import "DMNDictionaryKeys.m"
#import "DMNPhoto.h"

@implementation DMNPhoto

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return dateFormatter;
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if(!dictionary[@"id"]) { return nil; }
        _identifier = [dictionary[identifierKey] integerValue];
        _sol = [dictionary[@"camera"][solKey] integerValue];
        _cameraName = dictionary[cameraNameKey];
        NSString *earthDateString = dictionary[earthDateKey];
        _earthDate = [[[self class] dateFormatter] dateFromString:earthDateString];
        _imageURL = [NSURL URLWithString:dictionary[imageURLKey]];
        if (!_imageURL) { return nil; }
    }
    return self;
}

-(BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[DMNPhoto class]]) { return NO; }
    DMNPhoto *photo = object;
    if (photo.identifier != self.identifier) { return NO; }
    if (photo.sol != self.sol) { return NO; }
    if (photo.cameraName != self.cameraName) { return NO; }
    if (photo.earthDate != self.earthDate) { return NO; }
    if (photo.imageURL != self.imageURL) { return NO; }
    return YES;
}

@end
