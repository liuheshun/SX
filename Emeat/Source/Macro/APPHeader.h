//
//  APPHeader.h
//  LessonProject
//
//  Created by young on 15/10/4.
//  Copyright © 2015年 LO.Young. All rights reserved.
//

#ifndef APPHeader_h
#define APPHeader_h

#define kHeight      [[UIScreen mainScreen] bounds].size.height
#define kWidth       [[UIScreen mainScreen] bounds].size.width

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height


// iPhone X
#define  LL_iPhoneX (kWidth == 375.f && kHeight == 812.f ? YES : NO)




// 系统控件默认高度
#define kStatusBarHeight        (LL_iPhoneX ? 44.f : 20.f)

#define kTopBarHeight           (44.f)
#define kBarHeight              (LL_iPhoneX ? 88.f : 64.f)
#define kBottomBarHeight        (LL_iPhoneX ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define  LL_TabbarSafeBottomMargin         (LL_iPhoneX ? 34.f : 0.f)





#define LL_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})


#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)
#define KFaceViewHeight         (216.f) //表情键盘高度








// 颜色(RGB)
#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//屏幕适配等比例缩放
//#define kScale          (kHeight/667.f)
#define kScale (kHeight == 812.f ? 667.f/667.f : kHeight/667.f)
    //导航栏背景白色
#define StateBarBackgroundColor  [UIColor whiteColor]

//导航栏背景黑色
#define StateBarBackgroundBlackColor  [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:30.0/255.0 alpha:1] //导航栏 黑色

//导航栏标题字体黑色
#define StateBarTitleBlackColor  [UIColor blackColor]

//导航栏标题字体白色
#define StateBarTitlewhiteColor  [UIColor whiteColor]




#endif /* APPHeader_h */
