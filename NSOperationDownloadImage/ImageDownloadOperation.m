//
//  ImageDownloadOperation.m
//  NSOperationDownloadImage
//
//  Created by YouXianMing on 15/9/7.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "ImageDownloadOperation.h"
#import <CommonCrypto/CommonDigest.h>

@interface ImageDownloadOperation ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSString        *md5String;
@property (nonatomic, strong) NSString        *filePathString;

@end

@implementation ImageDownloadOperation

- (void)main {
    
    // 验证图片地址是否为空
    if (_imageUrlString.length <= 0) {
        
        [self delegateEventWithData:nil];
        [self completeOperation];
        
        return;
    }
    
    // 生成文件路径
    self.md5String      = [self MD5HashWithString:_imageUrlString];
    self.filePathString = [self pathWithFileName:self.md5String];
    
    // 文件如果存在则直接读取
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self.filePathString isDirectory:nil];
    if (exist) {
        
        [self delegateEventWithData:[NSData dataWithContentsOfFile:self.filePathString]];
        [self completeOperation];
        
        return;
    }
    
    NSURL        *url     = [NSURL URLWithString:_imageUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.connection       = [NSURLConnection connectionWithRequest:request delegate:self];
    
    // 让线程不结束
    do {
        
        @autoreleasepool {
            
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
            
            if (self.isCancelled) {
                
                [self completeOperation];
            }
        }
        
    } while (self.isExecuting && self.isFinished == NO);
}

#pragma mark - 网络代理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self writeData:data toPath:self.filePathString];
    [self delegateEventWithData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self completeOperation];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self delegateEventWithData:nil];
    [self completeOperation];
}

#pragma mark - 
+ (instancetype)operationWithImageUrlString:(NSString *)urlString
                                   delegate:(id <ImageDownloadOperationDelegate>)delegate {

    ImageDownloadOperation *operation = [[ImageDownloadOperation alloc] init];
    operation.delegate                = delegate;
    operation.imageUrlString          = urlString;
    
    return operation;
}

#pragma mark -
- (void)completeOperation {
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    _finished  = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)start {
    
    if ([self isCancelled]) {
        
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        return;
    }
    
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

#pragma mark -
- (NSString *)MD5HashWithString:(NSString *)string {
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5, [string UTF8String], (CC_LONG) [string length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

- (NSString *)pathWithFileName:(NSString *)name {

    NSString *path = [NSString stringWithFormat:@"/Documents/%@", name];
    return [NSHomeDirectory() stringByAppendingPathComponent:path];
}

- (void)delegateEventWithData:(NSData *)data {
    
    if (_delegate && [_delegate respondsToSelector:@selector(imageDownloadOperation:data:)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_delegate imageDownloadOperation:self data:data];
        });
    }
}

- (void)writeData:(NSData *)data toPath:(NSString *)path {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [data writeToFile:path atomically:YES];
    });
}

@end
