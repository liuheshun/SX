//
//  SHLBaseViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/13.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "SHLBaseViewController.h"

#import "ShoppingCartViewController.h"

#import <CommonCrypto/CommonDigest.h>


@interface SHLBaseViewController ()


@end

@implementation SHLBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBar];
    [self showNavBarLeftItem];
    [self addNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:)name:kRealReachabilityChangedNotification object:nil];
   // self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
  
}




- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];

    self.reachabilityStatus = status;
    if (status == RealStatusNotReachable)
    {
//        self.flagLabel.text = @"Network unreachable!";
       // DLog(@"无网络");
        
    }
    
    if (status == RealStatusViaWiFi)
    {
//        self.flagLabel.text = @"Network wifi! Free!";
        //DLog(@"wifi");

    }
    
    if (status == RealStatusViaWWAN)
    {
//        self.flagLabel.text = @"Network WWAN! In charge!";
    }
    
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    if (status == RealStatusViaWWAN)
    {
        if (accessType == WWANType2G)
        {
//            self.flagLabel.text = @"RealReachabilityStatus2G";
        }
        else if (accessType == WWANType3G)
        {
//            self.flagLabel.text = @"RealReachabilityStatus3G";
        }
        else if (accessType == WWANType4G)
        {
//            self.flagLabel.text = @"RealReachabilityStatus4G";
           // DLog(@"4444ggggggggggg");

        }
        else
        {
//            self.flagLabel.text = @"Unknown RealReachability WWAN Status, might be iOS6";
        }
    }
}




-(void)setNavBar{
    self.navigationController.navigationBarHidden = YES;
    
    self.navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kBarHeight)];
    self.navBgView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.navBgView];
  
    self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kStatusBarHeight)];
    self.statusBarView .backgroundColor = [UIColor whiteColor];
    ;
    [self.navBgView addSubview:self.statusBarView ];
    //创建一个导航栏
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kWidth, kTopBarHeight)];
    //创建一个导航栏集合
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        self.edgesForExtendedLayout=UIRectEdgeNone;
        
    }
    
    self.navBar.barTintColor = [UIColor whiteColor];
    self.navBar.translucent = NO;
    self.navItem = [[UINavigationItem alloc] init];
    
    [self.navBar pushNavigationItem:self.navItem animated:NO];
    //将标题栏中的内容全部添加到主视图当中
    // self.view.backgroundColor = [UIColor whiteColor];
    [self.navBgView addSubview:self.navBar];
    
    [self.navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f*kScale],NSForegroundColorAttributeName:[UIColor blackColor]}];
}

-(void)showNavBarLeftItem{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式 判断页面是否存在push
            //创建一个左边按钮
            self.leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
            [self.navBar pushNavigationItem:self.navItem animated:NO];
            [self.navItem setLeftBarButtonItem:self.leftButton];
            
        }
    }
    else{
        //present方式
    }
    
    
    
}


#pragma mark = 返回事件

-(void)leftItemAction{
    [SVProgressHUD dismiss];
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




-(void)showNavBarItemRight{
    
    //创建一个右边按钮
    //    self.rightButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"left_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    
    self.rightButton = [[UIBarButtonItem alloc] initWithTitle:self.rightButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction)];
    //self.rightButton.tintColor = [UIColor blackColor];

    [self.navBar pushNavigationItem:self.navItem animated:NO];
    [self.navItem setRightBarButtonItem:self.rightButton];
    
    [self.navItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f*kScale],NSForegroundColorAttributeName:RGB(136, 136, 136, 1)} forState:UIControlStateNormal];
    
  
    

}


-(void)getRightButtonTitle:(NSString *)rightButtonTitle{
    self.rightButtonTitle = rightButtonTitle;
}

-(void)rightItemAction{
    if ([self respondsToSelector:@selector(rightItemBlockAction)]) {
        self.rightItemBlockAction();
    }
}




/**
 * 设置button角标
 */
-(void)setButtonBadgeValue:(UIButton*)btn badgeValue:(NSString *)badgeValue badgeOriginX:(CGFloat)X  badgeOriginY:(CGFloat)Y{
    if ([badgeValue integerValue] != 0) {
        btn.badgeValue = badgeValue;
        btn.badgeBGColor = [UIColor redColor];
        btn.badgeTextColor = [UIColor whiteColor];
        btn.badgeOriginX = X;
        btn.badgeOriginY = Y;
    }
}




/**
 * 判断邮箱是否合法
 */
- (BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

/**
 * 提示信息
 */
-(void)alertMessage:(NSString *)message willDo:(void(^)(void))result{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:result];
    
}



#pragma mark 判断手机格式是否正确
-(BOOL)checkTel:(NSString *)tel{
    
    NSString *  mobile = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
              
        NSString *regex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        if (isMatch1) {
            return YES;
        }else{
            return NO;
        }
    }
    
}








//判断是否含有非法字符 yes 有  no没有 （非法字符是指 除数字 字母 文字以外的所有字符）
- (BOOL)containTheillegalCharacter:(NSString *)content{
    //提示 标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}










//判断是否输入了emoji 表情
- (BOOL)checkStringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                    
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }else if (hs == 0x200d){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}



#pragma mark==切图片圆角==

-(id)createRoundedRectImage:(UIImage*)image size:(CGSize)size ovalWidth:(float)ovalWidth  ovalHeight:(float)ovalHeight  {
    //the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage * img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4*w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, ovalWidth, ovalHeight);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    return [UIImage imageWithCGImage:imageMasked];
}


static void addRoundedRectToPath(CGContextRef context,CGRect rect, float ovalWidth, float ovalHeight){
    float fw , fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect)/ovalWidth;
    fh = CGRectGetHeight(rect)/ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);//start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);//Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);//Top Left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);//Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);//Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    
}













- (NSString *)flattenHTML:(NSString *)html {
    
    //  过滤html标签
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //  过滤html中的\n\r\t换行空格等特殊符号
    NSMutableString *str1 = [NSMutableString stringWithString:html];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        
        //  在这里添加要过滤的特殊符号
        if ( c == '\r' || c == '\n' || c == '\t' ) {
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    html  = [NSString stringWithString:str1];
    return html;
}


#pragma mark ==================时间戳转日期字符串

-(NSString*)returnTimeStringWithTimeStamp:(NSString*)timeStamp{
    
    
        // timeStampString 是服务器返回的13位时间戳
        NSString *timeStampString  = timeStamp;
        // iOS 生成的时间戳是10位
        NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
}



///

// 接受通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IncreaseShoppingCart:) name:@"shoppingCart" object:nil];
    
}

// 接收通知的操作
- (void)IncreaseShoppingCart:(NSNotification *)notification{
//    UIViewController *shoppingVC = self.childViewControllers[1];
//      NSDictionary * infoDic = [notification object];
    NSInteger shoppingIndex = [GlobalHelper shareInstance].shoppingCartBadgeValue;
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
    //
    if (shoppingIndex == 0) {
        item.badgeValue = nil;
        return;
    }
    
    if (shoppingIndex >99) {
        item.badgeValue = @"99+" ;
    }else
    {
    item.badgeValue = [NSString stringWithFormat:@"%ld" ,shoppingIndex];
    }
}

// 注销通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}






///sha1加密方式

- (NSString *) sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

//1970获取当前时间转为时间戳
- (NSString *)dateTransformToTimeSp{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%llu",recordTime];
    return timeSp;
}

///随机数

-(NSString *)ret32bitString

{
    
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark == ====校验数据
///校验数据
-(NSMutableDictionary*)checkoutData{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setValue:secret forKey:@"secret"];
    [dic setValue:nonce forKey:@"nonce"];
    [dic setValue:curTime forKey:@"curTime"];
    [dic setValue:checkSum forKey:@"checkSum"];
    [dic setValue:ticket forKey:@"ticket"];
    
    return dic;
}





#pragma mark = 加入购物车数据

-(void)addCartPostDataWithProductId:(NSInteger)productId homePageModel:(HomePageModel*)model NSIndexPath:(NSIndexPath*)indexPath cell:(HomePageTableViewCell*)weakCell isFirstClick:(BOOL)isFirst tableView:(UITableView*)tableView{
    //[SVProgressHUD show];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [dic setValue:mTypeIOS forKey:@"mtype"];
#pragma mark---------------------------------需要更改productID--------------------------------
    
    //[dic setObject:[NSString stringWithFormat:@"%ld" ,productId] forKey:@"productId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,(long)productId] forKey:@"commodityId"];
    [dic setObject:@"1" forKey:@"quatity"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]) {
        
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([[user valueForKey:@"approve"] isEqualToString:@"1"]){
        
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
    //DLog(@"加入购物车 ==== %@" , dic);
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/add",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {

        if ([returnData[@"code"]  isEqualToString:@"0404"] || [returnData[@"code"]  isEqualToString:@"04"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"0" forKey:@"isLoginState"];
            LoginViewController *VC = [LoginViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
        
        
        
        if ([returnData[@"status"] integerValue] == 200){
            //            SVProgressHUD.minimumDismissTimeInterval = 0.5;
            //            SVProgressHUD.maximumDismissTimeInterval = 1;
            //            [SVProgressHUD showSuccessWithStatus:returnData[@"msg"]];
            //加入购物车动画
            NSInteger count = [weakCell.cartView.numberLabel.text integerValue];
            count++;
            weakCell.cartView.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            model.number = count ;
            if (isFirst == YES) {
                model.number = 1;
                
            }
            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
            //获取当前cell 相对于self.view 当前的坐标
            rect.origin.y = rect.origin.y - [tableView contentOffset].y;
            CGRect imageViewRect = weakCell.mainImv.frame;
            if (tableView.tag == 100) {///来自分来列表
                imageViewRect.origin.y = rect.origin.y+imageViewRect.origin.y+kBarHeight+116;

            }else{
            imageViewRect.origin.y = rect.origin.y+imageViewRect.origin.y;
            }
            
            [[PurchaseCarAnimationTool shareTool]startAnimationandView:weakCell.mainImv andRect:imageViewRect andFinisnRect:CGPointMake(ScreenWidth/5*3, ScreenHeight-49) topView:self.view andFinishBlock:^(BOOL finish) {
                
                
                UIView *tabbarBtn = self.tabBarController.tabBar.subviews[3];
                [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
            }];
            [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            
            if ([[GlobalHelper shareInstance].addShoppingCartMarray containsObject:model]) {
                [[GlobalHelper shareInstance].addShoppingCartMarray removeObject:model];
                [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            }
            
            [GlobalHelper shareInstance].shoppingCartBadgeValue += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
            
            
            
        }
        else
        {
            //            model.number = 0;
            
            SVProgressHUD.minimumDismissTimeInterval = 0.5;
            SVProgressHUD.maximumDismissTimeInterval = 2;
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
       // DLog(@"首页加入购物车== id=== %ld  %@" ,productId,returnData);
        [tableView reloadData];
    } failureBlock:^(NSError *error) {

       // DLog(@"首页加入购物车error ========== id= %ld  %@" ,productId,error);
        
    } showHUD:NO];
    
}

#pragma mark = 从购物车减去

-(void)cutCartPostDataWithProductId:(NSInteger)productId  homePageModel:(HomePageModel*)model NSIndexPath:(NSIndexPath*)indexPath cell:(HomePageTableViewCell*)weakCell{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [dic setObject:[NSString stringWithFormat:@"%ld" , productId] forKey:@"commodityId"];
    [dic setObject:@"-1" forKey:@"quatity"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/update" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        if ([returnData[@"status"] integerValue] == 200)
        {
            NSInteger count = [weakCell.cartView.numberLabel.text integerValue];
            
            count--;
            NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
            weakCell.cartView.numberLabel.text = numStr;
            model.number = count;
            //购物车角标
            [GlobalHelper shareInstance].shoppingCartBadgeValue -= 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
            
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        //DLog(@"减去购物车==  %@" ,returnData);
    } failureBlock:^(NSError *error) {
        
       // DLog(@"减去购物车error==  %@" ,error);
        
    } showHUD:NO];
    
    
}



#pragma mark =========================购物车数量
-(void)requestBadNumValue{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/get_cart_product_count" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"code"]  isEqualToString:@"0404"] || [returnData[@"code"]  isEqualToString:@"04"]) {
           
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"0" forKey:@"isLoginState"];
            [GlobalHelper shareInstance].shoppingCartBadgeValue = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
        }
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            [GlobalHelper shareInstance].shoppingCartBadgeValue = [returnData[@"data"] integerValue];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
        }
        
        //DLog(@"购物车数量==  %@" ,returnData);
    } failureBlock:^(NSError *error) {
        
        //DLog(@"购物车数量error==  %@" ,error);
        
    } showHUD:NO];
}


#pragma mark = 加入购物车商品数量为0时 删除整个商品

-(void)deleteProductPostDataWithProductId:(NSInteger)productId homePageModel:(HomePageModel*)model tableView:(UITableView*)tableView{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)productId] forKey:@"commodityIds"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/delete_product", baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"status"]integerValue] == 200) {
            model.number = 0;
            [[GlobalHelper shareInstance].addShoppingCartMarray removeObject:model];
            [self requestBadNumValue];
            [tableView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        //DLog(@"删除 == %@" , returnData);
        
    } failureBlock:^(NSError *error) {
        //DLog(@"删除error == %@" , error);
        
        
    } showHUD:NO];
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
