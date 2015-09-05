//
//  ConcurrentOperation.m
//  NSOperationExample
//
//  Created by YouXianMing on 15/9/5.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "ConcurrentOperation.h"

@interface ConcurrentOperation ()

@property (nonatomic, strong) NSData   *netData;
@property (nonatomic)         BOOL      isDone;

@end

@implementation ConcurrentOperation

- (void)main {

    // do tasks    
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
    
    // 设置结束标志位
    [self completeOperation];
    
    [self showThread];
}

- (void)showThread {
    
    if ([NSThread currentThread].isMainThread == YES) {
        
        NSLog(@"Run in MainThread %@", self.name);
        
    } else {
        
        NSLog(@"Run in SubThread  %@", self.name);
    }
    
    NSLog(@"%d", self.isFinished);
}

#pragma mark - 不可或缺的方法
- (void)completeOperation {
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    _finished  = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)start {
    
    // Always check for cancellation before launching the task.
    if ([self isCancelled]) {
        
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting {
    
    return _executing;
}

- (BOOL)isFinished {
    
    return _finished;
}

- (BOOL)isConcurrent {
    
    return YES;
}

@end
