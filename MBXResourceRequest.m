//
//  MBXVideoRequest.m
//
//  Created by Mo Bitar on 9/18/15.
//  Copyright © 2015 progenius. All rights reserved.
//

#import "MBXResourceRequest.h"

@interface MBXResourceRequest ()
@property (nonatomic, copy) void(^progressBlock)(CGFloat progress);
@property (nonatomic) NSBundleResourceRequest *resourceRequest;
@end

@implementation MBXResourceRequest

- (void)beginAccessingResource:(id<MBXResource>)resource
                 progressBlock:(void(^)(CGFloat progress))progressBlock
                    completion:(void(^)(BOOL success, NSError *error))completion
{
    self.progressBlock = progressBlock;
    
    NSSet *tags = [NSSet setWithArray:resource.resourceTags];
    
    // Use the shorter initialization method as all resources are in the main bundle
    self.resourceRequest = [[NSBundleResourceRequest alloc] initWithTags:tags];
    
    [self beginObservingProgress];
    
    __weak typeof(self) weakself = self;
    
    [self.resourceRequest beginAccessingResourcesWithCompletionHandler: ^(NSError * __nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{

            [weakself stopObserveringProgress];
            
            if (error) {
                completion(NO, error);
                return;
            }
            
            completion(YES, nil);
        });
    }];
}

- (void)isResourceCached:(id<MBXResource>)resource completion:(void(^)(BOOL cached))completion
{
    NSSet *tags = [NSSet setWithArray:resource.resourceTags];
    
    self.resourceRequest = [[NSBundleResourceRequest alloc] initWithTags:tags];
    
    [self.resourceRequest conditionallyBeginAccessingResourcesWithCompletionHandler:^(BOOL resourcesAvailable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(resourcesAvailable);
        });
    }];
}

- (void)beginObservingProgress
{
    [self.resourceRequest.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)stopObserveringProgress
{
    [self.resourceRequest.progress removeObserver:self forKeyPath:@"fractionCompleted" context:nil];
}

- (void)endAccessingResources
{
    [self.resourceRequest endAccessingResources];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat progress = self.resourceRequest.progress.fractionCompleted;
        
        if(self.progressBlock) {
            self.progressBlock(progress);
        }
    });
}

@end
