//
//  DMNMarsRoverClient.h
//  Rover
//
//  Created by Jeremiah Hawks on 3/1/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMNRover;
@class DMNPhoto;

@interface DMNMarsRoverClient : NSObject

- (void)fetchAllMarsRoversWithCompletion:(void(^)(NSArray *roverNames, NSError *error))completion;
- (void)fetchMissionManifestForRovernamed:(NSString *)name completion:(void(^)(DMNRover *rover, NSError *error))completion;
- (void)fetchPhotosFromRover:(DMNRover *)rover onSol:(NSInteger)sol completion:(void(^)(NSArray *photos, NSError *error))completion;
- (void)fetchImageDataForPhoto:(DMNPhoto *)photo completion:(void(^)(NSData *imageData, NSError *error))completion;

@end
