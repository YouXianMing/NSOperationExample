//
//  ViewController.m
//  NSOperationDownloadImage
//
//  Created by YouXianMing on 15/9/7.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "ViewController.h"
#import "ImageDownloadOperation.h"

@interface ViewController () <ImageDownloadOperationDelegate>

@property (nonatomic, strong) NSOperationQueue       *queue;
@property (nonatomic, strong) ImageDownloadOperation *operation;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    NSString *imageUrlString = @"http://pic.cnblogs.com/avatar/607542/20150807105148.png";
    
    self.queue     = [[NSOperationQueue alloc] init];
    self.operation = [ImageDownloadOperation operationWithImageUrlString:imageUrlString delegate:self];
    
    [self.queue addOperation:self.operation];
}

- (void)imageDownloadOperation:(ImageDownloadOperation *)operation data:(NSData *)data {

    NSLog(@"%d", [NSThread currentThread].isMainThread);
    NSLog(@"data length - %lu", (unsigned long)data.length);
}

@end
