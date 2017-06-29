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
    var titleString: String? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateContent(self.urlString, title: self.title)
        indicator.tintColor = UIColor.green
        
        //indicator.color = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(VideoWebViewController.refresh))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.titleString
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.title = nil
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
        
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('ins')[0].outerHTML = ''")
//        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('ins')[1].outerHTML = ''")
//        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('ins')[2].outerHTML = ''")
//        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('ins')[3].outerHTML = ''")
//        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('ins')[0].outerHTML = ''")
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    
        self.indicator?.stopAnimating()
    }
}
