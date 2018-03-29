//
//  HomePageShoppingDetailsTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/1/24.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageShoppingDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation HomePageShoppingDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.detailsImv];
       // [self setFrame];
    }
    return self;
}

-(UIImageView *)detailsImv{
    if (!_detailsImv) {
        _detailsImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 300)];
        _detailsImv.backgroundColor = [UIColor whiteColor];
    }
    return _detailsImv;
}




-(void)configCell:(HomePageModel *)model forIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
//    [self.detailsImv sd_setImageWithURL:[NSURL URLWithString:model.commodityDetail]];
   DLog(@"aaaaaaasdddddddddddddddd===========%@" ,model.commodityDetail);
    
//    // 先从缓存中查找图片
//    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: self.imgArray[indexPath.row]];
//    
//    // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
//    if (!image) {
//        image = [UIImage imageNamed:kDownloadImageHolder];
//    }
//    
   
    
    
    
    NSString *imgURL = model.commodityDetail;
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    
    
    if ( !cachedImage ) {
        [self downloadImage:model.commodityDetail forIndexPath:indexPath tableView:tableView];
       // [cell.btn setBackgroundImage:[UIImage imageNamed:kDownloadImageHolder] forState:UIControlStateNormal];
       self.detailsImv.image = [UIImage imageNamed:@"small_placeholder"];
        UIImage * cachedImage = self.detailsImv.image;
        //手动计算cell
        CGFloat imgHeight = cachedImage.size.height * [UIScreen mainScreen].bounds.size.width / cachedImage.size.width;
        CGRect rect = self.detailsImv.frame;
        rect.size.height = imgHeight;
        self.detailsImv.frame = rect;
        
    } else {
        //[cell.btn setBackgroundImage:cachedImage forState:UIControlStateNormal];
        self.detailsImv.image = cachedImage;
        
        //手动计算cell
        CGFloat imgHeight = cachedImage.size.height * [UIScreen mainScreen].bounds.size.width / cachedImage.size.width;
        CGRect rect = self.detailsImv.frame;
        rect.size.height = imgHeight;
        self.detailsImv.frame = rect;
    }
    
 
}


- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
       
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES completion:^{
            
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [tableView reloadData];
                    });
        
    }];
 
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
