//
//  DDUtils.h
//  Logger
//
//  Created by dadong on 16/10/6.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDUtils : NSObject

@end

@interface DDUtils (Logger)

/**
 *  重定向日志输出到Documents目录下
 */
+ (void)redirectLogToDocuments ;
@end
