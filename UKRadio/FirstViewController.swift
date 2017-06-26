//
//  FirstViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/6/21.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var indicator: MBProgressHUD? = nil
    var itemArray = [[String : String]]()
    var page = 0;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()

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
    
    func initTableView() {
        
        //self.tableView.estimatedRowHeight = 89
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.register(UINib(nibName: "ZiXunTableViewCell", bundle: nil), forCellReuseIdentifier: "zixun_cell")
        
        self.tableView.addHeader(withTarget: self, action: #selector(FirstViewController.headerRefresh))
        self.tableView.addFooter(withTarget: self, action: #selector(FirstViewController.footerRefresh))
        
        self.tableView.headerBeginRefreshing();
    }
    
    func headerRefresh() {
        print("\(#function)")
        
        updateContent()
    }
    
    func footerRefresh() {
        print("\(#function)")
        
        updateContent()
    }
    
    func updateContent() {
        
        var urlString = "";
        var token:[String: Any]! = nil;
        if self.page < 1 {
            urlString = "http://news.4399.com/gonglue/wzlm/zixun/"
            token = ["type": "update"]
        } else {
            urlString = "http://news.4399.com/gonglue/wzlm/zixun/" + "44038-\(self.page+1).html"
            token = ["type": "more"]
        }
        
        let request = HttpRequest(delegate: self)
        let b = request.get(urlString, resultSelector: #selector(FirstViewController.requestFinished(_:)), token: token)
        
        if b == true {
            self.indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.indicator!.labelText = "Loading..."
        }
    
    }
    
    func requestFinished(_ dict: NSDictionary) {
        
        self.tableView.headerEndRefreshing()
        self.tableView.footerEndRefreshing()
        
        if let indicator = self.indicator {
            indicator.hide(false)
        }
        
        let json = dict.object(forKey: "json") as! String
        
        if json.characters.count == 0
        {
            let data: Data? = dict.object(forKey: "data") as? Data
            
            if data != nil {
            
                let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
                let htmlString = String(data: data!, encoding: String.Encoding(rawValue: gbkEncoding)) ?? ""
                
                if let array = HttpParser.sharedInstace().parse(htmlString) as? [[String : String]] {
                
                    if let type = dict.object(forKey: "type") as? String {
                        if type == "update" {
                            self.itemArray.removeAll()
                            self.itemArray = array
                            self.page = 1;
                        }
                        else
                        {
                            self.itemArray += array
                            self.page += 1;
                        }
                    }
                }
                
                self.tableView.reloadData()

            }
        }
    }
    
    func getItemByIndex(_ index: Int) -> AnyObject? {
        
        if index >= 0  && index < self.itemArray.count {
            
            return self.itemArray[index] as AnyObject
        }
        
        return nil
    }
    


}

extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "zixun_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        let item = itemArray[indexPath.row]
        
        if let temp =  cell as? ZiXunTableViewCell {
            temp.updateContent(item: item)
        }
        
        //cell.selectionStyle = UITableViewCellSelectionStyle.gray
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        if indexPath.row & 1 == 0 {
            cell.backgroundColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 227/255.0)
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = self.getItemByIndex(indexPath.row) {
            
            if let url = item["url"] as? String {
            
                if let temp = RCWebViewController(true) {
                    temp.hidesBottomBarWhenPushed = true
                    temp.updateContent(url, title: "游戏资讯")
                    self.navigationController!.pushViewController(temp, animated: true)
                }
            }
//            RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
//            temp.hidesBottomBarWhenPushed = YES;
//            [temp updateContent:urlString title:self.titleLabel.text];
//            
//            UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//            [naviController pushViewController:temp animated:YES];
            
        }
        
        //self .performSegueWithIdentifier("go_to_second", sender: nil)
        
    }
}

