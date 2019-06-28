//
//  QLPreviewItem.h
//  FSIPM
//
//  Created by eddy_Mac on 16/7/30.
//  ___Address: https://github.com/eddyMake
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface QLPreviewItem : NSObject <QLPreviewItem>

+ (QLPreviewItem *)previewItemWithURL:(NSURL *)URL title:(NSString *)title;

@property (readwrite) NSURL *previewItemURL;
@property (readwrite) NSString *previewItemTitle;

@end
