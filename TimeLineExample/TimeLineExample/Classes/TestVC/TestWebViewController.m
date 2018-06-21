//
//  TestWebViewController.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/6/4.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TestWebViewController.h"
#import <WebKit/WebKit.h>
#import "TimeLineCommonDefine.h"

@interface TestWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation TestWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navigationtitle;
    self.view.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - WKWebView代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        
        NSLog(@"%f",newprogress);
        if (newprogress == 1) {
            [self.progressView setProgress:2 animated:YES];
            self.progressView.hidden = YES;
        }else {
            [self.progressView setProgress:newprogress animated:YES];
            self.progressView.hidden = NO;
        }
    }
}

#pragma mark - getter
- (WKWebView *)webView{
    if(!_webView){
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64 ,kSCREENWIDTH , kSCREENHEIGHT -64)];
        _webView.navigationDelegate = self;
        _webView.multipleTouchEnabled=YES;
        _webView.userInteractionEnabled=YES;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.view insertSubview:_webView belowSubview:self.progressView];
    }
    return _webView;
}

- (UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, kSCREENWIDTH,0)];
        self.progressView.tintColor = [UIColor blackColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:self.progressView];
    }
    return _progressView;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
