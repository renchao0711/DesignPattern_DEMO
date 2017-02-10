//
//  Album+TableRepresentation.h
//  BlueLibrary
//
//  Created by 任超 on 17/2/9.
//  Copyright © 2017年 Eli Ganem. All rights reserved.
//

//Category(类别)是一种不需要子类化就可以让你能动态的给已经存在的类增加方法的强有力的机制。新增的方法是在编译期增加的，这些方法执行的时候和被扩展的类的其它方法是一样的。它可能与装饰器设计模式的定义稍微有点不同，因为Category(类别)不会保存被扩展类的引用。

#import "Album.h"

@interface Album (TableRepresentation)

-(NSDictionary *)tr_tableRepresentation;

@end
