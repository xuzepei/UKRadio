//
//  ChuZhuangWebViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/7/11.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class ChuZhuangWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var urlString: String = ""
    var titleString: String? = nil
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateContent(self.urlString, title: self.title)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(ChuZhuangWebViewController.refresh))
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ChuZhuangWebViewController.showAdTimer), userInfo: nil, repeats: false)
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
            
            bannerView.translatesAutoresizingMaskIntoConstraints = true
            var rect = bannerView.frame
            rect.origin.x = (UIScreen.main.bounds.size.width - rect.size.width)/2.0
            rect.origin.y = UIScreen.main.bounds.size.height - rect.size.height
            bannerView.frame = rect
            self.view .addSubview(bannerView)
        }
        
        
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
        
        updateContent(self.urlString, title: self.title)
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
        
        let request = HttpRequest(delegate: self)
        let b = request.get(urlString, resultSelector: #selector(ChuZhuangWebViewController.requestFinished(_:)), token: nil)
        if b == true {
            
            if self.indicator != nil {
                self.indicator.startAnimating();
            }
        }
    }
    
    
    func requestFinished(_ dict: NSDictionary) {
        
        if self.indicator != nil {
            self.indicator.stopAnimating();
        }
        
        let htmlString = dict.object(forKey: "k_json") as! String
        if htmlString.characters.count != 0
        {
            if let temp = HttpParser.sharedInstace().parse(forChuZhuangDetail: htmlString) as? String {
                
                if self.webView != nil {
                    
                    let bundleURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                    self.webView.loadHTMLString(temp, baseURL: bundleURL)
                }
            }
        }
    }
    
    
}

extension ChuZhuangWebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.indicator?.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.indicator?.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.indicator?.stopAnimating()
    }
    
}
