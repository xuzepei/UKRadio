//
//  ToolsCollectionViewCell.swift
//  UKRadio
//
//  Created by xuzepei on 2017/8/9.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class ToolsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        self.iconView.layer.cornerRadius = 10
        self.iconView.layer.masksToBounds = true;
    }
}
