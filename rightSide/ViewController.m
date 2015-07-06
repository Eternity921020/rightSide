//
//  ViewController.m
//  rightSide
//
//  Created by Eternity on 15/1/17.
//  Copyright (c) 2015年 Eternity. All rights reserved.
//

#import "ViewController.h"
#import "RightViewController.h"
#import "CenterViewController.h"
#import "UIView+MJ.h"

#define SideWidth 150

@interface ViewController ()<CenterViewControllerDelegate>
@property (nonatomic, strong) RightViewController *right;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //中间
    CenterViewController *center = [[CenterViewController alloc]init];
    center.delegate = self;
    center.view.frame = self.view.bounds;
    [self.view addSubview:center.view];
    [self addChildViewController:center];
    
    //右边
    RightViewController *right = [[RightViewController alloc]init];
    right.view.width = SideWidth;
    right.view.x = self.view.frame.size.width;
    right.view.y = 20;
    [self.view addSubview:right.view];
    [self addChildViewController:right];
    self.right = right;
    
    //手势 拖拽
    [center.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panChange:)]];
    //手势 点击
    [center.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChange:)]];
}

- (void)tapChange:(UITapGestureRecognizer *)tap
{
    if (self.right.view.origin.x == (self.view.frame.size.width-SideWidth)) {
        [UIView animateWithDuration:0.5 animations:^{
            self.right.view.transform = CGAffineTransformIdentity;
        }];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonNameChange" object:@"显示"];
    }
}
- (void)panChange:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:pan.view];

    if (pan.state == UIGestureRecognizerStateCancelled||pan.state == UIGestureRecognizerStateEnded) {
        if (self.right.view.x<=(self.view.frame.size.width- SideWidth*0.5)) {// 往左边至少走动了75
            [UIView animateWithDuration:0.5 animations:^{
                self.right.view.transform = CGAffineTransformMakeTranslation(- SideWidth, 0);
            }];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonNameChange" object:@"隐藏"];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.right.view.transform = CGAffineTransformIdentity;
            }];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonNameChange" object:@"显示"];
        }
    }else{//正在拖拽
        self.right.view.transform = CGAffineTransformTranslate(self.right.view.transform, point.x, 0);
        [pan setTranslation:CGPointZero inView:self.right.view];
        
        if (self.right.view.x<= (self.view.size.width- SideWidth)) {
            self.right.view.transform = CGAffineTransformMakeTranslation(- SideWidth, 0);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonNameChange" object:@"隐藏"];
        }else if (self.right.view.x>=self.view.frame.size.width){
            self.right.view.transform = CGAffineTransformIdentity;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonNameChange" object:@"显示"];
        }
        
    }
}
- (void)centerViewController:(CenterViewController *)centerViewController didButton:(UIButton *)btn
{

    if (self.right.view.origin.x == (self.view.frame.size.width-SideWidth)) {
        [UIView animateWithDuration:0.5 animations:^{
            self.right.view.transform = CGAffineTransformIdentity;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonNameChange" object:@"显示"];
        }];
    }else if(self.right.view.superview.origin.x == 0){
        [UIView animateWithDuration:0.5 animations:^{
            self.right.view.transform = CGAffineTransformMakeTranslation(- SideWidth, 0);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonNameChange" object:@"隐藏"];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
