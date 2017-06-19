//
//  HttpRequest.swift
//  UKRadio
//
//  Created by xuzepei on 17/5/18.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

@objc protocol HttpRequestProtocol {
    @objc optional func willStartHttpRequest(_ token : AnyObject)
    @objc optional func didFinishHttpRequest(_ token : AnyObject)
    @objc optional func didFailHttpRequest(_ token : AnyObject)
}

open class HttpRequest: NSObject{

    static let sharedInstance = HttpRequest()
    var isRequesting = false
    var resultSelector : Selector? = nil
    var token : [String : AnyObject]?
    var requestUrlString : String = ""
    var dataTask : URLSessionDataTask?
    var uploadTask : URLSessionUploadTask?
    weak var delegate : AnyObject?
    
    
    func get(_ urlString : String, resultSelector : Selector, token : [String : AnyObject]?) -> Bool {
    
        print("request-get:", urlString)
        
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        if urlString.characters.count == 0 || self.isRequesting {
            return false
        }
        
        self.resultSelector = resultSelector
        self.token = token
        self.requestUrlString = urlString
    
        
        var request = URLRequest(url: URL(string: self.requestUrlString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        
        request.httpShouldHandleCookies = false
        request.httpMethod = "GET"
        
        self.isRequesting = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession.shared
        self.dataTask = session.dataTask(
            with: request, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                if let requestError = error {
                
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                }
                
                
                var jsonString = ""
                
                if let receivedData = data {
                
                    jsonString = String(data: receivedData, encoding: String.Encoding.utf8) ?? ""
                }

                self.dataTask = nil
                self.isRequesting = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

                if (self.delegate?.responds(to: self.resultSelector)) != false {

                    
                    let dict = NSMutableDictionary(dictionary: ["json" : jsonString])
                    if let token = self.token {
                        dict.addEntries(from: token)
                    }
                    
                    DispatchQueue.main.async {
                        self.delegate?.perform(self.resultSelector, with: dict)
                    }
                    
                }
        })
        
        self.dataTask?.resume()
  
        return true
    }
    
    func post(_ urlString : String, resultSelector : Selector, token : [String : AnyObject]) -> Bool {
        
        print("request-post:", urlString)
        
        let urlString = urlString.addingPercentEscapes(using: String.Encoding.utf8)!
        if urlString.characters.count == 0 || self.isRequesting {
            return false
        }
        
        self.resultSelector = resultSelector
        self.token = token
        self.requestUrlString = urlString
        
        
        var request = URLRequest(url: URL(string: self.requestUrlString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        request.httpShouldHandleCookies = false
        request.httpMethod = "POST"
        
        if let body = token["body"] as? Data {
            request.httpBody = body
        }
        
        self.isRequesting = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession.shared
        self.dataTask = session.dataTask(
            with: request, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                if let requestError = error {
                    
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                }
                
                var jsonString = ""
                
                if let receivedData = data {
                    
                    jsonString = String(data: receivedData, encoding: String.Encoding.utf8) ?? ""
                }
                
                self.dataTask = nil
                self.isRequesting = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if (self.delegate?.responds(to: self.resultSelector)) != false {
                    
                    
                    let dict = NSMutableDictionary(dictionary: ["json" : jsonString])
                    if let token = self.token {
                        dict.addEntries(from: token)
                    }
                    self.delegate?.perform(self.resultSelector, with: dict)
                }
        })
        
        self.dataTask?.resume()
        
        return true
        
    }

    
    func downloadImage(_ urlString : String, token : [String : AnyObject]?, result: ((Data?, NSDictionary?, Error?) -> Void)?) -> Bool {
    
        print("downloadImage:", urlString)
        
        let urlString = urlString.addingPercentEscapes(using: String.Encoding.utf8)!

        if urlString.characters.count == 0 || self.isRequesting {
            return false
        }
        
        self.token = token
        self.requestUrlString = urlString
        
        
        var request = URLRequest(url: URL(string: self.requestUrlString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        request.httpShouldHandleCookies = false
        request.httpMethod = "GET"
        
        self.isRequesting = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession.shared
        self.dataTask = session.dataTask(
            with: request, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                if let requestError = error {
                    
                    print("Http request error:", requestError.localizedDescription)
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    
                    print("HTTP status code:", httpURLResponse.statusCode)
                }
                
                
                let dict = NSMutableDictionary()

                self.dataTask = nil
                self.isRequesting = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if result != nil {
                    
                    if let token = self.token {
                        dict.addEntries(from: token)
                    }
                    
                    DispatchQueue.main.async {
                        
                        result!(data, dict, error)
                    }
                    
                }
        })
        
        self.dataTask?.resume()
        
        return true
    
    }

}
