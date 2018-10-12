//
//  OrderCommentsViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/10/11.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "OrderCommentsViewController.h"
#import "OrderCommentsTableViewCell.h"



#import "TZImagePickerController.h"
#import "MHUploadParam.h"
#import "AFHTTPSessionManager.h"

@interface OrderCommentsViewController ()<UITableViewDelegate ,UITableViewDataSource ,TZImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;


@end

@implementation OrderCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"评价详情";
    [self.view addSubview:self.tableView];
    
}



-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = RGB(238, 238, 238, 1);;
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 310*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.001*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderCommentsTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"comments_list_cell"];
    if (cell1 == nil) {
        cell1 = [[OrderCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comments_list_cell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    
    [cell1.sendImageBtn addTarget:self action:@selector(sendImageBtnAction) forControlEvents:1];
    
    return cell1;
}

#pragma mark ========上传评价照片

-(void)sendImageBtnAction{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self postImageDta:photos];
    }];
    
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}


#pragma mark=============================上传评价照片
-(void)postImageDta:(NSArray*)array{
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //    NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
    NSData *data ;
    for (int i = 0; i <array.count; i++) {
        data = [self resetSizeOfImageData:array[i] maxSize:1024];
        
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [SVProgressHUD showProgress:-1 status:@"正在上传,请稍等."];

    NSString* path = [[NSString stringWithFormat:@"%@/m/auth/order/up_pic" ,baseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manager POST:path parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < array.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
            UIImage *image = array[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.28);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i+1] fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"上传评价照片=%@ ",responseObject);
        if ([[NSString stringWithFormat:@"%@" , responseObject[@"status"]] isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
           
            
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"上传评价照片error=%@ ",error);

        [SVProgressHUD showErrorWithStatus:@"上传失败"];
        //        if (failure == nil) return ;
        //  failure();
    }];
}



#pragma mark==================图片压缩===========================
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    CGFloat tempHeight = newSize.height / maxSize;
    CGFloat tempWidth = newSize.width / maxSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / maxSize;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
