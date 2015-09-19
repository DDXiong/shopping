//
//  GoodsInfoModel.m
//  购物车
//
//  Created by tarena500 on 15/9/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "GoodsInfoModel.h"

@implementation GoodsInfoModel
-(instancetype)initWithDict:(NSDictionary *)dict

{
    
    if (self = [super init])
        
    {
        
        self.imageName = dict[@"imageName"];
        
        self.goodsTitle = dict[@"goodsTitle"];
        
        self.goodsPrice = dict[@"goodsPrice"];
        
        self.goodsNum = [dict[@"goodsNum"]intValue];
        
        self.selectState = [dict[@"selectState"]boolValue];
        
    }
    
    return  self;
    
}
@end
