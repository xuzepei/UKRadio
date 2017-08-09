//
//  HomeViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/6/20.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var pageContentView: FSPageContentView!
    
    var titleView: FSSegmentTitleView? = nil
    var navigationBarHeight: CGFloat = 0.0
    var tabBarHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.navigationBarHeight = self.navigationController!.navigationBar.frame.size.height
        self.tabBarHeight = self.tabBarController!.tabBar.bounds.height
        
        initViewSize()
        initSegmentView()
        initPageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "攻略"
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
        rect.size.width = UIScreen.main.bounds.width
        rect.size.height = UIScreen.main.bounds.height - self.navigationBarHeight
        self.view.frame = rect;
        
    }
    
    func initSegmentView () {
        
        self.titleView = FSSegmentTitleView(frame: CGRect(x: 0, y: 0, width: 320, height: 30), titles:["最新资讯", "攻略秘籍", "英雄出装"], delegate: self, indicatorType: FSIndicatorType(rawValue: 0))
        self.titleView?.titleFont = UIFont.systemFont(ofSize: 18)
        self.titleView?.titleSelectFont = UIFont.systemFont(ofSize: 18)
        self.navigationItem.titleView = self.titleView;
        
    }
    
    func initPageView () {
        
        let firstVC = FirstViewController(nibName: nil, bundle: nil)
        let secondVC = SecondViewController(nibName: nil, bundle: nil)
        let thirdVC = ThirdViewController(nibName: nil, bundle: nil)

        self.pageContentView.translatesAutoresizingMaskIntoConstraints = true;
        var rect = self.pageContentView.frame
        rect.origin.y = self.navigationBarHeight + 20
        rect.size.width = self.view.bounds.width
        rect.size.height = self.view.bounds.height - self.tabBarHeight
        self.pageContentView.frame = rect;


        self.pageContentView.updateContent([firstVC, secondVC, thirdVC], parentVC: self, delegate: self)
        
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

extension HomeViewController: FSSegmentTitleViewDelegate, FSPageContentViewDelegate {
    
    // MARK: - FSSegmentTitleViewDelegate
    func fsSegmentTitleView(_ titleView: FSSegmentTitleView!, start startIndex: Int, end endIndex: Int) {
        print("\(#function)")
        
        self.pageContentView.contentViewCurrentIndex = endIndex
    }
    
    // MARK: - FSPageContentViewDelegate
    
    func fsContenViewDidEndDecelerating(_ contentView: FSPageContentView!, start startIndex: Int, end endIndex: Int) {
        
        self.titleView?.selectIndex = endIndex
    }
}
