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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateContent(imageUrl: String?, name: String?) {
        
        self.textLabel.text = name
    }

}
