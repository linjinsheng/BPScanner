
//
//  BPPDFHelper.m
//  FSIPM
//
//  Created by eddy_Mac on 16/7/30.
//  ___Address: https://github.com/eddyMake
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import "BPPDFPreviewHelper.h"
#import "CustomPDFPreviewController.h"
#import "QLPreviewItem.h"

@interface BPPDFPreviewHelper ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    NSInteger writeCount;
}

@property (nonatomic, copy) NSString *pdfPath;
@property (nonatomic, copy) NSString *pdfTitle;

@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation BPPDFPreviewHelper

+ (instancetype)shareInstance
{
    static BPPDFPreviewHelper *instance = nil;
    
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [[BPPDFPreviewHelper alloc] init];

    });
    
    return instance;
}


- (void)showPDFInViewController:(UIViewController *)viewController PDFPath:(NSString *)PDFPath PDFTitle:(NSString *)title
                   openComplete:(OpenPDFSuccessBlock)openComplete
{
    _pdfTitle = title;
    _currentViewController = viewController;
    
    writeCount = 1;
    
    NSURL *url = [NSURL URLWithString:PDFPath];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
 
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *fullPath = [[PDFPath componentsSeparatedByString:@"/"] lastObject];
            
            fullPath = [documentDirectory stringByAppendingPathComponent:fullPath];
            
            _pdfPath = fullPath;
            
            [self writePDFWithData:data pdfFullPath:fullPath openComplete:(OpenPDFSuccessBlock)openComplete];
            
            NSLog(@"%@===",fullPath);
            
        });
    });
}

- (void)writePDFWithData:(NSData *)pdfData pdfFullPath:(NSString *)pdfFullPath openComplete:(OpenPDFSuccessBlock)openComplete
{
    BOOL writeSuccess = [pdfData writeToFile:pdfFullPath atomically:NO];
    
    if (writeSuccess)
    {
        if (openComplete)
        {
            openComplete(YES);
        }
        
        CustomPDFPreviewController *qlPreview = [[CustomPDFPreviewController alloc]init];
        qlPreview.dataSource= self; //需要打开的文件的信息要实现dataSource中的方法
        qlPreview.delegate= self;  //视图显示的控制
        [qlPreview setCurrentPreviewItemIndex:0];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setBackgroundColor:[UIColor redColor]];
        [but setFrame:CGRectMake(0, 0, 50, 30)];
        
        [qlPreview.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:but]];
        
        [_currentViewController.navigationController pushViewController:qlPreview animated:NO];
    }
    else
    {
        if (writeCount == 3)
        {
            if (openComplete)
            {
                openComplete(NO);
            }
            
            return;
        }
        
        writeCount++;
        
        [self writePDFWithData:pdfData pdfFullPath:pdfFullPath openComplete:(OpenPDFSuccessBlock)openComplete];
    }
}

#pragma mark - previewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController*)controller
{
    return 1; //需要显示的文件的个数
}

- (id<QLPreviewItem>)previewController:(QLPreviewController*)controller previewItemAtIndex:(NSInteger)index
{
    NSURL * url =[NSURL fileURLWithPath:_pdfPath];
    QLPreviewItem *previewItemCopy = [QLPreviewItem previewItemWithURL:url
                                                                   title:_pdfTitle];
    
    return previewItemCopy;
}

#pragma mark - previewControllerDelegate

- (CGRect)previewController:(QLPreviewController*)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing *)view
{
    //提供变焦的开始rect，扩展到全屏
    return  CGRectMake(110, 190, 100, 100);
}

- (UIImage *)previewController:(QLPreviewController*)controller transitionImageForPreviewItem:(id<QLPreviewItem>)item contentRect:(CGRect *)contentRect
{
    //返回控制器在出现和消失时显示的图像
    return [UIImage imageNamed:@"gerenziliao_morentouxiang.png"];
}

- (void)previewControllerDidDismiss:(QLPreviewController*)controller
{
    //控制器消失后调用
}

- (void)previewControllerWillDismiss:(QLPreviewController*)controller
{
    [_currentViewController.navigationController setNavigationBarHidden:NO];
    
    //控制器在即将消失后调用
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:_pdfPath error:nil];
}


@end
