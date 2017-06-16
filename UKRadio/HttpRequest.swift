//
//  HttpRequest.swift
//  UKRadio
//
//  Created by xuzepei on 17/5/18.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

@objc protocol HttpRequestProtocol {
    optional func willStartHttpRequest(token : AnyObject)
    optional func didFinishHttpRequest(token : AnyObject)
    optional func didFailHttpRequest(token : AnyObject)
}

public class HttpRequest: NSObject{

    static let sharedInstance = HttpRequest()
    var isRequesting = false
    var resultSelector : Selector = nil
    var token : [String : AnyObject]?
    var requestUrlString : String = ""
    var dataTask : NSURLSessionDataTask?
    var uploadTask : NSURLSessionUploadTask?
    weak var delegate : AnyObject?
    
    
    func get(urlString : String, resultSelector : Selector, token : [String : AnyObject]?) -> Bool {
    
        print("request-get:", urlString)
        
        let urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        if urlString.characters.count == 0 || self.isRequesting {
            return false
        }
        
        self.resultSelector = resultSelector
        self.token = token
        self.requestUrlString = urlString
    
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.requestUrlString)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 20)
        request.HTTPShouldHandleCookies = false
        request.HTTPMethod = "GET"
        
        self.isRequesting = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let session = NSURLSession.sharedSession()
        self.dataTask = session.dataTaskWithRequest(
            request, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?) in
                
                if let requestError = error {
                
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? NSHTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                }
                
                
                var jsonString = ""
                
                if let receivedData = data {
                
                    jsonString = String(data: receivedData, encoding: NSUTF8StringEncoding) ?? ""
                }

                self.dataTask = nil
                self.isRequesting = false
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                if (self.delegate?.respondsToSelector(self.resultSelector)) != false {

                    
                    let dict = NSMutableDictionary(dictionary: ["json" : jsonString])
                    if let token = self.token {
                        dict.addEntriesFromDictionary(token)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.performSelector(self.resultSelector, withObject: dict)
                    }
                    
                }
        })
        
        self.dataTask?.resume()
  
        return true
    }
    
    func post(urlString : String, resultSelector : Selector, token : [String : AnyObject]) -> Bool {
        
        print("request-post:", urlString)
        
        let urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        if urlString.characters.count == 0 || self.isRequesting {
            return false
        }
        
        self.resultSelector = resultSelector
        self.token = token
        self.requestUrlString = urlString
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.requestUrlString)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 20)
        request.HTTPShouldHandleCookies = false
        request.HTTPMethod = "POST"
        
        if let body = token["body"] as? NSData {
            request.HTTPBody = body
        }
        
        self.isRequesting = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let session = NSURLSession.sharedSession()
        self.dataTask = session.dataTaskWithRequest(
            request, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?) in
                
                if let requestError = error {
                    
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? NSHTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                }
                
                var jsonString = ""
                
                if let receivedData = data {
                    
                    jsonString = String(data: receivedData, encoding: NSUTF8StringEncoding) ?? ""
                }
                
                self.dataTask = nil
                self.isRequesting = false
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if (self.delegate?.respondsToSelector(self.resultSelector)) != false {
                    
                    
                    let dict = NSMutableDictionary(dictionary: ["json" : jsonString])
                    if let token = self.token {
                        dict.addEntriesFromDictionary(token)
                    }
                    self.delegate?.performSelector(self.resultSelector, withObject: dict)
                }
        })
        
        self.dataTask?.resume()
        
        return true
        
    }

    
    func downloadImage(urlString : String, token : [String : AnyObject]?, result: ((NSData?, NSDictionary?, NSError?) -> Void)?) -> Bool {
    
        print("downloadImage:", urlString)
        
        let urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        if urlString.characters.count == 0 || self.isRequesting {
            return false
        }
        
        self.token = token
        self.requestUrlString = urlString
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.requestUrlString)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 20)
        request.HTTPShouldHandleCookies = false
        request.HTTPMethod = "GET"
        
        self.isRequesting = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let session = NSURLSession.sharedSession()
        self.dataTask = session.dataTaskWithRequest(
            request, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?) in
                
                if let requestError = error {
                    
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? NSHTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                }
                
                
                let dict = NSMutableDictionary()

                self.dataTask = nil
                self.isRequesting = false
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if result != nil {
                    
                    if let token = self.token {
                        dict.addEntriesFromDictionary(token)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        result!(data, dict, error)
                    }
                    
                }
        })
        
        self.dataTask?.resume()
        
        return true
    
    }

}
