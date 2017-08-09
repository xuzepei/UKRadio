//
//  ZhuangBeiViewController.swift
//  UKRadio
//
//  Created by xuzepei on 25/07/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

import UIKit

class ZhuangBeiViewController: UIViewController {

    @IBOutlet weak var pageContentView: FSPageContentView!
    var indicator: MBProgressHUD? = nil
    var titleView: FSSegmentTitleView? = nil
    var navigationBarHeight: CGFloat = 0.0
    var tabBarHeight: CGFloat = 0.0
    var zbArray: [[[String:String]]]? = nil
    var zbVCs:[ZhuangBeiCollectionViewController]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.navigationBarHeight = self.navigationController!.navigationBar.frame.size.height
        self.tabBarHeight = self.tabBarController!.tabBar.bounds.height
        
        initViewSize()
        initSegmentView()
        updateContentForHeros()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "装备"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewSize () {
        
        var rect = self.view.frame
        rect.origin.y = 0;
        rect.size.width = UIScreen.main.bounds.width
        rect.size.height = UIScreen.main.bounds.height - self.navigationBarHeight
        self.view.frame = rect;
        
    }
    
    func updateContentForHeros() {
        
        let urlString = "http://m.news.4399.com/gonglue/wzlm/daoju/";
        let token:[String: Any]! = ["type": "zhuangbei"];
        
        let request = HttpRequest(delegate: self)
        let b = request.get(urlString, resultSelector: #selector(type(of: self).requestHerosFinished(_:)), token: token)
        
        if b == true {
            self.indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.indicator!.labelText = "Loading..."
        }
        
    }
    
    func requestHerosFinished(_ dict: NSDictionary) {
        
        if let indicator = self.indicator {
            indicator.hide(false)
        }
        
        let data: Data? = dict.object(forKey: "k_data") as? Data
        
        if data != nil {
            
            let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            let htmlString = String(data: data!, encoding: String.Encoding(rawValue: gbkEncoding)) ?? ""
            
            if let array = HttpParser.sharedInstace().parse(forZhuangBei: htmlString) as? [[[String:String]]] {
                
                if let type = dict.object(forKey: "type") as? String {
                    if type == "zhuangbei" {
                        
                        self.zbArray = array
                        initPageView()
                    }
                    else
                    {
                    }
                }
            }
        }
        
    }
    
    
    func initSegmentView () {
        
        self.titleView = FSSegmentTitleView(frame: CGRect(x: 20, y: self.navigationBarHeight + 20, width: self.view.bounds.size.width - 40, height: 30), titles:["全部", "攻击", "法术", "防御", "移动", "打野"], delegate: self, indicatorType: FSIndicatorTypeNone)
        self.titleView?.titleFont = UIFont.systemFont(ofSize: 14)
        self.titleView?.titleSelectFont = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(self.titleView!)
    }
    
    func initPageView () {
        
        var vcs = [ZhuangBeiCollectionViewController]()
        if let array = self.zbArray {
            
            for item in array {
                let vc = ZhuangBeiCollectionViewController(nibName: nil, bundle: nil)
                vc.itemArray = item
                vcs.append(vc)
            }
        }
        
        
        self.pageContentView.translatesAutoresizingMaskIntoConstraints = true;
        var rect = self.pageContentView.frame
        rect.origin.y = self.navigationBarHeight + 20
        rect.size.width = self.view.bounds.width
        rect.size.height = self.view.bounds.height - self.tabBarHeight - 30
        self.pageContentView.frame = rect;
        
        self.zbVCs = vcs
        self.pageContentView.updateContent(self.zbVCs, parentVC: self, delegate: self)
        
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

extension ZhuangBeiViewController: FSSegmentTitleViewDelegate, FSPageContentViewDelegate {
    
    // MARK: - FSSegmentTitleViewDelegate
    func fsSegmentTitleView(_ titleView: FSSegmentTitleView!, start startIndex: Int, end endIndex: Int) {
        
        self.pageContentView.contentViewCurrentIndex = endIndex
        
        //        if let heroVCs = self.heroVCs {
        //
        //            if(endIndex < heroVCs.count)
        //            {
        //                let vc = heroVCs[endIndex]
        //                vc.updateCotent(itemArray: self.heroArray?[endIndex])
        //            }
        //        }
        
    }
    
    // MARK: - FSPageContentViewDelegate
    
    func fsContenViewDidEndDecelerating(_ contentView: FSPageContentView!, start startIndex: Int, end endIndex: Int) {
        
        self.titleView?.selectIndex = endIndex
    }

}
