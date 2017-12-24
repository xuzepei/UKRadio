//
//  SelectedMark.swift
//  UKRadio
//
//  Created by xuzepei on 23/12/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

import UIKit

class SelectedMark: UIView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.tag = 999
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.yellow.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        
    }
    

}
