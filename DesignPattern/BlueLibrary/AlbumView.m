//
//  AlbumView.m
//  BlueLibrary
//
//  Created by 任超 on 17/2/9.
//  Copyright © 2017年 Eli Ganem. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView
{
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

-(instancetype)initWithFrame:(CGRect)frame albumCover:(NSString *)albumCover{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        [self addSubview:coverImage];
        
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = self.center;
        [indicator startAnimating];
        [self addSubview:indicator];
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadImageNotification" object:self userInfo:@{@"imageView":coverImage,@"coverURL":albumCover}];
    }
    return self;
}

-(void)dealloc{
    [coverImage removeObserver:self forKeyPath:@"image"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"image"]) {
        [indicator stopAnimating];
    }
}

@end
