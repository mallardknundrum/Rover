//
//  DMNMarsRoverClient.m
//  Rover
//
//  Created by Jeremiah Hawks on 3/1/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import "DMNMarsRoverClient.h"
#import "DMNRover.h"
#import "DMNPhoto.h"

@implementation DMNMarsRoverClient

-(void)fetchPhotosFromRover:(DMNRover *)rover onSol:(NSInteger)sol completion:(void (^)(NSArray *, NSError *))completion
{
    if (!rover) {
        NSLog(@"%s called with a nil rover.", __PRETTY_FUNCTION__);
        return completion(nil, [NSError errorWithDomain:@"com.DevMountain.Rover.ErrorDomain" code:-1 userInfo:nil]);
    }
    NSURL *url = [[self class] urlForPhotosFromRover:rover.name onSol:sol];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            return completion(nil, error);
        }
        if (!data) {
            return completion(nil, [NSError errorWithDomain:@"com.DevMountain.Rover.ErrorDomain" code:-1 userInfo:nil]);
        }
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!jsonDictionary || ![jsonDictionary isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userInfo = nil;
            if (error) { userInfo = @{NSUnderlyingErrorKey : error}; }
            NSError *localError = [NSError errorWithDomain:@"com.DevMountain.Rover.ErrorDomain" code:-1 userInfo:userInfo];
            return completion(nil, localError);
        }
        NSArray *photoDictionaries = jsonDictionary[@"photos"];
        NSMutableArray *photos = [NSMutableArray array];
        for (NSDictionary *dict in photoDictionaries) {
            DMNPhoto *photo = [[DMNPhoto alloc] initWithDictionary:dict];
            if (!photo) { continue; }
            [photos addObject:photo];
        }
        completion(photos, nil);
    }] resume];
}

- (void)fetchMissionManifestForRovernamed:(NSString *)name completion:(void (^)(DMNRover *, NSError *))completion
{
    NSURL *url = [[self class] urlForInfoForRover:name];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            return completion(nil, error);
        }
        if (!data) {
            return completion(nil, [NSError errorWithDomain:@"com.DevMountain.Rover.ErrorDomain" code:-1 userInfo:nil]);
        }
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *manifest = nil;
        if (!jsonDictionary || ![jsonDictionary isKindOfClass:[NSDictionary class]] || !(manifest = jsonDictionary[@"photo_manifest:"])) {
            NSDictionary *userInfo = nil;
            if (error) { userInfo = @{NSUnderlyingErrorKey : error}; }
            NSError *localError = [NSError errorWithDomain:@"com.DevMountain.Rover.ErrorDomain" code:-1 userInfo:userInfo];
            return completion(nil, localError);
        }
        completion([[DMNRover alloc] initWithDictionary:manifest], nil);
    }] resume];
}

-(void)fetchAllMarsRoversWithCompletion:(void (^)(NSArray *, NSError *))completion
{
    NSURL *url = [[self class] roversEndpoint];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            return completion(nil, error);
        }
        if(!data) {
            return completion(nil, [NSError errorWithDomain:@"com.DevMountain.Rover.ErrorDomain" code:-1 userInfo:nil]);
        }
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *roverDictionary = nil;
        if (!jsonDictionary || ![jsonDictionary isKindOfClass:[NSDictionary class]] || !(roverDictionary = jsonDictionary[@"rovers"])) {
            NSDictionary *userInfo = nil;
            if(error) {userInfo = @{NSUnderlyingErrorKey : error}; }
            NSError *localError = [NSError errorWithDomain:@"com.DevMountain.Rover.ErrorDomain" code:-1 userInfo:userInfo];
            return completion(nil, localError);
        }
        NSMutableArray *roverNames = [NSMutableArray array];
        for (NSDictionary *dictionary in roverDictionary) {
            NSString *name = dictionary[@"name"];
            if (name) { [roverNames addObject:name]; }
        }
        completion(roverNames, nil);
    }] resume];
}

- (void)fetchImageDataForPhoto:(DMNPhoto *)photo completion:(void (^)(NSData *, NSError *))completion
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:photo.imageURL resolvingAgainstBaseURL:YES];
    urlComponents.scheme = @"https";
    NSURL *imageURL = urlComponents.URL;
    [[[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            return completion(nil, error);
        }
        if(!data) {
            return completion(nil, [NSError errorWithDomain:@"com.DevMountain.Rover.ErrorDomain" code:-1 userInfo:nil]);
        }
        completion(data, nil);
    }] resume];
}

#pragma mark - Private

+ (NSString *)apiKey {
    static NSString *apiKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *apiKeysURL = [[NSBundle mainBundle] URLForResource:@"APIKeys" withExtension:@"plist"];
        if (!apiKeysURL) {
            NSLog(@"Error! APIKeys file not found!");
            return;
        }
        NSDictionary *apiKeys = [[NSDictionary alloc] initWithContentsOfURL:apiKeysURL];
        apiKey = apiKeys[@"APIKey"];
    });
    return apiKey;
}

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:@"https://api.nasa.gov/mars-photos/api/v1"];
}

// builds url to reach manifests for ROVERNAME
// should return:
// "https://api.nasa.gov/mars-photos/api/v1/manifests/ROVERNAME/?api_key=qzGsj0zsKk6CA9JZP1UjAbpQHabBfaPg2M5dGMB7"
+ (NSURL *)urlForInfoForRover:(NSString *)roverName
{
    NSURL *url = [self baseURL];
    url = [url URLByAppendingPathComponent:@"manifests"];
    url = [url URLByAppendingPathComponent:roverName];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"api_key" value:[self apiKey]]];
    return urlComponents.URL;
}

// Builds base URL for photos from a specific ROVERNAME and SOLVALUE
// should build a URL something like:
// "https://api.nasa.gov/mars-photos/api/v1/rovers/ROVERNAME/photos?sol=SOLVALUE&api_key=qzGsj0zsKk6CA9JZP1UjAbpQHabBfaPg2M5dGMB7"
+ (NSURL *)urlForPhotosFromRover:(NSString *)roverName onSol:(NSInteger)sol
{
    NSURL *url = [self baseURL];
    url = [url URLByAppendingPathComponent:@"rovers"];
    url = [url URLByAppendingPathComponent:roverName];
    url = [url URLByAppendingPathComponent:@"photos"];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"sol" value:[@(sol) stringValue]],
                                 [NSURLQueryItem queryItemWithName:@"api_key" value:[self apiKey]]];
    return urlComponents.URL;
}

// Builds url for rovers, adds "rovers" and the api key
// This should be the resulting URL
// "https://api.nasa.gov/mars-photos/api/v1/rovers/?api_key=qzGsj0zsKk6CA9JZP1UjAbpQHabBfaPg2M5dGMB7"
+ (NSURL *)roversEndpoint
{
    NSURL *url = [[self baseURL] URLByAppendingPathComponent:@"rovers"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"api_key" value:[self apiKey]]];
    return urlComponents.URL;
}



@end
