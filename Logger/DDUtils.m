//
//  DDUtils.m
//  Logger
//
//  Created by dadong on 16/10/6.
//  Copyright © 2016年 dadong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DDUtils.h"

@implementation DDUtils

@end

@implementation DDUtils (Logger)

+ (void)redirectLogToDocuments
{
    //检测目录下是否有上一次留下的日志文件
    [self checkExistFiles] ;
    
    //如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return;
    }
    
    //模拟器，不保存到文件中       模拟器--> iPhone Simulator
    if ([[UIDevice currentDevice].name  hasSuffix:@"Simulator"] == YES) {
        return ;
    }
    
    //自定义条件，比如根据url判断
    
#ifndef DEBUG
    RETURN ;    //真机情况下的release,进行返回
#endif
    
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    dir = [dir stringByAppendingPathComponent:@"logs"] ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil] ;
    }
    
    NSDate *date = [NSDate date] ;
    NSDateFormatter *sdf = [[NSDateFormatter alloc]init] ;
    sdf.locale = [NSLocale localeWithLocaleIdentifier:@"zh_cn"] ;
    sdf.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *formatStr = [sdf stringFromDate:date] ;
    
    NSString *filePath = [dir stringByAppendingFormat:@"/%@.log",formatStr] ;
    NSLog(@"%@",filePath) ;
    freopen([filePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

+ (void)checkExistFiles
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    dir = [dir stringByAppendingPathComponent:@"logs"] ;
    
    NSError *error ;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error] ;
    if (error || files == nil) {
        return ;
    }
    
    if (files && files.count > 0) {
        [self uploadLogFiles:files atDirectory:dir] ;
    }
}

/**
 *  上传某个目录下的文件
 *
 *  @param files     要上传的文件名
 *  @param directory 哪个目录下的文件
 */
+ (void)uploadLogFiles:(NSArray<NSString *> *)files atDirectory:(NSString *)directory
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0 ; i < files.count; i ++) {
            if ([files[i] hasSuffix:@".log"] == NO) {
                continue ;
            }
            
            NSString * path = [directory stringByAppendingFormat:@"/%@",files[i]] ;
            
            //--------------这里自定义上传到哪里--------------
            //上传
            NSError *error ;
            [[NSFileManager defaultManager] copyItemAtPath:path toPath:[@"/Users/dadong/Desktop/" stringByAppendingFormat:@"/%@",files[i]]  error:&error] ;
            //----------------------------------------------
            
            if (error == nil) {
                //删除
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil] ;
            }
        }
    }) ;
}


@end