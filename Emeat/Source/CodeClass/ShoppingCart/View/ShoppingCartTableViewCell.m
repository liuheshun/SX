//
//  ShoppingCartTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/11/7.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"

@interface ShoppingCartTableViewCell ()

@end

@implementation ShoppingCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupMainView];
    }
    return self;
}
//选中按钮点击事件
-(void)selectBtnClick:(UIButton*)button
{
    button.selected = !button.selected;
    if (self.cartBlock) {
        self.cartBlock(button.selected);
    }
}

// 数量加按钮
-(void)addBtnClick
{
    if (self.numAddBlock) {
        self.numAddBlock();
        self.selectBtn.selected = YES; ///点击➕加号的时候全选
    }
}

//数量减按钮
-(void)cutBtnClick
{
    if (self.numCutBlock) {
        self.numCutBlock();
    }
}

-(void)reloadDataWith:(ShoppingCartModel*)model
{
    
    [self.imageView_cell sd_setImageWithURL:[NSURL URLWithString:model.mainImage]];
    self.nameLabel.text = model.productName;
//    self.productPrice.text =[NSString stringWithFormat:@"¥ %@元/kg" ,model.productPrice] ;
    
    
    if ([model.priceTypes isEqualToString:@"WEIGHT"]) {
        self.productPrice.text =[NSString stringWithFormat:@"%@元/kg",model.productPrice];
    }else{
        self.productPrice.text =[NSString stringWithFormat:@"%@/件",model.productPrice];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.productPrice.text];
    NSRange range1 = [[str string] rangeOfString:model.productPrice];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
    self.productPrice.attributedText = str;
  
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)model.quatity];
    self.sizeLabel.text = model.productSize;
    
    
    if (model.productStatus == 11) {//上架
        self.deleteBtn.hidden = YES;
        self.addBtn.hidden = NO;
        self.cutBtn.hidden = NO;
        self.numberLabel.hidden = NO;
        
        [self.selectBtn setImage:[UIImage imageNamed:@"no_selected"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        
        
        [self.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_highlight"] forState:UIControlStateHighlighted];
        [self.cutBtn setImage:[UIImage imageNamed:@"cut"] forState:UIControlStateNormal];
        [self.cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_highlight"] forState:UIControlStateHighlighted];
        self.selectBtn.userInteractionEnabled = YES;
//        [self.deleteBtn removeFromSuperview];
        
        
        
    }else{///下架
        self.selectBtn.userInteractionEnabled = NO;
        model.productChecked = 0;
        [self.selectBtn setImage:[UIImage imageNamed:@"已下架"] forState:UIControlStateNormal];
        self.productPrice.textColor = RGB(136, 136, 136, 1);
        self.nameLabel.textColor = RGB(136, 136, 136, 1);
        
        self.deleteBtn.hidden = NO;

        self.addBtn.hidden = YES;
        self.cutBtn.hidden = YES;
        self.numberLabel.hidden = YES;

//        [self.addBtn removeFromSuperview];
//        [self.cutBtn removeFromSuperview];
//        [self.numberLabel removeFromSuperview];
//
    }
    
    if (model.productChecked == 0)
    {
        self.isSelected = NO;
    }else if (model.productChecked == 1)
    {
        self.isSelected = YES;
    }
    
    self.selectBtn.selected = self.isSelected;
    
   
    

}
-(void)setupMainView
{
    //白色背景
    self.bgView = [[UIView alloc]init];
    self.bgView .backgroundColor = [UIColor whiteColor];
//    bgView.layer.borderColor = kUIColorFromRGB(0xEEEEEE).CGColor;
//    bgView.layer.borderWidth = 1;
    [self addSubview:self.bgView ];
    
    //选中按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.selected = self.isSelected;
    [self.selectBtn setImage:[UIImage imageNamed:@"no_selected"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView  addSubview:self.selectBtn];
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.backgroundColor = kUIColorFromRGB(0xF3F3F3);
    [self.bgView  addSubview:imageBgView];
    
    //显示照片
    self.imageView_cell = [[UIImageView alloc]init];
    //self.imageView_cell.image = [UIImage imageNamed:@"default_pic_1"];
   // self.imageView_cell.contentMode = UIViewContentModeScaleAspectFit;
    [self.bgView  addSubview:self.imageView_cell];
    
    //商品名
    self.nameLabel = [[UILabel alloc]init];
    //self.nameLabel.text = @"海报";
    self.nameLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    self.nameLabel.textColor = RGB(51, 51, 51, 1);
    [self.bgView  addSubview:self.nameLabel];
    
    //尺寸
    self.sizeLabel = [[UILabel alloc]init];
    //    self.sizeLabel.text = @"尺寸:58*86cm";
    self.sizeLabel.textColor = RGBCOLOR(132, 132, 132);
    self.sizeLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
    [self.bgView  addSubview:self.sizeLabel];
    
    //价格
    self.productPrice = [[UILabel alloc]init];
    self.productPrice.font = [UIFont systemFontOfSize:15.0f*kScale];
    self.productPrice.textColor =RGBCOLOR(136, 136, 136);
    //    self.dateLabel.text = @"2015-12-03 17:49";
    [self.bgView  addSubview:self.productPrice];
    
//    //价格
//    self.priceLabel = [[UILabel alloc]init];
//    //    self.priceLabel.text = @"￥100.11";
//    self.priceLabel.font = [UIFont boldSystemFontOfSize:16];
//    self.priceLabel.textColor = BASECOLOR_RED;
//    self.priceLabel.textAlignment = NSTextAlignmentCenter;
//    [bgView addSubview:self.priceLabel];
    
    //数量加按钮
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView  addSubview:self.addBtn];
    
    //数量减按钮
    self.cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [self.cutBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView  addSubview:self.cutBtn];
    
    //数量显示
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"1";
    self.numberLabel.font = [UIFont systemFontOfSize:15*kScale];
    [self.bgView  addSubview:self.numberLabel];
    
    ///删除按钮
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    [self.bgView  addSubview:self.deleteBtn];
    
#pragma mark - 添加约束
    
    //白色背景
    [self.bgView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(15*kScale);
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(0);
        
    }];
    
    //选中按钮
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView ).offset(15*kScale);
        make.centerY.equalTo(self.bgView);
        make.width.equalTo(@(30*kScale));
        make.height.equalTo(@(30*kScale));
    }];
    
    //图片背景
    [imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(0);
        make.left.equalTo(self.selectBtn.mas_right).offset(15*kScale);
        make.bottom.equalTo(self.bgView).offset(0);
        make.width.equalTo(@(90*kScale));
    }];
    
    //显示图片
    [self.imageView_cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageBgView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //商品名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBgView.mas_right).offset(10*kScale);
        make.top.equalTo(self.bgView).offset(0);
        make.height.equalTo(@(15*kScale));
        make.right.equalTo(self.bgView.mas_right).offset(-10*kScale);
    }];
    
    //商品尺寸
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBgView.mas_right).offset(10*kScale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5*kScale);
        make.height.equalTo(@(20*kScale));
        make.width.equalTo(self.nameLabel);
    }];
    
    //商品价格
    [self.productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBgView.mas_right).offset(10*kScale);
        make.bottom.equalTo(self.bgView).offset(0);
        make.height.equalTo(@(20*kScale));
        make.right.equalTo(self.cutBtn.mas_left);
    }];
    
    //商品价格
//    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLabel.mas_right).offset(5);
//        make.right.equalTo(bgView);
//        make.top.equalTo(bgView).offset(10);
//        make.width.equalTo(self.nameLabel);
//    }];
    
    //数量加按钮
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15*kScale);
        make.bottom.equalTo(self.bgView).offset(0);
        make.height.equalTo(@(30*kScale));
        make.width.equalTo(@(30*kScale));
    }];
    
    //数量显示
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addBtn.mas_left);
        make.bottom.equalTo(self.addBtn);
        make.width.equalTo(@(30*kScale));
        make.height.equalTo(self.addBtn);
    }];
    
    //数量减按钮
    [self.cutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberLabel.mas_left);
        make.height.equalTo(self.addBtn);
        make.width.equalTo(self.addBtn);
        make.bottom.equalTo(self.addBtn);
    }];
    
    ///删除按钮
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15*kScale);
        make.bottom.equalTo(self.bgView).offset(0);
        make.height.equalTo(@(30*kScale));
        make.width.equalTo(@(30*kScale));
    }];

}









@end
