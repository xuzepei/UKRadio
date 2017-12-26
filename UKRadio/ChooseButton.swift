//
//  ChooseButton.swift
//  UKRadio
//
//  Created by xuzepei on 23/12/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

import UIKit

class ChooseButton: UIView {
    
    var clickedEventCallback: ((_ button: ChooseButton) -> Void)? = nil

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        
        self.layer.cornerRadius = 7.0
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if let image = UIImage(named: "selection_btn_\(self.tag).png") {
            image.draw(in: self.bounds)
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        NSLog("Clicked button index: \(self.tag)")
        
        if let callback = clickedEventCallback {
            
            return callback(self)
        }
        
    }

}
