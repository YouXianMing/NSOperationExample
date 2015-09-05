//
//  ConcurrentOperation.h
//  NSOperationExample
//
//  Created by YouXianMing on 15/9/5.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConcurrentOperation : NSOperation {

    BOOL  _executing;
    BOOL  _finished;
}

@property (nonatomic, strong)           NSString  *urlString;
@property (nonatomic, strong, readonly) NSData    *netData;

@end


