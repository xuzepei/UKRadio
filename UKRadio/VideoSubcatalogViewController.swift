//
//  VideoSubcatalogViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/6/28.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class VideoSubcatalogViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var indicator: MBProgressHUD? = nil
    var itemArray = [[String : Any]]()
    var item: [String : Any]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let item = self.item {
            self.title = item["title"] as? String
        }
        
        if let bannerView = Tool.getBannerAd() {
            
            bannerView.translatesAutoresizingMaskIntoConstraints = true
            var rect = bannerView.frame
            rect.origin.x = (self.view.bounds.size.width - rect.size.width)/2.0
            rect.origin.y = (self.tabBarController?.tabBar.frame.origin.y)! - rect.size.height
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
    
    func initTableView() {
        
        self.tableView.addHeader(withTarget: self, action: #selector(VideoSubcatalogViewController.headerRefresh))
    }
    
    func headerRefresh() {
        loadContents(item: self.item)
    }
    
    func loadContents(item: [String: Any]?) {
        
        self.item = item
        self.title = self.item?["title"] as? String
        let urlString = "http://www.gembo.cn/app/3d/edu_controller.php?action=getVideoList&BigID=21"
        
        let gid = self.item?["id"] ?? ""
        let bodyString = "gid=\(gid)"
        let token = ["k_body": bodyString.data(using: String.Encoding.utf8)]
        
        let request = HttpRequest(delegate: self)
        let b = request.post(urlString, resultSelector: #selector(VideoSubcatalogViewController.requestFinished(_:)), token: token)
        
        if b == true {
            self.indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.indicator!.labelText = "Loading..."
        }
    }
    
    func requestFinished(_ dict: NSDictionary) {
        
        self.tableView.headerEndRefreshing()
        
        if let indicator = self.indicator {
            indicator.hide(false)
        }
        
        if let data = dict.object(forKey: "k_data") as? Data {
            
            let htmlString = String(data: data, encoding: String.Encoding.utf8) ?? ""
            
            if let array = Tool.parseToArray(htmlString) as? [[String: Any]]{
                
                
                self.itemArray.removeAll()
                self.itemArray = array
            }
            
            self.tableView.reloadData()
            return;
        }
        
        Tool.toast(message: "列表加载失败，请下拉刷新！")
    }
    
    func getItemByIndex(_ index: Int) -> AnyObject? {
        
        if index >= 0  && index < self.itemArray.count {
            
            return self.itemArray[index] as AnyObject
        }
        
        return nil
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is VideoUrlViewController {
            
            if let selectedCell = sender as? UITableViewCell {
                
                let indexPath = self.tableView.indexPath(for: selectedCell)!
                if let item = self.getItemByIndex(indexPath.row) as? [String: Any] {
                    let temp = segue.destination as! VideoUrlViewController
                    
                    if let url = item["url"] as? String {

                        let title = item["title"] as? String ?? "Python"
                        
                        temp.hidesBottomBarWhenPushed = true
                        temp.updateContent(url, title: title)
                    }
                    
                }
            }
        }
        
    }
    
    
}

extension VideoSubcatalogViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "video_subcatalog_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        let item = itemArray[indexPath.row]
        
        if let temp =  cell as? UITableViewCell {
            
            var text = item["title"] as? String
            text = text?.replacingOccurrences(of: " ", with: "")
            temp.textLabel?.text = text
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        if let item = self.getItemByIndex(indexPath.row) {
        //
        //            if let gid = item["id"] as? String {
        //                let url = "http://www.gembo.cn/app/3d/show_edu_content.php?id=\(gid)"
        //                let title = item["title"] as? String ?? "Python"
        //                if let temp = RCWebViewController(true) {
        //                    temp.hidesBottomBarWhenPushed = true
        //                    temp.updateContent(url, title: title, fromLocal: true)
        //                    self.navigationController!.pushViewController(temp, animated: true)
        //                }
        //            }
        //        }
    }
    
}
