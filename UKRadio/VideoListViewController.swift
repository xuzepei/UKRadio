//
//  VideoListViewController.swift


import UIKit

class VideoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var indicator: MBProgressHUD? = nil
    var itemArray = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        loadContents()
    }
    
    func arrangeBanner () {
        
        if let bannerView = Tool.getBannerAd() {
            
            bannerView.translatesAutoresizingMaskIntoConstraints = true
            var rect = bannerView.frame
            rect.origin.x = (self.view.bounds.size.width - rect.size.width)/2.0
            rect.origin.y = (self.tabBarController?.tabBar.frame.origin.y)! - rect.size.height
            bannerView.frame = rect
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "视频教程"
        
        if let bannerView = Tool.getBannerAd() {
            UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(bannerView)
        }
        
        self.perform(#selector(arrangeBanner), with: nil, afterDelay: 0.3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        //self.title = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTableView() {
        
        self.tableView.addHeader(withTarget: self, action: #selector(VideoListViewController.loadContents))
    }
    
    func loadContents() {
        
        let urlString = "http://appdream.sinaapp.com/api/python.php"
        
        let request = HttpRequest(delegate: self)
        let b = request.get(urlString, resultSelector: #selector(VideoListViewController.requestFinished(_:)), token: nil)
        
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
            
            var htmlString = String(data: data, encoding: String.Encoding.utf8) ?? ""
            htmlString = Tool.decrypt(htmlString) ?? ""
            
            if let dict = Tool.parseToDictionary(htmlString) {
                
                if let array = dict["list"] as? [[String : Any]] {
                    self.itemArray.removeAll()
                    self.itemArray = array
                }
                
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
        
        
        if segue.destination is VideoSubcatalogViewController {
            
            if let selectedCell = sender as? UITableViewCell {
                
                let indexPath = self.tableView.indexPath(for: selectedCell)!
                if let item = self.getItemByIndex(indexPath.row) as? [String: Any] {
                    let temp = segue.destination as! VideoSubcatalogViewController
                    temp.loadContents(item: item)
                }
            }
        }
        
        //print("\(#function)")
    }
    
}

extension VideoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "video_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        let item = itemArray[indexPath.row]
        
        if let temp =  cell as? VideoTableViewCell {
            //temp.textLabel?.text = item["title"] as? String
            
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
            
            let type = item["typeId"] as! NSString
            
            if type.isEqual(to: "1") == true {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let temp = storyboard.instantiateViewController(withIdentifier: "vc_videosubcatalog") as! VideoSubcatalogViewController
                //temp.hidesBottomBarWhenPushed = true
                temp.loadContents(item: item as? [String : Any])
                self.navigationController!.pushViewController(temp, animated: true)
                
            } else {
                if let url = item["url"] as? String {
                    
                    let title = item["name"] as! String
                    
//                    if let temp = RCWebViewController(true) {
//                        temp.hidesBottomBarWhenPushed = true
//                        temp.updateContent(url, title: title)
//                        self.navigationController!.pushViewController(temp, animated: true)
//                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let temp = storyboard.instantiateViewController(withIdentifier: "VideoWebViewController") as! VideoWebViewController
                    temp.hidesBottomBarWhenPushed = true
                    temp.updateContent(url, title: title)
                    self.navigationController!.pushViewController(temp, animated: true)
                    
                }
            }
            

            
        }
        
    }
    
}
