//
//  WebSiteViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/6/30.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class WebSiteViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarToBottom: NSLayoutConstraint!
    @IBOutlet weak var backwardButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    var urlString: String = ""
    var titleString: String? = nil
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateContent(self.urlString, title: self.title)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(WebSiteViewController.refresh))
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(WebSiteViewController.showAdTimer), userInfo: nil, repeats: false)
    }
    
    func showAdTimer() {
        
        if Tool.getInterstitial()?.isReady == true {
            
            Tool.getInterstitial()?.present(fromRootViewController: self)
        }
        
    }
    
    func arrangeBanner () {
        
        if let bannerView = Tool.getBannerAd() {
            
            bannerView.translatesAutoresizingMaskIntoConstraints = true
            var rect = bannerView.frame
            rect.origin.x = (self.view.bounds.size.width - rect.size.width)/2.0
            
            if Tool.isIphoneX() == true {
                rect.origin.y = UIScreen.main.bounds.size.height - rect.size.height - self.toolbar.bounds.size.height - GlobalDefinitions.OFFSET_BOTTOM_IPHONX
            } else {
                rect.origin.y = UIScreen.main.bounds.size.height - rect.size.height - self.toolbar.bounds.size.height
            }
            
            bannerView.frame = rect
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.titleString
        
        if Tool.isIphoneX() == true {
            
            self.toolbarToBottom.constant = GlobalDefinitions.OFFSET_BOTTOM_IPHONX
        } else {
            self.toolbarToBottom.constant = 0
        }
        
        if let bannerView = Tool.getBannerAd() {
            UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(bannerView)
        }
        
        arrangeBanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.title = nil
        self.timer?.invalidate()
        self.timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func refresh () {
        
        self.webView.reload()
    }
    
    func updateContent(_ url: String, title: String?) {
        
        self.urlString = url
        self.titleString = title;
        
        if self.urlString.characters.count == 0 {
            return
        }
        
        if title == nil {
            self.title = self.urlString
        } else {
            self.title = title
        }
        
        if let temp = self.webView {
            temp.loadRequest(URLRequest(url: URL(string: self.urlString)!))
        }
        
    }
    
    @IBAction func clickedBarButtonItem(_ sender: Any) {
        
        let item = sender as? UIBarButtonItem
        if item == backwardButton {
            
            self.webView.goBack()
        
        } else if item == forwardButton {
            
            self.webView.goForward()
        
        }
        
        self.backwardButton.isEnabled = webView.canGoBack
        self.forwardButton.isEnabled = webView.canGoForward
    }
}

extension WebSiteViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if navigationType == UIWebViewNavigationType.linkClicked {
            
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.indicator?.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.indicator?.stopAnimating()
        
        self.backwardButton.isEnabled = webView.canGoBack
        self.forwardButton.isEnabled = webView.canGoForward

     }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.indicator?.stopAnimating()
    }
}
