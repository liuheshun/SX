//
//  SelectInvoiceTypesViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/6/22.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SelectInvoiceTypesViewController.h"
#import "SelectInvoiceTypesDetailsTableViewCell.h"
#import "SelectInvoiceTypesReceiveAddressTableViewCell.h"
#import "SpecialInvoiceTableViewCell.h"
#import "SelectInvoiceTypesHeadView.h"
#import "InvoicePreviewView.h"
#import "HWPopTool.h"
#import "InvoiceSubmitResultsViewController.h"

#import "MOFSPickerManager.h"


@interface SelectInvoiceTypesViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
///头部视图
@property (nonatomic,strong) SelectInvoiceTypesHeadView *selectInvoiceTypesHeadView;
///提交预览view
@property (nonatomic,strong) InvoicePreviewView *invoicePreviewView;

@property (nonatomic,strong) UIView *aView ;

@property (nonatomic,strong) SelectInvoiceTypesDetailsTableViewCell *invoiceTypesDetailsCell;

@property (nonatomic,strong) SelectInvoiceTypesReceiveAddressTableViewCell *receiveAddressCell;
@property (nonatomic,strong) SelectInvoiceTypesReceiveAddressTableViewCell *specialReceiveAddressCell;


@property (nonatomic,strong) SpecialInvoiceTableViewCell *specialInvoiceCell;


@end

@implementation SelectInvoiceTypesViewController
{
    ///普通发票1或者专票0
    NSInteger InvoiceKinds;
    ///是否展示更多信息
    NSInteger showMoreInfo;
    ///普通发票类型(企业或者个人)
    NSInteger switchOrdinaryInvoiceType;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navItem.title = @"开具发票";
    InvoiceKinds = 1;
    showMoreInfo = 0;
    switchOrdinaryInvoiceType = 20;
    [self.view addSubview:self.tableView];
    
}

#pragma mark ==提交预览

-(void)submitBtnAction{
    if (InvoiceKinds == 1) {///普票
        if (switchOrdinaryInvoiceType == 20) {///企业
            if (self.invoiceTypesDetailsCell.invoiceLookUpTextField.text.length == 0 || self.invoiceTypesDetailsCell.enioTextField.text.length == 0  || self.receiveAddressCell.receiverTextField.text.length == 0 || self.receiveAddressCell.receiverPhoneNumTextField.text.length == 0 || self.receiveAddressCell.receiverAddressTextField.text.length == 0 || self.receiveAddressCell.receiverDetailsAddressTextField.text.length == 0) {

                [self alertMessage:@"请填写发票必须信息或邮寄信息" willDo:nil];
            }else{
                
                [self addPreviewView];
                
                

            }
        }else if (switchOrdinaryInvoiceType == 21){///非企业/个人
            
            if (self.invoiceTypesDetailsCell.invoiceLookUpTextField.text.length == 0 || self.receiveAddressCell.receiverTextField.text.length == 0 || self.receiveAddressCell.receiverPhoneNumTextField.text.length == 0 || self.receiveAddressCell.receiverAddressTextField.text.length == 0 || self.receiveAddressCell.receiverDetailsAddressTextField.text.length == 0) {
                [self alertMessage:@"请填写发票必填信息或邮寄信息" willDo:nil];
            }else{
                
                [self addPreviewView];
                
                
                
            }
            
        }
        
        
        
    }else if (InvoiceKinds == 0){///专票
        
        if (self.specialInvoiceCell.invoiceLookUpTextField.text.length == 0 || self.specialInvoiceCell.enioTextField.text.length == 0  || self.specialInvoiceCell.companyPhoneNumTextField.text.length == 0  ||
            self.specialInvoiceCell.companyAddressTextField.text.length == 0  ||
            self.specialInvoiceCell.bankTextField.text.length == 0  ||
            self.specialInvoiceCell.bankAccountTextField.text.length == 0  ||self.specialReceiveAddressCell.receiverTextField.text.length == 0 || self.specialReceiveAddressCell.receiverPhoneNumTextField.text.length == 0 || self.specialReceiveAddressCell.receiverAddressTextField.text.length == 0 || self.specialReceiveAddressCell.receiverDetailsAddressTextField.text.length == 0) {
            [self alertMessage:@"请填写专用票必填信息或邮寄信息" willDo:nil];
        }else{
            
            [self addPreviewView];
            
            
        }
        
        
    }
    
   
}

#pragma mark = =保存发票信息
-(void)postInvoiceData{
    
    NSDictionary *dic = [self checkoutData];
    [dic setValue:@"10" forKey:@"invoiceMaterialInt"];//默认纸质发票
    [dic setValue:[NSString stringWithFormat:@"%ld" ,InvoiceKinds] forKey:@"invoiceTypeInt"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,switchOrdinaryInvoiceType] forKey:@"invoiceNatureInt"];
    
    [dic setValue:self.invoicePreviewView.invoiceLookUpLabel.text forKey:@"invoiceCompany"];
    [dic setValue:self.invoicePreviewView.enioLabel.text forKey:@"invoiceTaxNum"];
    
    
  NSInteger  invoiceAmount =  [self.invoicePreviewView.invoiceMoneyLabel.text doubleValue]*100;
    
    [dic setValue:[NSString stringWithFormat:@"%ld" ,invoiceAmount] forKey:@"invoiceAmount"];
    [dic setValue:self.invoicePreviewView.receiverLab.text forKey:@"invoiceReceiver"];
    [dic setValue:self.invoicePreviewView.receiverPhoneNumLabel.text forKey:@"invoiceReceiverPhone"];
    [dic setValue:[NSString stringWithFormat:@"%@,%@" ,self.invoicePreviewView.receiverAddressLabel.text ,self.invoicePreviewView.receiverDetailsAddressLab.text] forKey:@"invoiceReceiverAddress"];

    
    [dic setValue:self.invoiceIdString forKey:@"orderIdStr"];
    [dic setValue:self.invoicePreviewView.companyPhoneNumLabel.text forKey:@"invoiceCompanyPhone"];
    [dic setValue:self.invoicePreviewView.companyAddressLabel.text forKey:@"invoiceCompanyAddress"];

    
    [dic setValue:self.invoicePreviewView.bankLabel.text forKey:@"invoiceCompanyBank"];
    [dic setValue:self.invoicePreviewView.bankAccountLabel.text forKey:@"invoiceCompanyBankAccount"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    [MHAsiNetworkHandler startMonitoring];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/appInvoice/saveInvoice" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        if ([returnData[@"status"] integerValue] == 200 ) {
            [self closeBtnAction];
            
            InvoiceSubmitResultsViewController *VC = [InvoiceSubmitResultsViewController new];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
       
        
        
        
        
    } failureBlock:^(NSError *error) {
        

    } showHUD:NO];
    
}



-(void)addPreviewView{
    
    self.aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.aView.backgroundColor = RGB(0, 0, 0, 0.6);
    // 当前顶层窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel =UIWindowLevelNormal;
    [window addSubview:self.aView];
    [self.aView addSubview:self.invoicePreviewView];
    
   
    
    if (InvoiceKinds == 1) {///普票
        if (switchOrdinaryInvoiceType == 20) {///企业
            
             self.invoicePreviewView.lookUpType.text = @"企业普通发票";
        }else if (switchOrdinaryInvoiceType == 21){///非企业/个人
             self.invoicePreviewView.lookUpType.text = @"非企业/个人普通发票";
            
        }
        self.invoicePreviewView.lookUpType.text = @"增值税专用纸质发票";
        
        self.invoicePreviewView.invoiceLookUpLabel.text = [NSString stringWithFormat:@"%@" , self.invoiceTypesDetailsCell.invoiceLookUpTextField.text];
        
        self.invoicePreviewView.enioLabel.text = [NSString stringWithFormat:@"%@" , self.invoiceTypesDetailsCell.enioTextField.text];

        
        self.invoicePreviewView.companyPhoneNumLabel.text = [NSString stringWithFormat:@"%@" , self.invoiceTypesDetailsCell.self.companyPhoneNumTextField.text];

        self.invoicePreviewView.companyAddressLabel.text = [NSString stringWithFormat:@"%@" , self.invoiceTypesDetailsCell.self.companyAddressTextField.text];
        
        self.invoicePreviewView.bankLabel.text = [NSString stringWithFormat:@"%@" , self.invoiceTypesDetailsCell.self.bankTextField.text];

        self.invoicePreviewView.bankAccountLabel.text = [NSString stringWithFormat:@"%@" , self.invoiceTypesDetailsCell.self.bankAccountTextField.text];
        
        self.invoicePreviewView.invoiceContentLabel.text = [NSString stringWithFormat:@"%@" , @"*根据相应订单商品明细生成"];
        
        self.invoicePreviewView.invoiceMoneyLabel.text = [NSString stringWithFormat:@"%@" , self.invoiceTypesDetailsCell.self.invoiceMoneyTextField.text];
        
        ////
        
        self.invoicePreviewView.receiverLab.text = [NSString stringWithFormat:@"%@" , self.receiveAddressCell.self.receiverTextField.text];
        
        self.invoicePreviewView.receiverPhoneNumLabel.text = [NSString stringWithFormat:@"%@" , self.receiveAddressCell.self.receiverPhoneNumTextField.text];
        
        
        self.invoicePreviewView.receiverAddressLabel.text = [NSString stringWithFormat:@"%@" , self.receiveAddressCell.self.receiverAddressTextField.text];
        
        
        self.invoicePreviewView.receiverDetailsAddressLab.text = [NSString stringWithFormat:@"%@" , self.receiveAddressCell.self.receiverDetailsAddressTextField.text];
        
    }else if (InvoiceKinds == 0){///专票
        self.invoicePreviewView.lookUpType.text = @"专用发票";
        self.invoicePreviewView.invoiceLookUpLabel.text = [NSString stringWithFormat:@"%@" , self.specialInvoiceCell.invoiceLookUpTextField.text];
        
        self.invoicePreviewView.enioLabel.text = [NSString stringWithFormat:@"%@" , self.specialInvoiceCell.enioTextField.text];
        
        
        self.invoicePreviewView.companyPhoneNumLabel.text = [NSString stringWithFormat:@"%@" , self.specialInvoiceCell.self.companyPhoneNumTextField.text];
        
        self.invoicePreviewView.companyAddressLabel.text = [NSString stringWithFormat:@"%@" , self.specialInvoiceCell.self.companyAddressTextField.text];
        
        
        
        self.invoicePreviewView.bankLabel.text = [NSString stringWithFormat:@"%@" , self.specialInvoiceCell.self.bankTextField.text];
        
        self.invoicePreviewView.bankAccountLabel.text = [NSString stringWithFormat:@"%@" , self.specialInvoiceCell.self.bankAccountTextField.text];
        
        self.invoicePreviewView.invoiceContentLabel.text = [NSString stringWithFormat:@"%@" , @"*根据相应订单商品明细生成"];
        
        self.invoicePreviewView.invoiceMoneyLabel.text = [NSString stringWithFormat:@"%@" , self.specialInvoiceCell.self.invoiceMoneyTextField.text];
        
        /////
        
        
        self.invoicePreviewView.receiverLab.text = [NSString stringWithFormat:@"%@" , self.specialReceiveAddressCell.self.receiverTextField.text];
        
        self.invoicePreviewView.receiverPhoneNumLabel.text = [NSString stringWithFormat:@"%@" , self.specialReceiveAddressCell.self.receiverPhoneNumTextField.text];
        
        
        self.invoicePreviewView.receiverAddressLabel.text = [NSString stringWithFormat:@"%@" , self.specialReceiveAddressCell.self.receiverAddressTextField.text];
        
        
        self.invoicePreviewView.receiverDetailsAddressLab.text = [NSString stringWithFormat:@"%@" , self.specialReceiveAddressCell.self.receiverDetailsAddressTextField.text];
   

    }
    
    
    
    
}


#pragma mark == 关闭
-(void)closeBtnAction{
    [self.aView removeFromSuperview];
    [self.invoicePreviewView removeFromSuperview];
    
}

#pragma mark == 提交信息

-(void)subBtnAction{
    [self postInvoiceData];
}


-(InvoicePreviewView *)invoicePreviewView{
    if (!_invoicePreviewView) {
        _invoicePreviewView = [[InvoicePreviewView alloc] initWithFrame:CGRectMake(0, kHeight-610*kScale-LL_TabbarSafeBottomMargin, kWidth, 610*kScale)];
        _invoicePreviewView.backgroundColor = [UIColor whiteColor];
        [_invoicePreviewView.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:1];
        [_invoicePreviewView.submitBtn addTarget:self action:@selector(subBtnAction) forControlEvents:1];


    }
    return _invoicePreviewView;
}




-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (InvoiceKinds == 1) {///普票
            if (switchOrdinaryInvoiceType == 20) {///企业
                if (showMoreInfo == 1) {
                    
                    return 450*kScale;
                }
                return 245*kScale;
            }else{///个人
                if (showMoreInfo == 1) {
                    
                    return 450*kScale -40*kScale;
                }
                return 245*kScale - 40*kScale;
            }
            
        }else {///专票
            return 410*kScale;

        }
       
        
        
    }else{
        return 245*kScale;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 231*kScale;
    }
    return 30*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        self.selectInvoiceTypesHeadView = [[SelectInvoiceTypesHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 231*kScale)];
        self.selectInvoiceTypesHeadView.backgroundColor = RGB(238, 238, 238, 1);
        
        if (InvoiceKinds == 1) {
            self.selectInvoiceTypesHeadView.specialInvoiceKindBtn.layer.borderColor = RGB(136, 136, 136, 1).CGColor;
            self.selectInvoiceTypesHeadView.specialInvoiceKindBtn.layer.borderWidth = 1;
            self.selectInvoiceTypesHeadView.specialInvoiceKindBtn.layer.cornerRadius = 5;
            [self.selectInvoiceTypesHeadView.specialInvoiceKindBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
            self.selectInvoiceTypesHeadView.ordinaryInvoiceKindBtn.layer.borderColor = RGB(236, 31, 35, 1).CGColor;
            self.selectInvoiceTypesHeadView.ordinaryInvoiceKindBtn.layer.borderWidth = 1;
            self.selectInvoiceTypesHeadView.ordinaryInvoiceKindBtn.layer.cornerRadius = 5;
            [self.selectInvoiceTypesHeadView.ordinaryInvoiceKindBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
        }else if (InvoiceKinds == 0){
            self.selectInvoiceTypesHeadView.ordinaryInvoiceKindBtn.layer.borderColor = RGB(136, 136, 136, 1).CGColor;
            self.selectInvoiceTypesHeadView.ordinaryInvoiceKindBtn.layer.borderWidth = 1;
            self.selectInvoiceTypesHeadView.ordinaryInvoiceKindBtn.layer.cornerRadius = 5;
            [self.selectInvoiceTypesHeadView.ordinaryInvoiceKindBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
            
            self.selectInvoiceTypesHeadView.specialInvoiceKindBtn.layer.borderColor = RGB(236, 31, 35, 1).CGColor;
            self.selectInvoiceTypesHeadView.specialInvoiceKindBtn.layer.borderWidth = 1;
            self.selectInvoiceTypesHeadView.specialInvoiceKindBtn.layer.cornerRadius = 5;
            [self.selectInvoiceTypesHeadView.specialInvoiceKindBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
        }
#pragma mrk ===发票切换 (普票 专票)
 
        __weak __typeof(self) weakSelf = self;
        self.selectInvoiceTypesHeadView.selectInvoiceKindsBlock = ^(NSInteger kindStated) {
            InvoiceKinds = kindStated;
            
            [weakSelf.tableView reloadData];
           
        };

        return self.selectInvoiceTypesHeadView;
    }else{
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30*kScale)];
        label.text =  @"    接收方式";
        label.font = [UIFont systemFontOfSize:12.0f*kScale];
        label.textColor = RGB(136, 136, 136, 1);
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = RGB(231,231, 231, 1);
        return label;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 90*kScale;
    }
    return 0.1*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 90*kScale)];
        view.backgroundColor = RGB(238, 238, 238, 1);
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(15*kScale, 25*kScale, kWidth-30*kScale, 40*kScale);
        submitBtn.backgroundColor = RGB(236, 31, 35, 1);
        [submitBtn setTitle:@"提交" forState:0];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        submitBtn.layer.cornerRadius = 5;
        submitBtn.layer.masksToBounds = YES;
        [submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:1];
        [view addSubview:submitBtn];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.1*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (InvoiceKinds == 1) {//普票
        if (indexPath.section == 0) {
            self.invoiceTypesDetailsCell = [tableView dequeueReusableCellWithIdentifier:@"selectInvoice_cell"];
            if (self.invoiceTypesDetailsCell == nil) {
                self.invoiceTypesDetailsCell = [[SelectInvoiceTypesDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectInvoice_cell"];
                
                [self.invoiceTypesDetailsCell setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
                self.invoiceTypesDetailsCell.backgroundColor = [UIColor whiteColor];
                
            }
            __weak __typeof(self) weakSelf = self;

#pragma mark =====普票 选择企业或者个人
            self.invoiceTypesDetailsCell.isSwitchOrdinaryTypesBlock = ^(NSInteger types) {
                
                switchOrdinaryInvoiceType = types;
                [weakSelf.tableView reloadData];
                
            };
#pragma mark ==是否展示更多选填信息
            
            self.invoiceTypesDetailsCell.isShowMoreInfoBlock = ^(NSInteger isShow) {
                showMoreInfo = isShow;
                [weakSelf.tableView reloadData];
            };
            /// 回显赋值
            if (self.invoiceShowMarray.count!=0) {
                InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
                [self.invoiceTypesDetailsCell configWithModel:model];
                
            }
            self.invoiceTypesDetailsCell.invoiceMoneyTextField.text = self.invoiceTotalPrices;
            self.invoiceTypesDetailsCell.invoiceMoneyTextField.enabled = NO;
            
            //////
            [self.invoiceTypesDetailsCell.invoiceLookUpTextField addTarget:self action:@selector(invoiceLookUpTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [self.invoiceTypesDetailsCell.enioTextField addTarget:self action:@selector(enioTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

             [self.invoiceTypesDetailsCell.companyPhoneNumTextField addTarget:self action:@selector(companyPhoneNumTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.invoiceTypesDetailsCell.companyAddressTextField addTarget:self action:@selector(companyAddressTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

            [self.invoiceTypesDetailsCell.bankTextField addTarget:self action:@selector(bankTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.invoiceTypesDetailsCell.bankAccountTextField addTarget:self action:@selector(bankAccountTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

            return self.invoiceTypesDetailsCell;
            
        }else{///收件人信息
            
            self.receiveAddressCell = [tableView dequeueReusableCellWithIdentifier:@"Invoice_cell"];
            if (self.receiveAddressCell == nil) {
                self.receiveAddressCell = [[SelectInvoiceTypesReceiveAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"receiveInvoice_cell"];
                
                [self.receiveAddressCell setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
                self.receiveAddressCell.backgroundColor = [UIColor whiteColor];
                
            }
            
            
            
            /// 回显赋值
            
            if (self.invoiceShowMarray.count!=0) {
                InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
                [self.receiveAddressCell configAddressCellWithModel:model];
            }
            
            [self.receiveAddressCell.receiverAddressBtn addTarget:self action:@selector(OrdinaryReceiverAddressTextFieldAction) forControlEvents:1];
            
            [self.receiveAddressCell.receiverPhoneNumTextField addTarget:self action:@selector(phoneNumTextFieldTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.receiveAddressCell.receiverTextField addTarget:self action:@selector(receiverTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.receiveAddressCell.receiverDetailsAddressTextField addTarget:self action:@selector(receiverDetailsAddressTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.receiveAddressCell.receiverEmailTextField addTarget:self action:@selector(receiverEmailTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

            
            return self.receiveAddressCell;
            
            
        }
        
    }else{///专票cell
        
        if (indexPath.section == 0) {
           self.specialInvoiceCell = [tableView dequeueReusableCellWithIdentifier:@"SpecialInvoiceTableViewCell"];
            if (self.specialInvoiceCell == nil) {
                self.specialInvoiceCell = [[SpecialInvoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpecialInvoiceTableViewCell"];
                
                [self.specialInvoiceCell setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
                self.specialInvoiceCell.backgroundColor = [UIColor whiteColor];
                
            }
            
            /// 回显赋值
            if (self.invoiceShowMarray.count!=0) {
                InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
                [self.specialInvoiceCell configWithModel:model];
            }
            
            
            self.specialInvoiceCell.invoiceMoneyTextField.text = self.invoiceTotalPrices;

            
            [self.specialInvoiceCell.invoiceLookUpTextField addTarget:self action:@selector(invoiceLookUpTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [self.specialInvoiceCell.enioTextField addTarget:self action:@selector(enioTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [self.specialInvoiceCell.companyPhoneNumTextField addTarget:self action:@selector(companyPhoneNumTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.specialInvoiceCell.companyAddressTextField addTarget:self action:@selector(companyAddressTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [self.specialInvoiceCell.bankTextField addTarget:self action:@selector(bankTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.specialInvoiceCell.bankAccountTextField addTarget:self action:@selector(bankAccountTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
          
            return self.specialInvoiceCell;
        }else{
            
            self.specialReceiveAddressCell = [tableView dequeueReusableCellWithIdentifier:@"specialReceiveAddressCell"];
            if (self.specialReceiveAddressCell == nil) {
                self.specialReceiveAddressCell = [[SelectInvoiceTypesReceiveAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"specialReceiveAddressCell"];
                
                [self.specialReceiveAddressCell setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
                self.specialReceiveAddressCell.backgroundColor = [UIColor whiteColor];
                
            }
            
            /// 回显赋值
            if (self.invoiceShowMarray.count!=0) {
                InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
                [self.specialReceiveAddressCell configAddressCellWithModel:model];
                
            }
            [self.specialReceiveAddressCell.receiverAddressBtn addTarget:self action:@selector(specialReceiverAddressTextFieldAction) forControlEvents:1];
            
            [self.specialReceiveAddressCell.receiverPhoneNumTextField addTarget:self action:@selector(phoneNumTextFieldTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.specialReceiveAddressCell.receiverTextField addTarget:self action:@selector(receiverTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.specialReceiveAddressCell.receiverDetailsAddressTextField addTarget:self action:@selector(receiverDetailsAddressTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.specialReceiveAddressCell.receiverEmailTextField addTarget:self action:@selector(receiverEmailTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

            
            
            return self.specialReceiveAddressCell;
            
            
        }
        
        
        
    }
    
  
}

#pragma mark =====普通发票选择地址
-(void)OrdinaryReceiverAddressTextFieldAction{
    
    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
         address = [address stringByReplacingOccurrencesOfString:@"-" withString:@""];


        self.receiveAddressCell.receiverAddressTextField.text = address;
    } cancelBlock:^{
        
    }];
    
    
}



#pragma mark =====专用发票选择地址
-(void)specialReceiverAddressTextFieldAction{
    
    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
        address = [address stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        
        self.specialReceiveAddressCell.receiverAddressTextField.text = address;
    } cancelBlock:^{
        
    }];
    
    
}


//#pragma mark=====更多信息
//-(void)showMoreInfoBtnAction{
//    if (showMoreInfo == 0) {
//        showMoreInfo = 1;
//    }else if (showMoreInfo == 1){
//        showMoreInfo = 0;
//    }
//
//    [self.tableView reloadData];
//}



-(void)lookUpTypeBtn1Action{
    
    [self.tableView reloadData];
}

-(void)lookUpTypeBtn2Action{
    
    [self.tableView reloadData];
}

///发票信息



-(void)invoiceLookUpTextFieldDidChange:(UITextField*)textField{
    
    if (InvoiceKinds == 1) {//普票
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompany = self.invoiceTypesDetailsCell.invoiceLookUpTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompany = self.invoiceTypesDetailsCell.invoiceLookUpTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }else{
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompany = self.specialInvoiceCell.invoiceLookUpTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompany = self.specialInvoiceCell.invoiceLookUpTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }
}

-(void)enioTextFieldDidChange:(UITextField*)textField{
    if (InvoiceKinds == 1) {//普票
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceTaxNum = self.invoiceTypesDetailsCell.enioTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceTaxNum = self.invoiceTypesDetailsCell.enioTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }else{
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceTaxNum = self.specialInvoiceCell.enioTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceTaxNum = self.specialInvoiceCell.enioTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }
    
}

-(void)companyPhoneNumTextFieldDidChange:(UITextField*)textField{
    if (InvoiceKinds == 1) {//普票
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompanyPhone = self.invoiceTypesDetailsCell.companyPhoneNumTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompanyPhone = self.invoiceTypesDetailsCell.companyPhoneNumTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }else{
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompanyPhone = self.specialInvoiceCell.companyPhoneNumTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompanyPhone = self.specialInvoiceCell.companyPhoneNumTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }
    
}

-(void)companyAddressTextFieldDidChange:(UITextField*)textField{
    if (InvoiceKinds == 1) {//普票
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompanyAddress = self.invoiceTypesDetailsCell.companyAddressTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompanyAddress = self.invoiceTypesDetailsCell.companyAddressTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }else{
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompanyAddress = self.specialInvoiceCell.companyAddressTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompanyAddress = self.specialInvoiceCell.companyAddressTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }
    
}


-(void)bankTextFieldDidChange:(UITextField*)textField{
    if (InvoiceKinds == 1) {//普票
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompanyBank = self.invoiceTypesDetailsCell.bankTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompanyBank = self.invoiceTypesDetailsCell.bankTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }else{
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompanyBank = self.specialInvoiceCell.bankTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompanyBank = self.specialInvoiceCell.bankTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }
    
    
}


-(void)bankAccountTextFieldDidChange:(UITextField*)textField{
    if (InvoiceKinds == 1) {//普票
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompanyBankAccount = self.invoiceTypesDetailsCell.bankAccountTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompanyBankAccount = self.invoiceTypesDetailsCell.bankAccountTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }else{
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceCompanyBankAccount = self.specialInvoiceCell.bankAccountTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceCompanyBankAccount = self.specialInvoiceCell.bankAccountTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }
    
    
}


//////收件人信息
//姓名
-(void)receiverTextFieldDidChange:(UITextField*)textField{
    if (InvoiceKinds == 1) {//普票
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceReceiver = self.receiveAddressCell.receiverTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceReceiver = self.receiveAddressCell.receiverTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }else{
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceReceiver = self.specialReceiveAddressCell.receiverTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceReceiver = self.specialReceiveAddressCell.receiverTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }
    
}

///门牌号
-(void)receiverDetailsAddressTextFieldDidChange:(UITextField*)textField{
    if (InvoiceKinds == 1) {//普票
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceReceiverDetailsAddress = self.receiveAddressCell.receiverDetailsAddressTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceReceiverDetailsAddress = self.receiveAddressCell.receiverDetailsAddressTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }else{
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceReceiverDetailsAddress = self.specialReceiveAddressCell.receiverDetailsAddressTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceReceiverDetailsAddress = self.specialReceiveAddressCell.receiverDetailsAddressTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }
    
}

//email
-(void)receiverEmailTextFieldDidChange:(UITextField*)textField{
    if (InvoiceKinds == 1) {//普票
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceEmail = self.receiveAddressCell.receiverEmailTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceEmail = self.receiveAddressCell.receiverEmailTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }else{
        if (self.invoiceShowMarray.count !=0) {
            InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
            model.invoiceEmail = self.specialReceiveAddressCell.receiverEmailTextField.text;
            [self.invoiceShowMarray addObject:model];
        }else{
            InvoiceDetailsModel *model = [InvoiceDetailsModel new];
            model.invoiceEmail = self.specialReceiveAddressCell.receiverEmailTextField.text;
            [self.invoiceShowMarray addObject:model];
        }
        
    }
}



-(void)phoneNumTextFieldTextFieldDidChange:(UITextField*)textField{
    
    if (textField.text.length > 11)
    {
        textField.text = [textField.text substringToIndex:11];
    }
    
    
    if (textField.text.length == 11) {
        if (![self checkTel:textField.text] ) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确手机号码"];
        }else{
            if (InvoiceKinds == 1) {//普票
                if (self.invoiceShowMarray.count !=0) {
                    InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
                    model.invoiceReceiverPhone = self.receiveAddressCell.receiverPhoneNumTextField.text;
                    [self.invoiceShowMarray addObject:model];
                }else{
                    InvoiceDetailsModel *model = [InvoiceDetailsModel new];
                    model.invoiceReceiverPhone = self.receiveAddressCell.receiverPhoneNumTextField.text;
                    [self.invoiceShowMarray addObject:model];
                }
                
            }else{
                if (self.invoiceShowMarray.count !=0) {
                    InvoiceDetailsModel *model = [self.invoiceShowMarray firstObject];
                    model.invoiceReceiverPhone = self.specialReceiveAddressCell.receiverPhoneNumTextField.text;
                    [self.invoiceShowMarray addObject:model];
                }else{
                    InvoiceDetailsModel *model = [InvoiceDetailsModel new];
                    model.invoiceReceiverPhone = self.specialReceiveAddressCell.receiverPhoneNumTextField.text;
                    [self.invoiceShowMarray addObject:model];
                }
                
            }
           
            
        }
        
    }
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
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
