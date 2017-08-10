//
//  RCWebViewController.h


#import <UIKit/UIKit.h>


@interface RCWebViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backwardItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;

@property(nonatomic,strong)NSString* urlString;
@property(nonatomic,assign)BOOL hideToolbar;


- (id)init:(BOOL)hideToolbar;
- (void)updateContent:(NSString *)urlString title:(NSString*)title;
- (void)updateToolbarItem;
- (IBAction)clickBackwardItem:(id)sender;
- (IBAction)clickForwardItem:(id)sender;

@end
