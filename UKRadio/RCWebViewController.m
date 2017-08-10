//
//  RCWebViewController.m


#import "RCWebViewController.h"
#import "UKRadio-Swift.h"


@interface RCWebViewController ()

@end

@implementation RCWebViewController

- (id)init:(BOOL)hideToolbar
{
    self.hideToolbar = hideToolbar;
    
    return [self initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clickRightBarButtonItem:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
    }
    return self;
}

- (void)dealloc
{
    self.urlString = nil;
    
    if(self.webView)
        self.webView.delegate = nil;
    self.webView = nil;
    
    self.indicator = nil;
    self.toolbar = nil;
    self.backwardItem = nil;
    self.forwardItem = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if(self.hideToolbar)
        self.toolbar.hidden = YES;
    
    [self updateContent:self.urlString title:self.title];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView* bannerView = [Tool getBannerAd];
    if(bannerView)
    {
        bannerView.translatesAutoresizingMaskIntoConstraints = YES;
        CGRect rect = bannerView.frame;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        rect.origin.x = (screenSize.width - rect.size.width)/2.0;
        rect.origin.y = screenSize.height - rect.size.height - 44;
        bannerView.frame = rect;
        [self.view addSubview:bannerView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if(self.webView)
        self.webView.delegate = nil;
    self.webView = nil;
    
    self.indicator = nil;
    self.toolbar = nil;
    self.backwardItem = nil;
    self.forwardItem = nil;
}

- (void)clickRightBarButtonItem:(id)sender
{
    [self clickRefreshItem:nil];
}

- (void)updateContent:(NSString *)urlString title:(NSString*)title
{
    if(0 == [urlString length])
        return;
    
    self.urlString = urlString;
    
    if([title length])
        self.title = title;
    else
        self.title = _urlString;
    
    [self updateToolbarItem];
    
    if(_webView)
    {
        _webView.delegate = self;
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
        [_webView loadRequest:request];
    }
    
}

#pragma mark - Toolbar

- (void)updateToolbarItem
{
	_backwardItem.enabled = _webView.canGoBack? YES:NO;
	_forwardItem.enabled = _webView.canGoForward? YES:NO;
}

- (IBAction)clickRefreshItem:(id)sender
{
    if(_webView)
        [_webView reload];
}

- (IBAction)clickBackwardItem:(id)sender
{
    if(_webView)
        [_webView goBack];
	
}

- (IBAction)clickForwardItem:(id)sender
{
    if(_webView)
        [_webView goForward];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
	if(request)
	{
//        if(self.hideToolbar)
//            return YES;
//        
//		NSURL* url = [request URL];
//		NSString* urlString = [url absoluteString];
//        if(NO == [urlString isEqualToString:_urlString])
//            self.title = urlString;
        

        //self.title = title;
	}
    
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    webView.hidden = YES;
	[_indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[_indicator stopAnimating];
    
//    NSString *html = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
//    //Edit html here, by parsing or similar.
//    [webView loadHTMLString:html baseURL:[[NSBundle mainBundle] resourceURL]];
    
//    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('header')[0].style.display = 'none'"];
//    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('header')[0].style.display = 'inline'"];
    
//    NSArray* array = @[@"header",@"srcmenuwp",@"gamehbtn mt15 head-wp",@"area tit4",@"area tit6",@"banner",@"area tit7",@"area tit5",@"area tit8",@"area tit9",@"area tit12",@"footwp ftinner"];
    
    NSArray* array = @[@"srcmenuwp",@"gamehbtn mt15 head-wp",@"BAIDU_DUP_fp_wrapper",@"header",@"banner",@"top-gg",@"main-title",@"zhengwen-tit",@"adsbygoogle",@"xgwz",@"wz-gg2",@"game-zq",@"",@"",@"",@"",@"",@"",@"",@"wz-rt",@"footer",@"BAIDU_SSP__wrapper_939636_0",@"fx"];
    
    
    for(NSString* className in array)
    {
        NSString* script = [NSString stringWithFormat:@"document.getElementsByClassName('%@')[0].outerHTML = ''",className];
        [_webView stringByEvaluatingJavaScriptFromString:script];
    }
    
    //[_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('header')[0].outerHTML = ''"];

    
    webView.hidden = NO;
	[self updateToolbarItem];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[_indicator stopAnimating];
}


@end
