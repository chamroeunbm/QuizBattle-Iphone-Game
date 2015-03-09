//
//  CustomMenuViewController.h
//  MOVYT
//
//  Created by Sumit Ghosh on 27/05/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseView.h"

@interface CustomMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PurchaseViewPopupDelegate, UITabBarDelegate> {
    
    UIImageView *imageVUser;
    UILabel *lblUserName;
    
    UIView *viewBooster;
    NSUserDefaults *userDefault;
    int totalDiamond;
    UIButton *btnDiamond;
    UIButton *btnBooster;
    UIButton *btnLife;
    UILabel *lblLifeTime;
    NSTimer *timer;
    NSTimer *timerForBooster;
    int time,boosterTime;
    UILabel * lblUserRank;
    //----------
    CGRect screenSize;
    UIView * rejectView;
}



@property (nonatomic, assign) BOOL isSignIn;

@property (nonatomic, assign) CGFloat screen_height;

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *topicButton;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *boosterView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) UILabel *firstSectionHeader;
@property (nonatomic, strong) UILabel *secondHeaderLabel;



@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, copy) NSArray *tabViewControllersArray;
@property (nonatomic, strong) NSArray *secondSectionViewControllers;
@property (nonatomic, assign) NSInteger numberOfSections;

@property (nonatomic, copy) UIViewController *selectedViewController;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedSection;

@property (nonatomic, strong) UIView *mainsubView;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;


-(NSArray *) getAllViewControllers;
@end

@interface UIViewController (CustomMenuViewControllerItem)

@property (nonatomic, strong) CustomMenuViewController *customMenuViewController;
//-(CustomMenuViewController *)firstAvailableViewController;
@end
