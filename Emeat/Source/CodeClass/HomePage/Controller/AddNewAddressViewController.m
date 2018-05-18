//
//  AddNewAddressViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/4.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "AddNewAddressViewController.h"
#import "AddNewAddressView.h"
#import "SearchLocationAddressViewController.h"

#define kMaxNumber 20

@interface AddNewAddressViewController ()
@property (nonatomic,strong) AddNewAddressView *addNewAddressView;
///保存
@property (nonatomic,strong) UIButton *saveBtn;
///删除
@property (nonatomic,strong) UIButton *removeBtn;

@property (nonatomic,strong) NSMutableDictionary *addressDic;
///收货人姓名
@property (nonatomic,strong) NSString *receiverName;
///收货人电话
@property (nonatomic,strong) NSString *receiverPhone;
///收货人地址
@property (nonatomic,strong) NSString *receiverProvince;
///收货人详细地址
@property (nonatomic,strong) NSString *receiverAddress;
///收货人地址类型
@property (nonatomic,assign) NSInteger shippingCategory;


@end

@implementation AddNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = self.navTitle;
    self.rightButtonTitle = @"保存";
    [self showNavBarItemRight];
    [self addBlockAction];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.addNewAddressView];
    self.addressDic = [NSMutableDictionary dictionary];

    DLog(@"111111111111111111============%@" , self.receiverAddress);

    if (_isCanRemove == NO) {
        DLog(@"22222222222222222============%@" , self.receiverAddress);
        [self.view addSubview:self.removeBtn];
        [self setRemoveBtnFrame];
        [self.addNewAddressView configAddressView:self.postMyAddressModel];

        self.receiverName = self.postMyAddressModel.receiverName;
        self.receiverPhone =[NSString stringWithFormat:@"%ld" , self.postMyAddressModel.receiverPhone] ;
        self.receiverProvince = self.postMyAddressModel.receiverProvince;
        self.receiverAddress = self.postMyAddressModel.receiverAddress;
        
    }
}


-(void)addAddressData{
    [SVProgressHUD show];
    
    NSMutableDictionary *checkDic = [self checkoutData];
    [self.addressDic setValuesForKeysWithDictionary:checkDic];
    
    DLog(@"地址详细字典======== ==== %@" ,self.addressDic);
    NSString *url;
    if (_isCanRemove == NO) {
        //DLog(@"更新地址");
        [self.addressDic setValue:[NSString stringWithFormat:@"%ld" ,self.postMyAddressModel.id] forKey:@"id"];
        url =[NSString stringWithFormat:@"%@/auth/shipping/update" ,baseUrl];
    }else{
       // DLog(@"新增地址");
        url =[NSString stringWithFormat:@"%@/auth/shipping/add" ,baseUrl];
    }
    
    [MHNetworkManager postReqeustWithURL:url params:self.addressDic successBlock:^(NSDictionary *returnData) {
        DLog(@"新增收货地址===== %@ %@ " ,returnData, returnData[@"msg"]);
        self.rightButton.enabled = YES;

        if ([returnData[@"status"] integerValue] == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            SVProgressHUD.minimumDismissTimeInterval = 1;
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
        [SVProgressHUD dismiss];

    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

        DLog(@"新增收货地址错误=== %@" , error);
        self.rightButton.enabled = YES;

    } showHUD:NO];
    
  
}

#pragma mark = 删除收货地址

-(void)removeBtnAction{
    
    DLog(@"删除地址");
    [SVProgressHUD show];
    NSMutableDictionary *dic = [self checkoutData];
    
    [dic setValue:[NSString stringWithFormat:@"%ld" ,self.postMyAddressModel.id] forKey:@"shippingId"];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/shipping/del" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        if ([returnData[@"status"] integerValue] == 200) {
            [SVProgressHUD dismiss];

            [self.navigationController popViewControllerAnimated:YES];
        }
        DLog(@"删除收货地址===== %@ %@ " ,returnData, returnData[@"msg"]);
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

        DLog(@"删除收货地址错误=== %@" , error);
    } showHUD:NO];
    
    
    
}


-(void)addBlockAction{
    __weak __typeof(self) weakSelf = self;
 
#pragma mark = 保存收货地址
    
    self.rightItemBlockAction = ^{
        [weakSelf.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
        DLog(@"保存 = = 名字= %@  电话==%@  省== %@    详细地址== %@  shippid== %ld" , weakSelf.receiverName, weakSelf.receiverPhone ,weakSelf.receiverProvince , weakSelf.receiverAddress  ,weakSelf.shippingCategory);
    
        if (weakSelf.receiverName.length == 0 || weakSelf.receiverPhone.length == 0 || weakSelf.receiverProvince.length == 0 || weakSelf.receiverAddress.length == 0) {
            [weakSelf alertMessage:@"请填写完整的收货地址信息" willDo:nil];
        }else{
            
            if ([weakSelf checkTel:weakSelf.receiverPhone] == NO) {
                
                [weakSelf alertMessage:@"请填写正确格式的手机号" willDo:nil];

            }else if ([weakSelf containTheillegalCharacter:weakSelf.receiverName] == YES){
                
                [weakSelf alertMessage:@"姓名或详细地址不能包含特殊字符" willDo:nil];

            }else if ([weakSelf containTheillegalCharacter:weakSelf.receiverAddress] == YES){
                [weakSelf alertMessage:@"姓名或详细地址不能包含特殊字符" willDo:nil];
            }else{

                [weakSelf.addressDic setValue:weakSelf.receiverName forKey:@"receiverName"];
                [weakSelf.addressDic setValue:weakSelf.receiverPhone forKey:@"receiverPhone"];
                [weakSelf.addressDic setValue:[NSString stringWithFormat:@"%@"  ,weakSelf.receiverAddress] forKey:@"receiverAddress"];///收货人详细地址:receiverAddress
        
                [weakSelf.addressDic setValue:[NSString stringWithFormat:@"%@" ,weakSelf.receiverProvince] forKey:@"receiverProvince"];
        
                if (weakSelf.shippingCategory ==0 ) {
                    weakSelf.shippingCategory = 1;//默认标签
                }

                [weakSelf.addressDic setValue:[NSString stringWithFormat:@"%ld" ,weakSelf.shippingCategory] forKey:@"shippingCategory"];
                weakSelf.rightButton.enabled = NO;
                [weakSelf addAddressData];
            }
        
        }
    
    };
    
    self.addNewAddressView.textFieldTitleBlock = ^(NSMutableDictionary *dic) {
        
        weakSelf.receiverAddress = [dic valueForKey:@"addressDetails"];
        weakSelf.receiverName = [dic valueForKey:@"name"];
        weakSelf.receiverPhone = [dic valueForKey:@"phoneNumer"];
    };
    
    self.addNewAddressView.lableTitleBlock = ^(NSInteger labelInter) {
        
        weakSelf.shippingCategory = labelInter;
    };

    self.addNewAddressView.addressTitleBlockClickAction = ^(NSMutableDictionary *dic) {
        
        SearchLocationAddressViewController *VC = [SearchLocationAddressViewController new];

        VC.returnSearchAddressBlock = ^(Location *location) {
            
            if ([location.administrativeArea isEqualToString:location.city]) {//判断是否为直辖市
                 weakSelf.addNewAddressView.textFieldCity.text = [NSString stringWithFormat:@"%@%@" ,location.city,location.subLocality];
                weakSelf.receiverProvince = location.city;
            }else{
            weakSelf.addNewAddressView.textFieldCity.text = [NSString stringWithFormat:@"%@%@%@" ,location.administrativeArea ,location.city,location.subLocality];
                
                weakSelf.receiverProvince = location.administrativeArea;
            }
            weakSelf.addNewAddressView.textFieldSubstreet.text = [NSString stringWithFormat:@"%@%@",location.thoroughfare ,location.name];
            
            weakSelf.receiverProvince = [NSString stringWithFormat:@"%@,%@" ,weakSelf.addNewAddressView.textFieldCity.text ,weakSelf.addNewAddressView.textFieldSubstreet.text ];
           
        };
        [weakSelf.navigationController pushViewController:VC animated:YES];
        DLog(@"进入选着地址页面");
        
    };
    
    
}





-(void)phoneNumTextFieldTextFieldDidChange:(UITextField*)textField{
    
    if (textField.text.length > 11)
    {
        textField.text = [textField.text substringToIndex:11];
    }
    
    DLog(@"sssss== %@" ,textField.text);
    
    if (textField.text.length == 11) {
        if (![self checkTel:textField.text] ) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确手机号码"];
        }
        
    }
}

-(void)textFieldNameTextFieldDidChange:(UITextField*)textField{
    if (kMaxNumber == 0) return;
    
    NSString *toBeString = textField.text;
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        //判断markedTextRange是不是为Nil，如果为Nil的话就说明你现在没有未选中的字符，
        //可以计算文字长度。否则此时计算出来的字符长度可能不正确
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分(感觉输入中文的时候才有)
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            //中文和字符一起检测  中文是两个字符
            if ([toBeString getStringLenthOfBytes] > kMaxNumber)
            {
                textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
                [SVProgressHUD showInfoWithStatus:@"姓名长度10字以内"];

            }
        }
    }
    else
    {
        if ([toBeString getStringLenthOfBytes] > kMaxNumber)
        {
            textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
            [SVProgressHUD showInfoWithStatus:@"姓名长度10字以内"];

        }
    }

}


-(AddNewAddressView*)addNewAddressView{
    if (!_addNewAddressView) {
        _addNewAddressView = [[AddNewAddressView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, 245*kScale)];
        _addNewAddressView.backgroundColor = [UIColor whiteColor];
    }
    [_addNewAddressView.textFieldPhoneNumer addTarget:self action:@selector(phoneNumTextFieldTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_addNewAddressView.textFieldName addTarget:self action:@selector(textFieldNameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];


    return _addNewAddressView;
}




-(UIButton*)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(30*kScale, MaxY(self.addNewAddressView)+30*kScale, 145*kScale, 40*kScale);
        _saveBtn.backgroundColor = RGB(231, 35, 36, 1);
        [_saveBtn setTitle:@"保存" forState:0];
        _saveBtn.layer.cornerRadius = 5;
        _saveBtn.layer.masksToBounds = YES;
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    }
    return _saveBtn;
}


-(UIButton*)removeBtn{
    if (!_removeBtn) {
        _removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       // _removeBtn.frame = CGRectMake(kWidth-175, MaxY(self.addNewAddressView)+30, 145, 40);
        _removeBtn.layer.cornerRadius = 5;
        _removeBtn.layer.masksToBounds = YES;
        _removeBtn.backgroundColor = RGB(231, 35, 36, 1);
        [_removeBtn setTitle:@"删除" forState:0];
        _removeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_removeBtn setTitleColor:[UIColor whiteColor] forState:0];
        _removeBtn.layer.borderColor = RGB(231, 35, 36, 1).CGColor;
        _removeBtn.layer.borderWidth = 1;
        [_removeBtn addTarget:self action:@selector(removeBtnAction) forControlEvents:1];
    }
    return _removeBtn;
}

-(void)setRemoveBtnFrame{
    [self.removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(30*kScale);
        make.right.equalTo(self.view.mas_right).with.offset(-30*kScale); make.top.equalTo(self.addNewAddressView.mas_bottom).with.offset(30*kScale);
        make.height.equalTo(@(40*kScale));
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
