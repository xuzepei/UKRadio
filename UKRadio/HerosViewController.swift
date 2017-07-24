//
//  HerosViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/7/17.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class HerosViewController: UIViewController {

    @IBOutlet weak var pageContentView: FSPageContentView!
    var indicator: MBProgressHUD? = nil
    var titleView: FSSegmentTitleView? = nil
    var navigationBarHeight: CGFloat = 0.0
    var tabBarHeight: CGFloat = 0.0
    var heroArray: [[[String:String]]]? = nil
    var heroVCs:[HeroCollectionViewController]? = nil
    
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

        self.title = "英雄"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = nil
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
        
        let urlString = "http://m.news.4399.com/gonglue/wzlm/yingxiong/";
        let token:[String: Any]! = ["type": "hero"];

        let request = HttpRequest(delegate: self)
        let b = request.get(urlString, resultSelector: #selector(HerosViewController.requestHerosFinished(_:)), token: token)
        
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
            
            if let array = HttpParser.sharedInstace().parse(forHeros: htmlString) as? [[[String:String]]] {
                
                if let type = dict.object(forKey: "type") as? String {
                    if type == "hero" {
                        
                        self.heroArray = array
                        initPageView()
                    }
                    else
                    {
                    }
                }
            }
        }
        
        
//        let htmlString = dict.object(forKey: "k_json") as! String
//        if htmlString.characters.count != 0
//        {
//            if let array = HttpParser.sharedInstace().parse(forHeros: htmlString) as? [[[String:String]]] {
//                
//                if let type = dict.object(forKey: "type") as? String {
//                    if type == "hero" {
//                        
//                        self.heroArray = array
//                        initPageView()
//                    }
//                    else
//                    {
//                    }
//                }
//            }
//        }

    }


    func initSegmentView () {
        
        self.titleView = FSSegmentTitleView(frame: CGRect(x: 20, y: 0, width: self.view.bounds.size.width - 40, height: 30), titles:["全部", "坦克", "战士", "刺客", "法师", "射手", "辅助"], delegate: self, indicatorType: FSIndicatorTypeNone)
        self.titleView?.titleFont = UIFont.systemFont(ofSize: 14)
        self.titleView?.titleSelectFont = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(self.titleView!)
    }
    
    func initPageView () {
        
        var vcs = [HeroCollectionViewController]()
        if let array = self.heroArray {
        
            for item in array {
                let vc = HeroCollectionViewController(nibName: nil, bundle: nil)
                vc.itemArray = item
                vcs.append(vc)
            }
        }
        
        
        self.pageContentView.translatesAutoresizingMaskIntoConstraints = true;
        var rect = self.pageContentView.frame
        rect.origin.y = 0
        rect.size.width = self.view.bounds.width
        rect.size.height = self.view.bounds.height - self.tabBarHeight
        self.pageContentView.frame = rect;
        
        self.heroVCs = vcs
        self.pageContentView.updateContent(self.heroVCs, parentVC: self, delegate: self)
        
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

extension HerosViewController: FSSegmentTitleViewDelegate, FSPageContentViewDelegate {
    
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
