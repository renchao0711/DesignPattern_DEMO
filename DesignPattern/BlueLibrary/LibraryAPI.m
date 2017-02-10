//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by 任超 on 17/2/9.
//  Copyright © 2017年 Eli Ganem. All rights reserved.
//

#import "LibraryAPI.h"
#import "PersistencyManager.h"
#import "HTTPClient.h"

@interface LibraryAPI (){
    //这里将是唯一的导入这两个类的地方。记住：你的API是对于复杂系统唯一的访问点。
    PersistencyManager *persistencyManager;
    HTTPClient *httpClient;
    
    //isOnline决定了是否服务器中任何专辑数据的改变应该被更新
    BOOL isOnline;
}

@end

@implementation LibraryAPI

+(LibraryAPI *)shareInstance{
    static LibraryAPI *_shareInstance = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[LibraryAPI alloc]init];
    });
    return _shareInstance;
}

-(id)init{
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc]init];
        httpClient  = [[HTTPClient alloc]init];
        isOnline = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"DownloadImageNotification" object:nil];
    }
    return self;
}

-(NSArray *)getAlbums{
    return [persistencyManager getAlbums];
}

-(void)addAlbum:(Album *)album atIndex:(int)index{
    [persistencyManager addAlbum:album atIndex:index];
    if (isOnline) {
        [httpClient postRequest:@"/api/addAlbum" body:[album description]];
    }
}

-(void)deleteAlbumAtIndex:(int)index{
    [persistencyManager deleteAlbumAtIndex:index];
    if (isOnline) {
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index)description]];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)downloadImage:(NSNotification *)notification{
    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverURL = notification.userInfo[@"coverURL"];
    
    imageView.image = [persistencyManager getImage:[coverURL lastPathComponent]];
    if (imageView.image == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [httpClient downloadImage:coverURL];
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [persistencyManager saveImage:image fileName:[coverURL lastPathComponent]];
            });
        });
    }
    
}

-(void)saveAlbums{
    [persistencyManager saveAlbums];
}

@end
