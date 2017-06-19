//
//  FirstViewController.swift
//  UKRadio
//
//  Created by xuzepei on 16/9/23.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension FirstViewController: UICollectionViewDelegate {

}

extension FirstViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell_id", for: indexPath)
        cell.backgroundColor = UIColor.yellow
        return cell
        
    }
    
}

extension FirstViewController : UICollectionViewDelegateFlowLayout {
//    //1
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        let flickrPhoto =  photoForIndexPath(indexPath)
//        //2
//        if var size = flickrPhoto.thumbnail?.size {
//            size.width += 10
//            size.height += 10
//            return size
//        }
//        return CGSize(width: 100, height: 100)
//    }
//    
//    //3
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
}

