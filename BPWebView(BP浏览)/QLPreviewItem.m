//
//  QLPreviewItem.m
//  FSIPM
//
//  Created by eddy_Mac on 16/7/30.
//  ___Address: https://github.com/eddyMake
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import "QLPreviewItem.h"

@implementation QLPreviewItem

+ (QLPreviewItem *)previewItemWithURL:(NSURL *)URL title:(NSString *)title
{
    QLPreviewItem *instance = [[QLPreviewItem alloc] init];
    instance.previewItemURL = URL;
    instance.previewItemTitle = title;
    return instance;
}


@end
