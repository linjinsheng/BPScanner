//
//  FSBPWebViewController.m
//  FSIPM
//
//  Created by nickwong on 16/6/25.
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import "FSBPWebViewController.h"
#import "QLPreviewItem.h"
#import "CustomPDFPreviewController.h"

@interface FSBPWebViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property (nonatomic, copy) NSString *pdfPath;
@end

@implementation FSBPWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [Tools getColor:@"F7F7F7" isSingleColor:YES];
    [ProgressHUD show:@"加载中..."];
    [self showPDF];
    
    NSLog(@"%@",self.navigationController.interactivePopGestureRecognizer);
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //删除文件
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:_pdfPath error:nil];
}

- (void)showPDF
{
    NSURL *url = [NSURL URLWithString:_pdfurl];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *fullPath = [[_pdfurl componentsSeparatedByString:@"/"] lastObject];
            
            fullPath = [documentDirectory stringByAppendingPathComponent:fullPath];
            
            _pdfPath = fullPath;
            
            BOOL writeSuccess = [data writeToFile:fullPath atomically:NO];
            
            if (writeSuccess)
            {
                [ProgressHUD showSuccess:@"加载成功"];
                
                CustomPDFPreviewController *qlPreview = [[CustomPDFPreviewController alloc]init];
                qlPreview.dataSource= self; //需要打开的文件的信息要实现dataSource中的方法
                qlPreview.delegate= self;  //视图显示的控制
                
                [qlPreview.view setFrame:CGRectMake(0, 44, FSScreenWidth, FSScreenHeight - 44)];
                [self.view addSubview:qlPreview.view];
            }
            else
            {
                [ProgressHUD showSuccess:@"加载失败"];
            }
            
        });
    });
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
                                                                 title:@"sb"];
    
    return previewItemCopy;
}

#pragma mark - previewControllerDelegate

- (CGRect)previewController:(QLPreviewController*)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing *)view
{
    //提供变焦的开始rect，扩展到全屏
    return  CGRectMake(110, 190, 100, 100);
}


@end










//@interface FSBPWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
//
//{
//    UIWebView *mywebView;
//    int _lastPosition;
//    CGFloat lastScale;
//}
//
//@end
//
//@implementation FSBPWebViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.view.backgroundColor = [Tools getColor:@"F7F7F7" isSingleColor:YES];
//
//    /**初始化界面 */
//    [self addSubViews];
//}
//
//- (void)addSubViews
//{
//    /** 添加BP文件 */
////    self.view = mywebView;
//    mywebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, FSScreenWidth, FSScreenHeight - NavHeight)];
//    mywebView.delegate = self;
//    mywebView.scrollView.delegate = self;
//    mywebView.scrollView.bounces = NO;
//    mywebView.scrollView.scrollEnabled = NO;
////    mywebView.scrollView.alwaysBounceHorizontal = YES;
//    mywebView.scrollView.showsHorizontalScrollIndicator = YES;
//    mywebView.scrollView.showsVerticalScrollIndicator = YES;
////    [mywebView.scrollView setContentInset:UIEdgeInsetsMake(NavHeight, 0, 0, 0)];
//
//    mywebView.scrollView.maximumZoomScale = 3;
//    mywebView.scrollView.minimumZoomScale = 1;
//    [mywebView.scrollView setZoomScale:mywebView.scrollView.minimumZoomScale];
//    [self.view addSubview:mywebView];
//
//    // 加载PDF
//    if (_cyhzReportUrl) {
//    [mywebView loadRequest:_cyhzReportUrl];
//    }else
//    {
//        return;
//    }
//
//    [self pinchGesture];    // 缩放
//}
//
//
////开始加载时触发
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [ProgressHUD show:@"正在加载中..."];
//
//}
//
////加载完成触发
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [ProgressHUD showSuccess:@"加载完成"];
//}
//
////加载失败
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    NSLog(@"加载失败");
//}
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//
//{
//    NSLog(@"===%lf",scrollView.contentSize.height);
//
//    if (scrollView.contentSize.height <= FSScreenHeight)
//    {
//        return;
//    }
//
//    int currentPostion = scrollView.contentOffset.y;
//    if (currentPostion - _lastPosition > 20  && currentPostion >0) {
//        _lastPosition = currentPostion;
//        NSLog(@"ScrollUp now");
//        CGRect frame = mywebView.frame;
//        frame.origin.y = 0;
//        frame.size.height = FSScreenHeight;
//        mywebView.frame = frame;
//
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }
//
//    else if ((_lastPosition - currentPostion >20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20))
//    {
//        _lastPosition = currentPostion;
//        NSLog(@"ScrollDown now");
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//}
//
//#pragma mark - 缩放手势(捏合手势)
//- (void)pinchGesture
//{
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
//    pinch.delegate = self;
//    [mywebView addGestureRecognizer:pinch];
//}
//
//- (void)pinchView:(UIPinchGestureRecognizer *)pinch
//{
//    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
//    pinch.scale = 1; // 这个真的很重要!!!!!
//    FSLog(@"缩放比例pinch.scale为%f",pinch.scale);
//
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
//

