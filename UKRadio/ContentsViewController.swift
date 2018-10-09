//
//  ContentsViewController.swift
//  UKRadio
//
//  Created by xuzepei on 17/4/26.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class ContentsViewController: UIViewController {
    
    let headerHeight: CGFloat = 0
    let navbarHeight: CGFloat = 44
    var previousValue: CGFloat = 0
    
    let titleView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 88))
    
    var navigationBarVisibility: GKFadeNavigationControllerNavigationBarVisibility = .hidden
    
    var tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: .plain)
    var indicator: MBProgressHUD? = nil
    var itemArray = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blue

//        if let navigationController =  self.navigationController as? GKFadeNavigationController {
//            navigationController.setNeedsNavigationBarVisibilityUpdate(animated: false)
//        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        

        
        initTableView()
        loadContents()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "基础知识"
        
        if let bannerView = Tool.getBannerAd() {
        
            bannerView.translatesAutoresizingMaskIntoConstraints = true
            var rect = bannerView.frame
            rect.origin.x = (UIScreen.main.bounds.size.width - rect.size.width)/2.0
            rect.origin.y = UIScreen.main.bounds.size.height - rect.size.height
            bannerView.frame = rect
            self.view .addSubview(bannerView)
        
        }
        
        //self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow ?? nil, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        
        //self.title = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNavigationBarVisibilityStatus(navigationBarVisibility: GKFadeNavigationControllerNavigationBarVisibility) {
        
        if self.navigationBarVisibility != navigationBarVisibility {
            self.navigationBarVisibility = navigationBarVisibility
            
            if let navigationController =  self.navigationController as? GKFadeNavigationController {
                
                if let topViewController = navigationController.topViewController {
                    navigationController.setNeedsNavigationBarVisibilityUpdate(animated: true)
                }
                
            }
        }
    }
    
    func initTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.tableView)
        
        self.tableView.register(ContentsTableViewCell.self, forCellReuseIdentifier: "contents_cell")
//        self.tableView.register(UINib(nibName: "ContentsTableViewCell", bundle: nil), forCellReuseIdentifier: "contents_cell")
        
        //self.tableView.addHeader(withTarget: self, action: #selector(ContentsViewController.loadContents))
        
        self.titleView.backgroundColor = UIColor.yellow
        self.titleView.alpha = 0.5
        //self.view .addSubview(titleView)
    }
    
    func loadContents() {
        
        self.itemArray = [["title":"1"],["title":"2"],["title":"3"],["title":"4"],["title":"5"],["title":"6"],["title":"7"],["title":"8"],["title":"9"],["title":"10"],["title":"11"],["title":"12"],["title":"13"],["title":"14"],["title":"15"],["title":"16"],["title":"17"],["title":"18"]]
        return
        
        let urlString = "http://www.runoob.com/python3/python3-tutorial.html"
        
        let request = HttpRequest(delegate: self)
        let b = request.get(urlString, resultSelector: #selector(ContentsViewController.requestFinished(_:)), token: nil)
        
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
        
        if let htmlString = dict.object(forKey: "k_json") as? String {
            
            //let htmlString = String(data: data, encoding: String.Encoding.utf8) ?? ""
            
            if let array = HttpParser.sharedInstace().parse(htmlString) as? [[String: Any]]{
                
                self.itemArray.removeAll()
                self.itemArray = [["title":"1"],["title":"2"],["title":"3"],["title":"4"],["title":"5"],["title":"6"],["title":"7"],["title":"8"],["title":"9"],["title":"10"],["title":"11"],["title":"12"],["title":"13"],["title":"14"],["title":"15"],["title":"16"],["title":"17"],["title":"18"]]
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

extension ContentsViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, GKFadeNavigationControllerDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "contents_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.none;
        
        let item = itemArray[indexPath.row]
        
        if let temp =  cell as? ContentsTableViewCell {
            temp.textLabel?.text = item["title"] as? String
        }
        
        //cell.selectionStyle = UITableViewCellSelectionStyle.gray
        

        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func preferredNavigationBarVisibility() -> GKFadeNavigationControllerNavigationBarVisibility
    {
        return self.navigationBarVisibility
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offsetY = scrollView.contentOffset.y
        
        NSLog("scrollView.contentOffset.:\(scrollView.contentOffset.y)")
        
        NSLog("offsetY:\(offsetY)")
        
        NSLog("offsetY - navbarHeight:\(offsetY - navbarHeight)")
        
        
        
        if self.previousValue < offsetY {
            //向上滚动，offsetY变大
            if offsetY >= -44 && offsetY <= 0 {
                let temp: Double = (Double)(navbarHeight + offsetY)
                self.titleView.alpha = min(1.0,CGFloat(fabs(temp)/44.0))
            }
            
        } else
        {
            //向下滚动，offsetY变小
            self.titleView.alpha = max(0.0, (self.titleView.alpha - (self.previousValue - offsetY) / 44.0))
        }
        
        self.previousValue = offsetY
        
//        if temp > 0 {
//            self.titleView.alpha = max(1.0,CGFloat(fabs(temp)/44.0))
//        } else {
//            self.titleView.alpha = min(1.0,CGFloat(fabs(temp)/44.0))
//        }

        
//        if (offsetY - navbarHeight) < 24 {
//
//            NSLog(".visible")
//            self.updateNavigationBarVisibilityStatus(navigationBarVisibility: .visible)
//        } else {
//            NSLog(".hidden")
//            self.updateNavigationBarVisibilityStatus(navigationBarVisibility: .hidden)
//        }
        
    }
    
}
