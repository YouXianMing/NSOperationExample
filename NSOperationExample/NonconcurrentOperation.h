//
//  NonconcurrentOperation.h
//  NSOperationExample
//
//  Created by YouXianMing on 15/9/4.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NonconcurrentOperation : NSOperation

@property (nonatomic, strong)           NSString  *urlString;
@property (nonatomic, strong, readonly) NSData    *netData;

@end
