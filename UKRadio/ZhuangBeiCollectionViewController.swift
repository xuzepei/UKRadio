//
//  ZhuangBeiCollectionViewController.swift
//  UKRadio
//
//  Created by xuzepei on 25/07/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collection_cell"

class ZhuangBeiCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    var itemArray:[[String: String]]? = nil;
    
    func updateCotent(itemArray: [[String: String]]?) {
        
        self.itemArray = itemArray
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Register cell classes from xib
        self.collectionView.register(UINib(nibName: "HeroCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        
        //        var rect = self.collectionView.frame
        //        rect.origin.y = 0;
        //        rect.origin.x = 0;
        //        rect.size.width = self.view.bounds.size.width
        //        rect.size.height = self.view.bounds.size.height
        //        self.collectionView.frame = rect
        
        if Tool.isPad() {
            
        } else {
            let width = (UIScreen.main.bounds.size.width - 80)/4.0
            collectionLayout.itemSize = CGSize(width: width, height: width + 20)
            collectionLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        }
        
        updateCotent(itemArray: self.itemArray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    func getItemByIndex(_ index: Int) -> [String : String]? {
        
        if let array = self.itemArray {
            if index >= 0  && index < array.count {
                return array[index] as [String : String]
            }
        }
        
        return nil
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if let array = self.itemArray {
            return array.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let mycell = cell as? HeroCollectionViewCell {
            
            if let item = self.getItemByIndex(indexPath.row) {
                
                mycell .updateContent(item: item)
                
            }
        }
        
        return cell
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
        
        if let item = self.getItemByIndex(indexPath.row) {
            
            if let url = item["url"] {
                
                let temp = RCWebViewController()
                temp.hidesBottomBarWhenPushed = true
                temp.updateContent(url, title: "装备")
                self.navigationController!.pushViewController(temp, animated: true)
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
