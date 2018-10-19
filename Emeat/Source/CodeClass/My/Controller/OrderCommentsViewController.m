//
//  OrderCommentsViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/10/11.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "OrderCommentsViewController.h"
#import "OrderCommentsTableViewCell.h"
#import "WaitCommentViewController.h"

#import "TZImagePickerController.h"
#import "MHUploadParam.h"
#import "AFHTTPSessionManager.h"
#import "MyOrderViewController.h"

@interface OrderCommentsViewController ()<UITableViewDelegate ,UITableViewDataSource ,TZImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *allImageMarray;
@property (nonatomic,strong) OrderCommentsTableViewCell *cell1;

@property (nonatomic,strong) UIButton *submitBtn;

///评价标签
@property (nonatomic,strong) NSString *commentsLabels;
///评价星星
@property (nonatomic,strong) NSString *commentsSrarts;
///评价照片
@property (nonatomic,strong) NSString *commentsPicture;

///已选择照片
@property (nonatomic,strong) NSMutableArray *selectedAssets;

@property (nonatomic,strong) NSMutableArray *selectedImageMarray;



@end

@implementation OrderCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"评价详情";
    self.allImageMarray = [NSMutableArray array];
    self.selectedAssets = [NSMutableArray array];
    self.selectedImageMarray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self showNavBarItemRight];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(44));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-LL_TabbarSafeBottomMargin);
    }];
    
    self.commentsLabels = @"口感很棒,价格便宜";
    self.commentsSrarts = @"5";
}



#pragma mark ========提交评价

-(void)submitBtnAction{
    
    if (self.cell1.commentsTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写评价"];
    }else{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [dic setValue:self.orderNo forKey:@"orderNo"];
    [dic setValue:self.commentsSrarts forKey:@"evaluationStar"];
    [dic setValue:self.commentsLabels forKey:@"evaluationTable"];
    [dic setValue:self.cell1.commentsTextView.text forKey:@"evaluationDetail"];
    [dic setValue:self.commentsPicture forKey:@"picture"];
    
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    DLog(@"评价 dic === %@" ,dic);
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/order/create_order_evaluation",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        DLog(@"提交评价 ===%@" ,returnData);
        
        if ([returnData[@"status"] integerValue] == 200) {
            
            [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionTransitionNone animations:^{
                
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            } completion:^(BOOL finished) {
                
                for (UIViewController *vc in self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[MyOrderViewController class]]) {
                        MyOrderViewController *mainVC = (MyOrderViewController *)vc;
                        [self.navigationController popToViewController:mainVC animated:YES];
                    }
                }
                
            }];
           
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
        
    }
}

-(UIButton *)submitBtn{
    if (_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_submitBtn setTitle:@"提交" forState:0];
        _submitBtn.backgroundColor = RGB(231, 35, 36, 1);
        [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:1];
        
    }
    return _submitBtn;
}

#pragma mark=========设置客服

-(void)showNavBarItemRight{
    
    
    UIBarButtonItem *connectRightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"kefu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(connectRightItemAction)];
    
    
    
    [self.navBar pushNavigationItem:self.navItem animated:NO];
    [self.navItem setRightBarButtonItems:[NSArray arrayWithObjects: connectRightItem, nil]];
    
}

-(void)connectRightItemAction{
    // DLog(@"联系客服");
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001106111"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}


-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin-44) style:UITableViewStyleGrouped];
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
    
    [cell1.sendImageBtn addTarget:self action:@selector(sendImageBtnAction:) forControlEvents:1];
    [cell1.sendImageBtn2 addTarget:self action:@selector(sendImageBtnAction:) forControlEvents:1];
    [cell1.sendImageBtn3 addTarget:self action:@selector(sendImageBtnAction:) forControlEvents:1];
   
    [cell1.deleteImvBtn addTarget:self action:@selector(deleteImvBtnAction:) forControlEvents:1];
    [cell1.deleteImvBtn2 addTarget:self action:@selector(deleteImvBtnAction:) forControlEvents:1];
    [cell1.deleteImvBtn3 addTarget:self action:@selector(deleteImvBtnAction:) forControlEvents:1];
    cell1.deleteImvBtn.tag = 0;
    cell1.deleteImvBtn2.tag = 1;
    cell1.deleteImvBtn3.tag = 2;

    
    cell1.returnCommentsLabels = ^(NSString *commets) {
        self.commentsLabels = commets;
        DLog(@"选择的标签====%@" ,commets);
    };

    cell1.returnCommentsStarts = ^(NSString *commets) {
        self.commentsSrarts = commets;
        DLog(@"选择的星星=====%@" ,commets);
    };
    self.cell1 = cell1;
    
    return cell1;
}



-(void)deleteImvBtnAction:(UIButton*)btn{
    
    DLog(@"删除===%ld" ,(long)btn.tag);
    if (self.selectedImageMarray.count != 0) {
        
        [self.selectedImageMarray removeObjectAtIndex:btn.tag];
        [self.selectedAssets removeObjectAtIndex:btn.tag];
        [self postImageDta:self.selectedImageMarray isPost:@"0"];
        
    }
    
    
}



#pragma mark ========上传评价照片

-(void)sendImageBtnAction:(UIButton*)btn{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组

    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.selectedAssets = [NSMutableArray arrayWithArray:assets];
        self.selectedImageMarray = [NSMutableArray arrayWithArray:photos];
        
        [self postImageDta:photos isPost:@"1"];
    }];
    
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}


#pragma mark=============================上传评价照片
-(void)postImageDta:(NSArray*)array isPost:(NSString*)ispost{
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //    NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
//    NSData *data ;
//    for (int i = 0; i <array.count; i++) {
//        data = [self resetSizeOfImageData:array[i] maxSize:1024];
//
//    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    if ([ispost isEqualToString:@"1"]) {
        [SVProgressHUD showProgress:-1 status:@"正在上传,请稍等."];

    }else if ([ispost isEqualToString:@"0"]){
        
       // [SVProgressHUD showProgress:-1 status:@""];
        
        [SVProgressHUD showProgress:-1];
        
    }
    

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
            
            if ([ispost isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];

            }else if ([ispost isEqualToString:@"0"]){
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];

            }
            
            NSString *images = responseObject[@"data"];
            
            if (images.length == 0) {
                
                [self.allImageMarray removeAllObjects];
                [self.cell1.sendImageBtn setImage:[UIImage imageNamed:@"上传照片"] forState:0];

                [self.cell1.sendImageBtn2 setImage:[UIImage imageNamed:@""] forState:0];
                [self.cell1.sendImageBtn3 setImage:[UIImage imageNamed:@""] forState:0];
                
                [self.cell1.deleteImvBtn setImage:[UIImage imageNamed:@""] forState:0];
                [self.cell1.deleteImvBtn2 setImage:[UIImage imageNamed:@""] forState:0];
                [self.cell1.deleteImvBtn3 setImage:[UIImage imageNamed:@""] forState:0];


            }else{
            
            NSArray *array = [images componentsSeparatedByString:@","];
            [self.allImageMarray removeAllObjects];
            for (NSString *s in array) {
                [self.allImageMarray addObject:s];
            }
            if (self.allImageMarray.count ==1 ) {
               [self.cell1.sendImageBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.allImageMarray[0]]]] forState:0];
                [self.cell1.sendImageBtn2 setImage:[UIImage imageNamed:@"上传照片"] forState:0];
                [self.cell1.sendImageBtn3 setImage:[UIImage imageNamed:@""] forState:0];

                [self.cell1.deleteImvBtn setImage:[UIImage imageNamed:@"评价删除"] forState:0];
                [self.cell1.deleteImvBtn2 setImage:[UIImage imageNamed:@""] forState:0];
                [self.cell1.deleteImvBtn3 setImage:[UIImage imageNamed:@""] forState:0];

                
            }else if (self.allImageMarray.count ==2){
                [self.cell1.sendImageBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.allImageMarray[0]]]] forState:0];
                
                [self.cell1.sendImageBtn2 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.allImageMarray[1]]]] forState:0];

                [self.cell1.sendImageBtn3 setImage:[UIImage imageNamed:@"上传照片"] forState:0];
                
                [self.cell1.deleteImvBtn setImage:[UIImage imageNamed:@"评价删除"] forState:0];
                [self.cell1.deleteImvBtn2 setImage:[UIImage imageNamed:@"评价删除"] forState:0];
                [self.cell1.deleteImvBtn3 setImage:[UIImage imageNamed:@""] forState:0];

            }else if (self.allImageMarray.count ==3){
                [self.cell1.sendImageBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.allImageMarray[0]]]] forState:0];
                
                [self.cell1.sendImageBtn2 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.allImageMarray[1]]]] forState:0];
                
                [self.cell1.sendImageBtn3 setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.allImageMarray[2]]]] forState:0];
                [self.cell1.deleteImvBtn setImage:[UIImage imageNamed:@"评价删除"] forState:0];
                [self.cell1.deleteImvBtn2 setImage:[UIImage imageNamed:@"评价删除"] forState:0];
                [self.cell1.deleteImvBtn3 setImage:[UIImage imageNamed:@"评价删除"] forState:0];

            }           
            self.commentsPicture = [self.allImageMarray componentsJoinedByString:@","];
            DLog(@"评价照片=== %@" ,self.commentsPicture);
            }
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
