//
//  NonconcurrentOperation.m
//  NSOperationExample
//
//  Created by YouXianMing on 15/9/4.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "NonconcurrentOperation.h"

@interface NonconcurrentOperation ()

@property (nonatomic, strong) NSData   *netData;
@property (nonatomic)         BOOL      isDone;

@end

@implementation NonconcurrentOperation

- (void)main {
    
    if ([self isCancelled] == YES || [self isDone] == YES) {
        
        return;
    }
    
    NSURL *url            = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.netData = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    if (self.netData) {
        
        self.isDone = YES;
    }
    
    [self showThread];
}

- (void)showThread {

    if ([NSThread currentThread].isMainThread == YES) {
        
        NSLog(@"Run in MainThread %@", self.name);
        
    } else {
        
        NSLog(@"Run in SubThread  %@", self.name);
    }
}

@end
