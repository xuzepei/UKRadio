//
//  WebSiteTableViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/6/30.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class WebSiteTableViewController: UITableViewController {
    
    var itemArray = [[String : String]]()
    var timer: Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadContent()
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.timer?.invalidate()
        //self.timer = nil
        
        self.title = "学习资源"
        
        if let bannerView = Tool.getBannerAd() {
            
            bannerView.translatesAutoresizingMaskIntoConstraints = true
            var rect = bannerView.frame
            rect.origin.x = (UIScreen.main.bounds.size.width - rect.size.width)/2.0
            rect.origin.y = UIScreen.main.bounds.size.height - rect.size.height
            bannerView.frame = rect
            self.view .addSubview(bannerView)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadContent() {
        
        self.itemArray.removeAll()
        self.itemArray.append(["name":"Python 2.7中文参考文档","url":"http://docs.pythontab.com/python/python2.7/"])
        self.itemArray.append(["name":"Python 3.5中文参考文档","url":"http://docs.pythontab.com/python/python3.5/"])
        self.itemArray.append(["name":"Python 菜鸟中文教程","url":"http://www.runoob.com/python/python-tutorial.html"])
        self.itemArray.append(["name":"Python 进阶学习","url":"http://docs.pythontab.com/interpy/"])
    
    }
    
    func getItemByIndex(_ index: Int) -> AnyObject? {
        
        if index >= 0  && index < self.itemArray.count {
            
            return self.itemArray[index] as AnyObject
        }
        
        return nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.itemArray.count
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website_cell", for: indexPath)

        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        if let item = getItemByIndex(indexPath.row) as? [String: String]  {
            cell.textLabel?.text = item["name"]
        }
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        if indexPath.row & 1 == 0 {
            cell.backgroundColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 227/255.0)
        }
        else{
            cell.backgroundColor = UIColor.white
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if let item = self.getItemByIndex(indexPath.row) as? [String: String] {
//            
//            if let temp = RCWebViewController.init(true) {
//                temp.updateContent(item["url"], title: item["name"])
//                temp.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(temp, animated: true)
//                
//                self.perform(#selector(WebSiteTableViewController.showInterstitial), with: nil, afterDelay: 10)
//                
//                //self.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(WebSiteTableViewController.showInterstitial), userInfo: nil, repeats: false)
//            }
//            
//            
//        }
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is WebSiteViewController {
            
            if let selectedCell = sender as? UITableViewCell {
                
                let indexPath = self.tableView.indexPath(for: selectedCell)!
                if let item = self.getItemByIndex(indexPath.row) as? [String: String] {
                    let temp = segue.destination as! WebSiteViewController
                    temp.hidesBottomBarWhenPushed = true
                    temp.updateContent(item["url"]!, title: item["name"])
                }
            }
        }
        
    }
 
    
    func showInterstitial() {
        
        Tool.showInterstitial(vc: self)
        
    }

}
