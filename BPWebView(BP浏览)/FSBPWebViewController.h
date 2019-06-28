//
//  FSBPWebViewController.h
//  FSIPM
//
//  Created by nickwong on 16/6/25.
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSBPWebViewController : UIViewController

/** 创互推荐报告BPurl */
@property (nonatomic, strong) NSURLRequest *cyhzReportUrl;

@property (nonatomic, copy) NSString *pdfurl;

@end
