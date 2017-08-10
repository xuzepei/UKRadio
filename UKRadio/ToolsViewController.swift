//
//  ToolsViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/8/8.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class ToolsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    var indicator: MBProgressHUD? = nil
    
    
    var dict:[String: AnyObject]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateContent()
        
        let width = (UIScreen.main.bounds.size.width-2)/3.0
        collectionLayout.itemSize = CGSize(width: width, height: width*8/10.0)
        //collectionLayout.minimumInteritemSpacing = 1;
        collectionLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        
        self.collectionView.addHeader(withTarget: self, action: #selector(ToolsViewController.headerRefresh))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "工具"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func headerRefresh() {
        print("\(#function)")
        
        updateContent()
    }
    
    func updateContent() {
        
        let urlString = "http://api.youlongtang.com/?c=gok&a=tools"
        let body = "appid=1158560788&appname=gok&client=iPhone&device=iPhone&jbk=0&market=AppStore&openudid=B17262BB-F8B4-4715-A037-E87D883195DC&ver=2.0"
        
        let bodyData = body.data(using: String.Encoding.utf8)
        let request = HttpRequest(delegate: self)
        let b = request.post(urlString, body: bodyData!, resultSelector: #selector(ToolsViewController.requestFinished(_:)), token: nil)
        
        if b == true {
            self.indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.indicator!.labelText = "Loading..."
        }
        
    }
    
    func requestFinished(_ dict: NSDictionary) {
        
        self.collectionView.headerEndRefreshing()
        //self.tableView.footerEndRefreshing()
        
        if let indicator = self.indicator {
            indicator.hide(false)
        }
        
        let jsonString = dict.object(forKey: "k_json") as! String
        if jsonString.characters.count != 0 {
            
            
            if let dict = Tool.parseToDictionary(jsonString) {
                
                self.dict = dict
            }
            
            self.collectionView.reloadData()
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getItemByIndex(_ indexPath: IndexPath) -> [String : Any]? {
        
        if let dict = self.dict {
            
            if let array = dict["data"] as? [[String: Any]]{
                
                if let tempArray = array[indexPath.section]["appList"] as? [[String: Any]] {

                    return tempArray[indexPath.row]
                }
                
            }
            
        }
        
        return nil
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if let dict = self.dict {
            
            if let array = dict["data"] as? [[String: Any]]{
                return array.count
            }
            
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if let dict = self.dict {
            
            if let array = dict["data"] as? [[String: Any]]{
                
                if let tempArray = array[section]["appList"] as? [[String: Any]] {
                    
                    return tempArray.count
                }
                
            }
            
        }
        
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tools_cell", for: indexPath)
        
        if let mycell = cell as? ToolsCollectionViewCell {

            if let item = self.getItemByIndex(indexPath) {

                if let imageName = item["recommendIcon"] as? String {
                    mycell.iconView.image = UIImage(named: imageName)
                }
                
                mycell.name.text = item["recommendName"] as? String
                
                if let url = item["recommendUrl"] as? String, url.characters.count > 0{
                }else {
                    mycell.name.text = "视频广告"
                }

            }
        }
        
        cell.contentView.backgroundColor = UIColor.white
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        
        //if kind == UICollectionElementKindSectionHeader {
        
        let reusableview = collectionView .dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "tools_section_header", for: indexPath)
        //reusableview.backgroundColor = UIColor.yellow
        
        if let view = reusableview as? ToolsSectionHeaderReusableView {
            
            if let dict = self.dict {
                
                if let array = dict["data"] as? [[String: Any]]{
                    
                    if let title = array[indexPath.section]["cateName"] as? String {
                        
                        view.title.text = title
                    }
                    
                }
                
            }
        }
        //}
        
        
        return reusableview
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let item = self.getItemByIndex(indexPath) {
            
            if let url = item["recommendUrl"] as? String, url.characters.count > 0{
                
                let temp = RCWebViewController()
                let title = item["recommendName"] as? String
                temp.hidesBottomBarWhenPushed = true
                temp.updateContent(url, title: title)
                self.navigationController!.pushViewController(temp, animated: true)
            } else {
            
                NSLog("Show rewarded ads");
            }
            
        }
    }
    
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    
}
