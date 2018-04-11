//
//  AF_BrandCell.m
//  差五个让步
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 Elephant. All rights reserved.
//

#import "AF_BrandCell.h"

#define offset [UIScreen mainScreen].bounds.size.width - 84
#define buttonBackgroundColor [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]

@interface AF_BrandCell ()
{
    NSMutableArray *buttonArr;
}

@end

@implementation AF_BrandCell

+ (instancetype)cellWithTableView:(UITableView *)tableView dataArr:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath
{
    NSString * baseCell = [NSString stringWithFormat:@"Brand%ld", indexPath.section];
    AF_BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:baseCell];
    if (!cell) {
        cell = [[AF_BrandCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseCell dataArr:arr];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dataArr:(NSMutableArray *)arr
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        buttonArr = [NSMutableArray array];
        self.buttonArrays = [NSMutableArray array];
        for (int i=0; i< arr.count; i++) {
            UIButton *button = [[UIButton alloc]init];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            button.tag = i;
            [button setBackgroundColor:[UIColor  whiteColor]];
            button.layer.borderWidth = 1;
            button.layer.borderColor = RGB(138, 138, 138, 1).CGColor;
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 5.0;
            [button setTitleColor:RGB(138, 138, 138, 1) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [buttonArr addObject:button];
            [self.buttonArrays addObject:button];

        }
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    if (!button.selected) {
        button.selected = YES;
        [button setBackgroundColor:RGB(236, 31, 35, 1)];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = RGB(236, 31, 35, 1).CGColor;
        [self.delegate selectedValueChangeBlock:self.tag key:button.tag value:@"YES" button:button];
    }else {
        button.selected = NO;
        [button setBackgroundColor:[UIColor  whiteColor]];
        button.layer.borderWidth = 1;
        button.layer.borderColor = RGB(138, 138, 138, 1).CGColor;
        [self.delegate selectedValueChangeBlock:self.tag key:button.tag value:@"NO" button:button];
    }
}

-(void)regiestButton:(NSMutableArray *)allArray{

    for (UIButton*button in allArray) {
        button.selected = NO;
        [button setBackgroundColor:[UIColor  whiteColor]];
        button.layer.borderWidth = 1;
        button.layer.borderColor = RGB(138, 138, 138, 1).CGColor;
        [self.delegate selectedValueChangeBlock:self.tag key:button.tag value:@"NO" button:button];    }
    
}


- (void)setSelectedArr:(NSMutableArray *)selectedArr
{
    for (int i = 0; i < selectedArr.count; i++) {
        UIButton *button = buttonArr[i];
        //是否为选中状态
        NSString *selectedStr = selectedArr[i];
        if ([selectedStr isEqualToString:@"YES"]) {
            button.selected = YES;
            [button setBackgroundColor:[UIColor redColor]];
            button.layer.borderWidth = 0.0;
            button.layer.borderColor = [UIColor redColor].CGColor;
            
        }else {
            button.selected = NO;
            [button setBackgroundColor:[UIColor whiteColor]];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = RGB(138, 138, 138, 1).CGColor;

        }
    }
}

- (void)setAttributeArr:(NSMutableArray *)attributeArr
{
    /** 九宫格布局算法 */
    CGFloat spacing = 15.0;//行、列 间距
    int totalloc = 3;//列数
    CGFloat appvieww = (offset - spacing*4)/totalloc;
    CGFloat appviewh = 25;
    int row = 0 ;
    for (int i=0; i< attributeArr.count; i++) {
        row = i/totalloc;//行号
        int loc = i%totalloc;//列号
        
        CGFloat appviewx = spacing + (spacing + appvieww) * loc;
        CGFloat appviewy = spacing + (spacing + appviewh) * row;
        
        UIButton *button = buttonArr[i];
        
        button.frame = CGRectMake(appviewx, appviewy, appvieww, appviewh);
        
        [button setTitle:[attributeArr[i][@"dataName"] stringByReplacingOccurrencesOfString:@" " withString:@""]
   forState:UIControlStateNormal];

    }
        _height = (spacing + appviewh) * (row + 1) + spacing;

}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
