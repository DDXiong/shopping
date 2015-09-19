//
//  MyCustomCell.m
//  购物车
//
//  Created by tarena500 on 15/9/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

//UIImageView *goodsImgV;//商品图片
//
//UILabel *goodsTitleLab;//商品标题
//
//UILabel *priceTitleLab;//价格标签
//
//UILabel *priceLab;//具体价格
//
//UILabel *goodsNumLab;//购买数量标签
//
//UILabel *numCountLab;//购买商品的数量
//
//UIButton *addBtn;//添加商品数量
//
//UIButton *deleteBtn;//删除商品数量
//
//UIButton *isSelectBtn;//是否选中按钮
//
//UIImageView *isSelectImg;//是否选中图片
//
//BOOL selectState;//选中状态


#import "MyCustomCell.h"
@interface MyCustomCell()
@property(nonatomic,strong)UIView * bgView;

@end

@implementation MyCustomCell
#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LIKE_GOOD_NOTIFICATION  @"pointChang"
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
        
    {
        //布局界面

        
        //添加商品图片
        _goodsImgV = [[UIImageView alloc]init];
        _goodsImgV.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_goodsImgV];
        
        //添加商品标题
        
        _goodsTitleLab = [[UILabel alloc]init];
        _goodsTitleLab.text = @"afadsfa fa";
        _goodsTitleLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_goodsTitleLab];
        
        //促销价
        
        _priceTitleLab = [[UILabel alloc]init];
        _priceTitleLab.text = @"促销价:";
        _priceTitleLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceTitleLab];
        
        //商品价格
        
        _priceLab = [[UILabel alloc]init];
        _priceLab.text = @"1990";
        _priceLab.textColor = [UIColor redColor];
        [self.contentView addSubview:_priceLab];
        
        //购买数量
        
        _goodsNumLab = [[UILabel alloc]init];
        _goodsNumLab.text = @"购买数量：";
        [self.contentView addSubview:_goodsNumLab];
        
        //减按钮
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       
        [_deleteBtn setImage:[UIImage imageNamed:@"按钮-.png"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.tag = 11;
        [self.contentView addSubview:_deleteBtn];
        
        //购买商品的数量
        
        _numCountLab = [[UILabel alloc]init];
        _numCountLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_numCountLab];
        
        //加按钮
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.backgroundColor=[UIColor yellowColor];
        [_addBtn setImage:[UIImage imageNamed:@"按钮+.png"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.tag = 12;
        [self.contentView addSubview:_addBtn];
        
        //是否选中图片
        
        _isSelectImg = [[UIImageView alloc]init];
        [self.contentView addSubview:_isSelectImg];
        [self addSubview:self.contentView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
        self.bgView.frame=CGRectMake(5, 5, WIDTH-10, 95);
        self.goodsImgV.frame=CGRectMake(5, 10, 80, 80);

        self.goodsTitleLab.frame=CGRectMake(90, 5, 200, 30);
        self.priceTitleLab.frame=CGRectMake(90, 35, 70, 30);

        self.priceLab.frame=CGRectMake(160, 35, 100, 30);
        self.goodsNumLab.frame=CGRectMake(90, 65, 90, 30);
        _deleteBtn.frame = CGRectMake(180, 65, 30, 30);
        self.numCountLab.frame=CGRectMake(210, 65, 50, 30);
         _addBtn.frame = CGRectMake(260, 65, 30, 30);

        self.isSelectImg.frame=CGRectMake(WIDTH - 50, 10, 30, 30);
}

/**
 
 *  给单元格赋值
 *  @param goodsModel 里面存放各个控件需要的数值
 
 */


-(void)addTheValue:(GoodsInfoModel *)goodsModel
{
    

    _goodsImgV.image = [UIImage imageNamed:goodsModel.imageName];
    _goodsTitleLab.text = goodsModel.goodsTitle;
    _priceLab.text = goodsModel.goodsPrice;
    _numCountLab.text = [NSString stringWithFormat:@"%d",goodsModel.goodsNum];
    if (goodsModel.selectState)
        
    {
        _selectState = YES;
        
        _isSelectImg.image = [UIImage imageNamed:@"复选框-选中"];
        
    }else{
        
        _selectState = NO;
        
        _isSelectImg.image = [UIImage imageNamed:@"复选框-未选中"];
        
    }
    
}

/**
 *  点击减按钮实现数量的减少
 *  @param sender 减按钮
 */

-(void)deleteBtnAction:(UIButton *)sender

{
    //判断是否选中，选中才能点击
    if (_selectState == YES)
        
    {
        //调用代理
        [self.delegate btnClick:self andFlag:(int)sender.tag];
    }
    
}

/**
 
 *  点击加按钮实现数量的增加
 
 *
 
 *  @param sender 加按钮
 
 */
-(void)addBtnAction:(UIButton *)sender

{
    NSLog(@"00000000");
    
    
 
    //判断是否选中，选中才能点击
    if (_selectState == YES)
        
    {//调用代理
           [[NSNotificationCenter defaultCenter]postNotificationName:LIKE_GOOD_NOTIFICATION object:nil userInfo:@{@"position" :[NSValue valueWithCGPoint:[self convertPoint:self.goodsImgV.center toView:self.superview]]}];
        [self.delegate btnClick:self andFlag:(int)sender.tag];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
