//
//  SecondViewController.swift
//  UKRadio
//
//  Created by xuzepei on 16/9/23.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var indicator: MBProgressHUD? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateContent() {
        
        let urlString = "http://appdream.sinaapp.com/bbc/bbc_list.php?cate_id=6&page=1&isopenall=1"
        let request = HttpRequest()
        request.delegate = self
        let b = request.get(urlString, resultSelector: #selector(ContentsViewController.requestFinished(_:)), token: nil)
        if b == true {
            self.indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.indicator!.labelText = "Loading..."
        }
        
    }
    
    func requestFinished(_ dict: NSDictionary) {
        
        if let indicator = self.indicator {
            indicator.hide(false)
        }
        
        let jsonString = Tool.decrypt(dict.object(forKey: "json") as! String)
        let result = Tool.parseToDictionary(jsonString)
        
        print("Fuction:\(#function), result:\(result)")
    }


}

