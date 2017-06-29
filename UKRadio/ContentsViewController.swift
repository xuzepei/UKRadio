//
//  ContentsViewController.swift
//  UKRadio
//
//  Created by xuzepei on 17/4/26.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class ContentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var indicator: MBProgressHUD? = nil
    var itemArray = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        initTableView()
        loadContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "基础知识"
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
        
        self.tableView.addHeader(withTarget: self, action: #selector(ContentsViewController.loadContents))
    }
    
    func loadContents() {
        
        let urlString = "http://www.gembo.cn/app/3d/edu_controller.php?action=getBaseMainList&BigID=21"
        
        let request = HttpRequest(delegate: self)
        let b = request.post(urlString, resultSelector: #selector(ContentsViewController.requestFinished(_:)), token: nil)
        
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
        }
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.destination is SubcatalogViewController {
            
            if let selectedCell = sender as? UITableViewCell {
                
                let indexPath = self.tableView.indexPath(for: selectedCell)!
                if let item = self.getItemByIndex(indexPath.row) as? [String: Any] {
                    let temp = segue.destination as! SubcatalogViewController
                    temp.loadContents(item: item)
                }
            }
        }
        
        //print("\(#function)")
    }
    
}

extension ContentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "contents_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        let item = itemArray[indexPath.row]
        
        if let temp =  cell as? ContentsTableViewCell {
            temp.textLabel?.text = item["title"] as? String
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
            
            //            if let url = item["url"] as? String {
            //
            //                if let temp = RCWebViewController(true) {
            //                    temp.hidesBottomBarWhenPushed = true
            //                    temp.updateContent(url, title: "游戏资讯")
            //                    self.navigationController!.pushViewController(temp, animated: true)
            //                }
            //            }
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
