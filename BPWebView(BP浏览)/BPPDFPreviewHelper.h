//
//  BPPDFHelper.h
//  FSIPM
//
//  Created by eddy_Mac on 16/7/30.
//  ___Address: https://github.com/eddyMake
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OpenPDFSuccessBlock)(BOOL isSuccess);

@interface BPPDFPreviewHelper : NSObject

+ (instancetype)shareInstance;

/**
 *  展示PDF
 *
 *  @param viewController PDF试图的上一级控制器
 *  @param PDFPath        PDF路径
 *  @param title          控制器的title
 *  @param openComplete   打开成功与否
 */
- (void)showPDFInViewController:(UIViewController *)viewController
                        PDFPath:(NSString *)PDFPath
                       PDFTitle:(NSString *)title
                   openComplete:(OpenPDFSuccessBlock)openComplete;

@end
