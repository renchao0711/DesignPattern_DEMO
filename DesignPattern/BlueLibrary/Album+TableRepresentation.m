//
//  Album+TableRepresentation.m
//  BlueLibrary
//
//  Created by 任超 on 17/2/9.
//  Copyright © 2017年 Eli Ganem. All rights reserved.
//

#import "Album+TableRepresentation.h"

@implementation Album (TableRepresentation)

-(NSDictionary *)tr_tableRepresentation{
    return @{@"titles":@[@"Artist",@"Album",@"Genre",@"Year"],
             @"values":@[self.artist,self.title,self.genre,self.year]};
}

@end
