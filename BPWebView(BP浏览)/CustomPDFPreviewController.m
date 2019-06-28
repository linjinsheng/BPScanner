//
//  CustomPDFPreviewController.m
//  FSIPM
//
//  Created by eddy_Mac on 16/7/30.
//  ___Address: https://github.com/eddyMake
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import "CustomPDFPreviewController.h"

@interface CustomPDFPreviewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CustomPDFPreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(hideButton) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
}

- (void)hideButton
{
    self.navigationItem.rightBarButtonItems = nil;
}

@end
