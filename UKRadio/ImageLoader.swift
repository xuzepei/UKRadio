//
//  ImageLoader.swift
//  UKRadio
//
//  Created by xuzepei on 17/5/26.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class ImageLoader: NSObject {
    
    static let sharedInstance = ImageLoader()
    var requestingUrls = [String]()
    var requestFailedUrls = [String]()
    
    func downloadImage(_ urlString : String, token : [String : AnyObject]?, result: ((String?, NSDictionary?, Error?) -> Void)?) -> Void
    {
        if requestingUrls.contains(urlString) {
            return
        }
        
//        if requestFailedUrls.contains(urlString) {
//            return
//        }
        
        let request = HttpRequest()
        let b = request.downloadImage(urlString, token: token, result: { (imageData: Data?, token: NSDictionary?, error: Error?) in
            
            if let index = self.requestingUrls.index(of: urlString) {
                self.requestingUrls.remove(at: index)
            }
            
            if error != nil {
                
                print("\(#function),error:", error!.localizedDescription)
                self.requestFailedUrls.append(urlString)
            }
            else {
                
                Tool.saveImage(imageData, imageUrl: urlString)
            
             }
            
            if result != nil {
                result!(urlString, token, error)
            }
            
            
            })
        
        if b == true {
            requestingUrls.append(urlString)
        } else {
        
            if result != nil {
                result!(urlString, token as! NSDictionary, nil)
            }
        }
    
    }

}
