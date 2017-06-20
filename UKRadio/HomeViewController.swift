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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.translatesAutoresizingMaskIntoConstraints = true
        initViewSize()
        initSegmentView()
        initPageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewSize () {
        
        var rect = self.view.frame
        rect.size.width = UIScreen.main.bounds.width
        rect.size.height = UIScreen.main.bounds.height - self.navigationController!.navigationBar.frame.size.height
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
        let thirdVC = UIViewController(nibName: nil, bundle: nil)
        
        //print("-------\(self.tabBarController!.tabBar.frame.size.height)")
        
        self.pageContentView.translatesAutoresizingMaskIntoConstraints = true;
        
        var rect = self.pageContentView.frame
        rect.size.width = firstVC.view.bounds.width
        rect.size.height = firstVC.view.bounds.height - self.navigationController!.navigationBar.frame.size.height - self.tabBarController!.tabBar.frame.size.height
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
