//
//  ImageLayer.swift
//  UKRadio
//
//  Created by xuzepei on 2018/10/10.
//  Copyright © 2018 xuzepei. All rights reserved.
//

import UIKit

class ImageLayer: CALayer {
    
    let image: CALayer = CALayer()
    let corner: CGFloat = 20
    
    let text: CATextLayer = CATextLayer()
    let textHeight: CGFloat = 20
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateContent(image: UIImage? , title: String = "", fontSize: CGFloat = 12) {
        
        self.image.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height - textHeight)
        self.image.backgroundColor = UIColor.yellow.cgColor
        self.image.cornerRadius = corner
        self.image.masksToBounds = true
        
        if image != nil {
            self.image.contents = image?.cgImage
        }
        
        self.addSublayer(self.image)
        
        text.frame = CGRect(x: 0, y: self.bounds.size.height - textHeight, width: self.bounds.size.width, height: textHeight)
        text.backgroundColor = UIColor.gray.cgColor
        text.foregroundColor = UIColor.red.cgColor
        text.font = UIFont.systemFont(ofSize: fontSize)
        text.fontSize = fontSize
        text.isWrapped = true
        text.alignmentMode = kCAAlignmentCenter
        text.contentsScale = UIScreen.main.scale
        text.string = title
        self.addSublayer(text)
        
    }
    
    
    
}
