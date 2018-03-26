//
//  GHWelcomeViewController.h
//  GH
//
//  Created by gonghoo on 16/4/5.
//  Copyright © 2016年 gonghoo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectedEnter)();
@interface GHWelcomeViewController : UIViewController
@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

@property (retain ,nonatomic) UIScrollView *scrollview;
@property (nonatomic, retain) UIImageView *imageview;
@property (retain, nonatomic) UIPageControl *page;


@end
