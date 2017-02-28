//
//  DMNSolDescription.h
//  Rover
//
//  Created by Jeremiah Hawks on 2/28/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMNSolDescription : NSObject

@property (nonatomic) NSInteger sol;
@property (nonatomic) NSInteger numberOfPhotos;
@property (nonatomic, copy) NSArray *cameras;


@end
