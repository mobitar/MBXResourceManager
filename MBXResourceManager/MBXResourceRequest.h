//
//  MBXVideoRequest.h
//
//  Created by Mo Bitar on 9/18/15.
//  Copyright © 2015 progenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBXResource.h"

@interface MBXResourceRequest : NSObject

@property (nonatomic) id<MBXResource> resource;

- (void)beginAccessingResource:(id<MBXResource>)resource
                 progressBlock:(void(^)(CGFloat progress))progressBlock
                    completion:(void(^)(BOOL success, NSError *error))completion;

- (void)isResourceCached:(id<MBXResource>)resource completion:(void(^)(BOOL cached))completion;

- (void)endAccessingResources;

@end
