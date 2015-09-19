//
//  MBXVideoManager.m
//
//  Created by Mo Bitar on 9/13/15.
//  Copyright © 2015 progenius. All rights reserved.
//

#import "MBXResourceManager.h"
#import "MBXResourceRequest.h"

@interface MBXResourceManager ()
@property (nonatomic) NSMutableArray *requests;
@end

@implementation MBXResourceManager

+ (instancetype)sharedInstance
{
    static MBXResourceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MBXResourceManager new];
    });
    return instance;
}

- (NSMutableArray *)requests
{
    if(!_requests) {
        self.requests = [NSMutableArray new];
    }
    return _requests;
}

- (void)beginAccessingResource:(id<MBXResource>)resource
                 progressBlock:(void(^)(CGFloat progress))progressBlock
                    completion:(void(^)(BOOL success, NSError *error))completion
{
    MBXResourceRequest *request = [MBXResourceRequest new];
    request.resource = resource;
    [self addRequestToQueue:request];
    
    [request beginAccessingResource:resource progressBlock:progressBlock completion:^(BOOL success, NSError *error) {
        completion(success, error);
    }];
}

- (void)isResourceCached:(id<MBXResource>)resource completion:(void(^)(BOOL cached))completion
{
    MBXResourceRequest *request = [MBXResourceRequest new];
    request.resource = resource;
    [self addRequestToQueue:request];
    
    [request isResourceCached:resource completion:^(BOOL cached) {
        completion(cached);
    }];
}

- (void)endAccessingResource:(id<MBXResource>)resource
{
    for(MBXResourceRequest *request in self.requests) {
        if(request.resource == resource) {
            
            [request endAccessingResources];
            [self removeRequestFromQueue:request];
        }
    }
}

- (void)addRequestToQueue:(MBXResourceRequest *)request
{
    [self.requests addObject:request];
}

/** Note: Deallocating a resource request ends access to it, according to the docs. */

- (void)removeRequestFromQueue:(MBXResourceRequest *)request
{
    [self.requests removeObject:request];
}


@end
