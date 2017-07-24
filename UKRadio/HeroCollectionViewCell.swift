//
//  HeroCollectionViewCell.swift
//  UKRadio
//
//  Created by xuzepei on 2017/7/17.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var item : [String : String]? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateContent(item: [String : String]?) {
        
        self.item = item
        
        if nil == self.item {
            return
        }
        
        self.textLabel.text = self.item!["name"]
        self.imageView.image = nil;
        
        if let imageUrl = self.item!["image_url"] {
            if let image = Tool.getImageFromLocal(imageUrl) {
                self.imageView.image = image
            } else {
                
                ImageLoader.sharedInstance.downloadImage(imageUrl, token: nil, result: { (url:String?, token: NSDictionary?, error: Error?) in
                    
                    if nil == error {
                        self.imageView.image = Tool.getImageFromLocal(imageUrl)
                    }
                })
            }
        }

    }

}
