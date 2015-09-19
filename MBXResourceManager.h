//
//  MBXVideoManager.h
//
//  Created by Mo Bitar on 9/13/15.
//  Copyright © 2015 progenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBXResource.h"

@interface MBXResourceManager : NSObject

+ (instancetype)sharedInstance;

- (void)beginAccessingResource:(id<MBXResource>)resource
                 progressBlock:(void(^)(CGFloat progress))progressBlock
                    completion:(void(^)(BOOL success, NSError *error))completion;

- (void)isResourceCached:(id<MBXResource>)resource completion:(void(^)(BOOL cached))completion;

- (void)endAccessingResource:(id<MBXResource>)resource;

@end
