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
    var itemArray = [[String : String]]()
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
            urlString = "http://www.18183.com/yxzjol/yx/cz/list_14112_1.html"
            token = ["type": "update"]
        } else {
            urlString = "http://www.18183.com/yxzjol/yx/cz/list_14112_" + "\(self.page+1).html"
            token = ["type": "more"]
        }
        
        let request = HttpRequest(delegate: self)
        let b = request.get(urlString, resultSelector: #selector(ThirdViewController.requestFinished(_:)), token: token)
        
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
        
        let htmlString = dict.object(forKey: "k_json") as! String
        if htmlString.characters.count != 0
        {
            if let array = HttpParser.sharedInstace().parse(forChuZhuang: htmlString) as? [[String : String]] {
                
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
        return 120.0
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
