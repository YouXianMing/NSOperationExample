//
//  ViewController.m
//  NSOperationExample
//
//  Created by YouXianMing on 15/9/4.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "ViewController.h"
#import "NonconcurrentOperation.h"
#import "ConcurrentOperation.h"

@interface ViewController () {

    NonconcurrentOperation *_nonconcurrentOperation1;
    NonconcurrentOperation *_nonconcurrentOperation2;
    
    ConcurrentOperation    *_concurrentOperation1;
    ConcurrentOperation    *_concurrentOperation2;
}

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.queue                             = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 2;
    
//    [self nonconcurrentOperationExample];
    
    [self concurrentOperationExample];
}

- (void)concurrentOperationExample {

    // 操作1
    _concurrentOperation1           = [[ConcurrentOperation alloc] init];
    _concurrentOperation1.urlString = @"http://pic.cnblogs.com/avatar/607542/20150807105148.png";
    _concurrentOperation1.name      = @"concurrentOperation1";
    
    // 操作2
    _concurrentOperation2           = [[ConcurrentOperation alloc] init];
    _concurrentOperation2.urlString = @"http://pic.cnblogs.com/avatar/615197/20150505132152.png";
    _concurrentOperation2.name      = @"concurrentOperation2";
    
    [self.queue addOperation:_concurrentOperation1];
    [self.queue addOperation:_concurrentOperation2];
}

- (void)nonconcurrentOperationExample {
    
    // 操作1
    _nonconcurrentOperation1           = [[NonconcurrentOperation alloc] init];
    _nonconcurrentOperation1.urlString = @"http://pic.cnblogs.com/avatar/607542/20150807105148.png";
    _nonconcurrentOperation1.name      = @"nonconcurrentOperation1";
    
    // 操作2
    _nonconcurrentOperation2           = [[NonconcurrentOperation alloc] init];
    _nonconcurrentOperation2.urlString = @"http://pic.cnblogs.com/avatar/615197/20150505132152.png";
    _nonconcurrentOperation2.name      = @"nonconcurrentOperation2";
    
    [self.queue addOperation:_nonconcurrentOperation1];
    [self.queue addOperation:_nonconcurrentOperation2];
    
    [self performSelector:@selector(nonconcurrentOperationExampleEvent) withObject:nil afterDelay:2.f];
}

- (void)nonconcurrentOperationExampleEvent {

    NSLog(@"%@", self.queue.operations);
}

@end
