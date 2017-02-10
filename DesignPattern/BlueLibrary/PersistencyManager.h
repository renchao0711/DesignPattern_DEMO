//
//  PersistencyManager.h
//  BlueLibrary
//
//  Created by 任超 on 17/2/9.
//  Copyright © 2017年 Eli Ganem. All rights reserved.
//

//处理资料库数据持久化的类
//当前你已经用PersistencyManager本地保存专辑数据，使用HTTPClient处理远程连接，工程中的其它类暂时与本次实现的逻辑无关。为了实现这个模式，只有LibraryAPI应该保存PersistencyManager和HTTPClient的实例，然后LibraryAPI将暴漏一个简单的API去访问这些服务。
#import <Foundation/Foundation.h>
#import "Album.h"

@interface PersistencyManager : NSObject

-(NSArray *)getAlbums;
-(void)addAlbum:(Album *)album atIndex:(int)index;
-(void)deleteAlbumAtIndex:(int)index;

-(void)saveImage:(UIImage *)image fileName:(NSString *)fileName;
-(UIImage *)getImage:(NSString *)fileName;

-(void)saveAlbums;

@end
