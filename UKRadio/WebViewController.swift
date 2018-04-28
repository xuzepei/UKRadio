//
//  WebViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/6/27.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var urlString: String = ""
    var titleString: String? = nil
    var timer: Timer? = nil
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(adLoaded), name: .BannerLoaded, object: nil)

        self.updateContent(self.urlString, title: self.title)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(VideoWebViewController.refresh))
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(WebViewController.showAdTimer), userInfo: nil, repeats: false)
    }
    
    func adLoaded() {
        if let bannerView = Tool.getBannerAd() {
            
            if bannerView.superview == nil {
                
                UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(bannerView)
                arrangeBanner();
            }
        }
    }
    
    func arrangeBanner () {
        
        if let bannerView = Tool.getBannerAd() {
            
            bannerView.translatesAutoresizingMaskIntoConstraints = true
            var rect = bannerView.frame
            rect.origin.x = (self.view.bounds.size.width - rect.size.width)/2.0
            
            if Tool.isIphoneX() == true {
                rect.origin.y = UIScreen.main.bounds.size.height - rect.size.height - GlobalDefinitions.OFFSET_BOTTOM_IPHONX
            } else {
                rect.origin.y = UIScreen.main.bounds.size.height - rect.size.height
            }
            
            bannerView.frame = rect
        }
    }
    
    func showAdTimer() {
        
        if Tool.getInterstitial()?.isReady == true {
            
            Tool.getInterstitial()?.present(fromRootViewController: self)
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.titleString
        
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
        
        if let temp = self.webView {
            temp.loadRequest(URLRequest(url: URL(string: self.urlString)!))
        }
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

}

extension WebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if let url = request.url?.absoluteString {
            if url.lowercased().range(of: "doubleclick") != nil {
                
                print("@@@@@@@@@@:",url)
                return false
            }
        }
        
        return true
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        self.indicator?.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.indicator?.stopAnimating()
        
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('fixed-btn')[0].outerHTML = ''")
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('mar-t50')[0].outerHTML = ''")
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('container logo-search')[0].outerHTML = ''")
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByClassName('container navigation')[0].outerHTML = ''")
//        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('ins')[0].outerHTML = ''")
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    
        self.indicator?.stopAnimating()
    }
}
