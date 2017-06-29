//
//  VideoUrlViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/6/28.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class VideoUrlViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    var urlString: String = ""
    var titleString: String? = nil;
    var itemArray = [[String: String]]()
    var indicator2: MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(VideoUrlViewController.refresh))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.titleString
        
        if let bannerView = Tool.getBannerAd() {
            
            bannerView.translatesAutoresizingMaskIntoConstraints = true
            var rect = bannerView.frame
            rect.origin.x = (self.view.bounds.size.width - rect.size.width)/2.0
            rect.origin.y = UIScreen.main.bounds.size.height - rect.size.height
            bannerView.frame = rect
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.title = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is VideoWebViewController {
            
            if let button = sender as? UIButton {
                
                let tag = button.tag - 110
                if tag < self.itemArray.count {
                    
                    if let url = self.itemArray[tag]["url"] {
                        
                        let temp = segue.destination as! VideoWebViewController
                        temp.updateContent(url, title: self.title)
                    }
                }
            }
        }
        
    }
    
    func refresh () {
        
        self.updateContent(self.urlString, title: self.title)
    }
    
    func updateContent(_ url: String, title: String?) {
        
        self.urlString = url
        self.titleString = title
        if self.urlString.characters.count == 0 {
            return
        }
        
        if title == nil {
            self.title = self.urlString
        } else {
            self.title = title
        }
        
        let request = HttpRequest(delegate: self)
        let b = request.get(url, resultSelector: #selector(VideoUrlViewController.requestFinished(_:)), token: nil)
        if b == true {
            self.indicator?.startAnimating()
            self.indicator2 = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.indicator2!.labelText = "Loading..."
        }
    }
    
    func requestFinished(_ dict: NSDictionary)
    {
        if let indicator = self.indicator {
            indicator.stopAnimating()
        }
        
        if let indicator2 = self.indicator2 {
            indicator2.hide(false)
        }
        
        if let data = dict.object(forKey: "k_data") as? Data {
            
            let htmlString = String(data: data, encoding: String.Encoding.utf8) ?? ""
            
            //print("htmlString:",  (htmlString))
            
            let buttonArray: [UIButton] = [button0, button1, button2, button3, button4, button5]
            
            if let array = HttpParser.sharedInstace().parse(forVideo: htmlString) as? [[String : String]] {
                
                self.itemArray.removeAll()
                self.itemArray += array
                
                for (index, button) in buttonArray.enumerated() {
                    
                    if index < array.count {
                        
                        if let text = array[index]["text"] {
                            
                            //let temp = "视频地址\(index+1): " + text
                            button.setTitle(text, for: UIControlState.normal)
                            button.isHidden = false
                            //button.titleLabel?.textAlignment = NSTextAlignment.left
                            //button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
                            continue
                        }
                    }
                    
                    button.isHidden = true
                }
                
            }
            
            return;
        }
    }
    
    @IBAction func clickedButton(_ sender: Any) {
        
        if Tool.getInterstitial()?.isReady == true {
        
            Tool.getInterstitial()?.present(fromRootViewController: self)
        }
    }
    
}
