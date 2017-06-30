//
//  VideoTableViewCell.swift
//  UKRadio
//
//  Created by xuzepei on 2017/6/27.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    var item : [String : Any]? = nil
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateContent(item: [String: Any]?) {
    
        self.item = item
        
        if nil == self.item {
            return
        }
        
        
        self.titleLabel.text = self.item!["title"] as? String
        
        self.videoImageView.image = Tool.isOpenAll() ? UIImage(named: "logo") : nil
        
        if let imageUrl = self.item!["icon"] as? String, imageUrl.characters.count > 0{
            if let image = Tool.getImageFromLocal(imageUrl) {
                self.videoImageView.image = image
            } else {
                
                ImageLoader.sharedInstance.downloadImage(imageUrl, token: nil, result: { (url:String?, token: NSDictionary?, error: Error?) in
                    
                    if nil == error {
                        self.videoImageView.image = Tool.getImageFromLocal(imageUrl)
                    }
                })
            }
        }
    
    }

}
