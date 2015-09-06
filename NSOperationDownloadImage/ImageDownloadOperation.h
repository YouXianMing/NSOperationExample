//
//  ImageDownloadOperation.h
//  NSOperationDownloadImage
//
//  Created by YouXianMing on 15/9/7.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImageDownloadOperation;

@protocol ImageDownloadOperationDelegate <NSObject>

@required
- (void)imageDownloadOperation:(ImageDownloadOperation *)operation data:(NSData *)data;

@end

@interface ImageDownloadOperation : NSOperation {
    
    BOOL  _executing;
    BOOL  _finished;
}

/**
 *  代理
 */
@property (nonatomic, weak)   id <ImageDownloadOperationDelegate> delegate;

/**
 *  图片地址
 */
@property (nonatomic, strong) NSString *imageUrlString;

/**
 *  便利构造器
 *
 *  @param urlString 图片地址
 *  @param delegate  代理
 *
 *  @return 实例对象
 */
+ (instancetype)operationWithImageUrlString:(NSString *)urlString
                                   delegate:(id <ImageDownloadOperationDelegate>)delegate;

@end
