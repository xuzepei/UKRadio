//
//  ThirdViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/7/11.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var indicator: MBProgressHUD? = nil
    var itemArray = [[String : Any]]()
    var page = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        updateContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initTableView() {
        
        //self.tableView.estimatedRowHeight = 89
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.register(UINib(nibName: "ChuZhuangTableViewCell", bundle: nil), forCellReuseIdentifier: "chuzhuang_cell")
        
        self.tableView.addHeader(withTarget: self, action: #selector(ThirdViewController.headerRefresh))
        self.tableView.addFooter(withTarget: self, action: #selector(ThirdViewController.footerRefresh))
        
        //self.tableView.headerBeginRefreshing();
    }
    
    func headerRefresh() {
        print("\(#function)")
        
        self.page = 0
        updateContent()
    }
    
    func footerRefresh() {
        print("\(#function)")
        
        updateContent()
    }
    
    func updateContent() {
        
//        var urlString = "";
//        var token:[String: Any]! = nil;
//        if self.page < 1 {
//            urlString = "http://www.18183.com/yxzjol/yx/cz/list_14112_1.html"
//            token = ["type": "update"]
//        } else {
//            urlString = "http://www.18183.com/yxzjol/yx/cz/list_14112_" + "\(self.page+1).html"
//            token = ["type": "more"]
//        }
//        
//        let request = HttpRequest(delegate: self)
//        let b = request.get(urlString, resultSelector: #selector(ThirdViewController.requestFinished(_:)), token: token)
//        
//        if b == true {
//            self.indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
//            self.indicator!.labelText = "Loading..."
//        }
        
        
        var token:[String: Any]! = nil;
        var body = ""
        if self.page < 1 {
            body = "appid=1158560788&appname=gok&cateid=3&client=iPhone&device=iPhone&jbk=0&market=AppStore&openudid=B17262BB-F8B4-4715-A037-E87D883195DC&sort=cTime&ver=2.0"
            token = ["k_type": "update"]
        } else {
            
            if self.itemArray.count > 0 {
                let lastItem = self.itemArray.last
                if let date = lastItem?["cTime"] as? String , date.characters.count > 0{
                    body = "appid=1158560788&appname=gok&cateid=3&client=iPhone&device=iPhone&jbk=0&market=AppStore&openudid=B17262BB-F8B4-4715-A037-E87D883195DC&pt=\(date)&sort=cTime&ver=2.0"
                }
            }
            token = ["k_type": "more"]
        }
        
        if body.characters.count == 0 {
            return
        }
        
        let urlString = "http://api.youlongtang.com/?c=info&a=list"
        
        let bodyData = body.data(using: String.Encoding.utf8)
        let request = HttpRequest(delegate: self)
        let b = request.post(urlString, body: bodyData!, resultSelector: #selector(ToolsViewController.requestFinished(_:)), token: token)
        
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
        
        let jsonString = dict.object(forKey: "k_json") as! String
        let type = dict.object(forKey: "k_type") as! String
        if jsonString.characters.count != 0 {
            
            if let dict = Tool.parseToDictionary(jsonString) {
                
                if type == "update" {
                    self.itemArray.removeAll()
                    if let tempArray = dict["data"] as? [[String : Any]] {
                        self.itemArray = tempArray
                        self.page = 1;
                    }
                }
                else
                {
                    if let tempArray = dict["data"] as? [[String : Any]] {
                        self.itemArray += tempArray
                        self.page += 1;
                    }
                }
            }
            
        }
        
        self.tableView.reloadData()
        
//        let htmlString = dict.object(forKey: "k_json") as! String
//        if htmlString.characters.count != 0
//        {
//            if let array = HttpParser.sharedInstace().parse(forChuZhuang: htmlString) as? [[String : String]] {
//                
//                if let type = dict.object(forKey: "type") as? String {
//                    if type == "update" {
//                        self.itemArray.removeAll()
//                        self.itemArray = array
//                        self.page = 1;
//                    }
//                    else
//                    {
//                        self.itemArray += array
//                        self.page += 1;
//                    }
//                }
//            }
//            
//            self.tableView.reloadData()
//        }
    
    }

    func getItemByIndex(_ index: Int) -> AnyObject? {
        
        if index >= 0  && index < self.itemArray.count {
            
            return self.itemArray[index] as AnyObject
        }
        
        return nil
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ThirdViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "chuzhuang_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        let item = itemArray[indexPath.row]
        
        if let temp =  cell as? ChuZhuangTableViewCell {
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
                
                let temp = ChuZhuangWebViewController()
                temp.hidesBottomBarWhenPushed = true
                temp.updateContent(url, title: "游戏资讯")
                self.navigationController!.pushViewController(temp, animated: true)
            }
            
        }
    }
}
