//
//  PickerCollectionViewCell.swift
//  UKRadio
//
//  Created by xuzepei on 2017/12/19.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class PickerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateContent() {
        
        self.photoImageView.image = UIImage(named: "IMG_3059.PNG")
    }

}
