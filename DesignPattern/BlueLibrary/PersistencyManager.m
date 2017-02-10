//
//  PersistencyManager.m
//  BlueLibrary
//
//  Created by 任超 on 17/2/9.
//  Copyright © 2017年 Eli Ganem. All rights reserved.
//

#import "PersistencyManager.h"

@interface PersistencyManager (){
    NSMutableArray *albums;
}

@end

@implementation PersistencyManager

-(id)init{
    self = [super init];
    if (self) {
        NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Document/newAlbums.bin"]];
        albums = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (albums == nil) {
            albums = [NSMutableArray arrayWithArray:
                      @[[[Album alloc]initWithTitle:@"成都" artist:@"赵雷" coverUrl:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1486702759626&di=70fd78648252ca5f489158ed99cbe982&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%3D580%2Fsign%3D4e0747a58c13632715edc23ba18ea056%2F73f90fd7912397ddfe9c437d5f82b2b7d1a28727.jpg" year:@"2016"],
                        [[Album alloc]initWithTitle:@"你就不要想起我" artist:@"田馥甄" coverUrl:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=217797736,2450430342&fm=21&gp=0.jpg" year:@"2014"],
                        [[Album alloc]initWithTitle:@"从你的全世界路过" artist:@"王菲" coverUrl:@"http://img5.cache.netease.com/photo/0003/2016-09-25/400x300_C1QI04QR3LF60003.jpg" year:@"2016"],
                        [[Album alloc]initWithTitle:@"她说" artist:@"林俊杰" coverUrl:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3878812074,854800777&fm=21&gp=0.jpg" year:@"2014"],
                        [[Album alloc]initWithTitle:@"周杰伦的床边故事" artist:@"周杰伦" coverUrl:@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3833484832,3338050823&fm=23&gp=0.jpg" year:@"2016"]
                        ]];
            [self saveAlbums];
        }
    }
    return self;
}

-(NSArray *)getAlbums{
    return albums;
}

-(void)addAlbum:(Album *)album atIndex:(int)index{
    if (albums.count >= index)
        [albums insertObject:album atIndex:index];
    else
        [albums addObject:album];
}

-(void)deleteAlbumAtIndex:(int)index{
    [albums removeObjectAtIndex:index];
}

//存取专辑图片
-(void)saveImage:(UIImage *)image fileName:(NSString *)fileName{
    fileName = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",fileName];
    NSLog(@"%@",fileName);
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:fileName atomically:YES];
}
-(UIImage *)getImage:(NSString *)fileName{
    fileName = [NSHomeDirectory() stringByAppendingFormat:@"/Document/%@",fileName];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    return [UIImage imageWithData:data];
}

//归档专辑信息到文件中
-(void)saveAlbums{
    NSString *fileName = [NSHomeDirectory() stringByAppendingString:@"/Documents/newAlbums.bin"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:albums];
    [data writeToFile:fileName atomically:YES];
}

@end
