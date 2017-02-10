//
//  LibraryAPI.h
//  BlueLibrary
//
//  Created by 任超 on 17/2/9.
//  Copyright © 2017年 Eli Ganem. All rights reserved.
//

//管理所有专辑数据的类
#import <Foundation/Foundation.h>
#import "Album.h"

@interface LibraryAPI : NSObject

+(LibraryAPI *)shareInstance;

-(NSArray *)getAlbums;
-(void)addAlbum:(Album *)album atIndex:(int)index;
-(void)deleteAlbumAtIndex:(int)index;

-(void)saveAlbums;

@end
