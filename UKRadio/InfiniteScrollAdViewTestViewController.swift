//
//  InfiniteScrollAdViewTestViewController.swift
//  UKRadio
//
//  Created by xuzepei on 17/5/25.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class InfiniteScrollAdViewTestViewController: UIViewController {
    
    var adScrollView: InfiniteAdScrollView?
    var indicator: MBProgressHUD? = nil
    var adItems = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initViewSize()
        
        self.initAdScrollView()
        
        self.updateContent()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewSize () {
    
        var rect = self.view.frame
        rect.size.width = UIScreen.mainScreen().bounds.width
        rect.size.height = UIScreen.mainScreen().bounds.height - self.navigationController!.navigationBar.frame.size.height
        self.view.frame = rect;
        
    }
    
    func updateContent() {
        
        let urlString = "http://182.140.235.65:8081/index.php?m=api&c=index&a=getbanner&t=1495764769.642994"
        let request = HttpRequest()
        request.delegate = self
        let b = request.get(urlString, resultSelector: #selector(ContentsViewController.requestFinished(_:)), token: nil)
        if b == true {
            self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.indicator!.labelText = "Loading..."
        }
        
    }
    
    func requestFinished(dict: NSDictionary) {
        
        if let indicator = self.indicator {
            indicator.hide(false)
        }
        
        //let jsonString = Tool.decrypt(dict.objectForKey("json") as! String)
        let jsonString = dict.objectForKey("json") as! String
        let result = Tool.parseToDictionary(jsonString)
        
        if result != nil {
        
            if let code = result!["code"] where code.isKindOfClass(NSNumber) && code.intValue == 200 {
                
                self.adItems.removeAll()
                
                if let data = result!["data"] as? [AnyObject] {
                
                    self.adItems.appendContentsOf(data)
                }
                
                if self.adItems.count > 0 && self.adScrollView != nil {
                
                    self.adScrollView!.updateContent(self.adItems)
                }
                
            }
            

        
        }
        
        print("Fuction:\(#function), result:\(result)")
    }
    
    
    func initAdScrollView() {
    
        if self.adScrollView == nil {
            
            self.adScrollView = InfiniteAdScrollView(frame: CGRectMake(0, 0, self.view.bounds.width, 260))
            self.view.addSubview(self.adScrollView!)
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
