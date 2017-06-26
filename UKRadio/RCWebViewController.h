//
//  RCWebViewController.h
//  RCFang
//
//  Created by xuzepei on 4/4/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCWebViewController : UIViewController<UIWebViewDelegate>


@property(nonatomic,strong)NSString* urlString;
@property(nonatomic,strong)UIWebView* webView;
@property(nonatomic,strong)UIActivityIndicatorView* indicator;
@property(nonatomic,strong)UIToolbar* toolbar;
@property(nonatomic,strong)UIBarButtonItem* backwardItem;
@property(nonatomic,strong)UIBarButtonItem* forwardItem;
@property(nonatomic,assign)BOOL hideToolbar;


- (id)init:(BOOL)hideToolbar;
- (void)initToolbar;
- (void)initWebView;
- (void)updateContent:(NSString *)urlString title:(NSString*)title;
- (void)updateToolbarItem;

@end
