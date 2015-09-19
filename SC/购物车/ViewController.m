//
//  ViewController.m
//  购物车
//
//  Created by tarena500 on 15/9/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "ViewController.h"
#import "GoodsInfoModel.h"
#import "MyCustomCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,MyCustomCellDelegate>
@property(nonatomic,strong)UITableView*MyTableView;
@property(nonatomic,strong)UIButton*allSelectBtn;
@property(nonatomic,strong)UILabel*allPriceLab;
@property(nonatomic,assign)float allPrice;
@property(nonatomic,strong)NSMutableArray*infoArr;
@property(nonatomic,strong) UIView*cartView;

@end

@implementation ViewController

-(NSMutableArray*)infoArr{
    if (!_infoArr) {
       _infoArr = [[NSMutableArray alloc]init];
    }
    return _infoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _allPrice = 0.0;
 
    
    [self addShoppingCart];
    /**
     
     *  初始化一个数组，数组里面放字典。字典里面放的是单元格需要展示的数据
     
     */
    
    for (int i = 0; i<7; i++)
        
    {
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
        
        [infoDict setValue:@"img6.png" forKey:@"imageName"];
        
        [infoDict setValue:@"这是商品标题" forKey:@"goodsTitle"];
        
        [infoDict setValue:@"2000" forKey:@"goodsPrice"];
        
        [infoDict setValue:[NSNumber numberWithBool:NO] forKey:@"selectState"];
        
        [infoDict setValue:[NSNumber numberWithInt:0] forKey:@"goodsNum"];
        
        //封装数据模型
        
        GoodsInfoModel *goodsModel = [[GoodsInfoModel alloc]initWithDict:infoDict];
        
        //将数据模型放入数组中
        
        [self.infoArr addObject:goodsModel];
        
    }

    _MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.MyTableView.backgroundColor=[UIColor clearColor];
    
    _MyTableView.dataSource = self;
    
    _MyTableView.delegate = self;
    
    //给表格添加一个尾部视图
    
    _MyTableView.tableFooterView = [self creatFootView];
    
   [self.view insertSubview:self.MyTableView belowSubview:self.cartView];
}
-(void)addShoppingCart
{
    UIView*cartView= [[UIView alloc]init];
    self.cartView=cartView;
    cartView.backgroundColor=[UIColor yellowColor];
    cartView.frame=CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
    [self.view addSubview:cartView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePoint:) name:@"pointChang" object:nil];
  
}
-(void)changePoint:(NSNotification*)notification{
    
    NSValue*value=notification.userInfo[@"position"];
    CGPoint lbCenter=value.CGPointValue;
    
    
    //NSLog(@"lbCenter:%f,%f",lbCenter.x,lbCenter.y);

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];

    imageView.contentMode = UIViewContentModeScaleToFill;

    imageView.frame = CGRectMake(0, 0, 20, 20);
 
      imageView.hidden = YES;

      imageView.center = lbCenter;
    
    
    CALayer*layer=[[CALayer alloc]init];
    layer.contents=imageView.layer.contents;
    layer.frame=imageView.frame;
    layer.opacity=1;
    [self.view.layer addSublayer:layer];
    
    
    CGPoint endpoint=self.cartView.center;

    UIBezierPath*path=[UIBezierPath bezierPath];
    CGPoint startPoint=lbCenter;
  
    
    
    
    [path moveToPoint:startPoint];
    
    float sx = startPoint.x;

    float sy = startPoint.y;

    float ex = endpoint.x;

    float ey = endpoint.y;

    float x = sx + (ex - sx) / 3;

    float y =sy + (ey - sy) * 0.5- 400;


    CGPoint centerPoint=CGPointMake(x, y);

    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    
    
    CAKeyframeAnimation*animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.path = path.CGPath;

    animation.removedOnCompletion = NO;
 
    animation.fillMode = kCAFillModeForwards;

    animation.duration = 5;

    animation.delegate = self;

    animation.autoreverses = NO;

    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    [layer addAnimation:animation forKey:@"buy"];

}


-(UIView *)creatFootView{
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    
    //添加一个全选文本框标签
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 10, 50, 30)];
    
    lab.text = @"全选";
    
    [footView addSubview:lab];
    
    //添加全选图片按钮
    
    _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _allSelectBtn.frame = CGRectMake(self.view.frame.size.width- 100, 10, 30, 30);
    
    [_allSelectBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
    
    [_allSelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:_allSelectBtn];
    
    //添加小结文本框
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 40, 60, 30)];
    
    lab2.textColor = [UIColor redColor];
    
    lab2.text = @"小结：";
    
    [footView addSubview:lab2];
    
    //添加一个总价格文本框，用于显示总价
    
    _allPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 40, 100, 30)];
    
    _allPriceLab.textColor = [UIColor redColor];
    
    _allPriceLab.text = @"0.0";
    
    [footView addSubview:_allPriceLab];
    
    //添加一个结算按钮
    
    UIButton *settlementBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [settlementBtn setTitle:@"去结算" forState:UIControlStateNormal];
    
    [settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    settlementBtn.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, 30);
    
    settlementBtn.backgroundColor = [UIColor blueColor];
    
    [footView addSubview:settlementBtn];
    
    return footView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:  (NSInteger)section

{
    
    return self.infoArr.count;
    
}

//定制单元格内容

- (UITableViewCell *)tableView:(UITableView *)tableView     cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *identify =  @"indentify";
    MyCustomCell *cell = [tableView    dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[MyCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.delegate = self;
    }
    
    //调用方法，给单元格赋值
    [cell addTheValue:_infoArr[indexPath.row]];
    return cell;
    
}

//返回单元格的高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 120;
}

//单元格选中事件
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /**
     
     *  判断当期是否为选中状态，如果选中状态点击则更改成未选中，如果未选中点击则更改成选中状态
     
     */
    
    GoodsInfoModel *model = _infoArr[indexPath.row];
    
    if (model.selectState)
        
    {
        model.selectState = NO;
        
    }
    else
    {
        model.selectState = YES;
    }
    
    //刷新整个表格
    
    //    [_MyTableView reloadData];
    
    //刷新当前行
    
    [_MyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self totalPrice];
    
}

/**
 
 *  全选按钮事件
 
 *
 
 *  @param sender 全选按钮
 
 */

-(void)selectBtnClick:(UIButton *)sender

{
    //判断是否选中，是改成否，否改成是，改变图片状态
    
    sender.tag = !sender.tag;
    
    if (sender.tag)
        
    {
        
        [sender setImage:[UIImage imageNamed:@"复选框-选中.png"]   forState:UIControlStateNormal];
        
    }else{
        
        [sender setImage:[UIImage imageNamed:@"复选框-未选中.png"] forState:UIControlStateNormal];
        
    }
    
    //改变单元格选中状态
    
    for (int i=0; i<_infoArr.count; i++)
        
    {
        GoodsInfoModel *model = [_infoArr objectAtIndex:i];
        model.selectState = sender.tag;
    }
    
    //计算价格
    
    [self totalPrice];
    
    //刷新表格
    
    [_MyTableView reloadData];
    
}

#pragma mark -- 计算价格

-(void)totalPrice

{
    
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格（单价 * 商品数量）
    
    for ( int i =0; i<_infoArr.count; i++)
        
    {
        
        GoodsInfoModel *model = [_infoArr objectAtIndex:i];
        
        if (model.selectState)
            
        {
            _allPrice = _allPrice + model.goodsNum *[model.goodsPrice intValue];
        }
        
    }
    
    //给总价文本赋值
    
    _allPriceLab.text = [NSString stringWithFormat:@"%.2f",_allPrice];
    
    NSLog(@"%f",_allPrice);
    
    //每次算完要重置为0，因为每次的都是全部循环算一遍
    
    _allPrice = 0.0;
    
}

-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag

{
    
    NSIndexPath *index = [_MyTableView indexPathForCell:cell];
    
    switch (flag) {
            
        case 11:
            
        {
            
            //做减法
            
            //先获取到当期行数据源内容，改变数据源内容，刷新表格
            
            GoodsInfoModel *model = _infoArr[index.row];
            
            if (model.goodsNum > 0)
                
            {
                
                model.goodsNum --;
                
            }
            
        }
            
            break;
            
        case 12:
            
        {
            
            //做加法
            
            GoodsInfoModel *model = _infoArr[index.row];
            
            model.goodsNum ++;
            
        }
            
            break;
            
        default:
            
            break;
            
    }
    
    //刷新表格
    
    [_MyTableView reloadData];
    
    //计算总价
    
    [self totalPrice];
    
}


@end
