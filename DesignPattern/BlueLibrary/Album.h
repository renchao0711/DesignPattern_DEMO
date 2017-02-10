//
//  Album.h
//  BlueLibrary
//
//  Created by 任超 on 17/2/9.
//  Copyright © 2017年 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject <NSCoding>

@property (nonatomic,copy,readonly) NSString *title;
@property (nonatomic,copy,readonly) NSString *artist;
@property (nonatomic,copy,readonly) NSString *genre;
@property (nonatomic,copy,readonly) NSString *coverUrl;
@property (nonatomic,copy,readonly) NSString *year;

-(instancetype)initWithTitle:(NSString *)title artist:(NSString *)artist coverUrl:(NSString *)coverUrl year:(NSString *)year;


@end
