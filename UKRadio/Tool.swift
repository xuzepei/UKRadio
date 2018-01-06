//
//  Tool.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/6/20.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit
import GoogleMobileAds

fileprivate var showParticleEffectTimes: Int = 0

@objc class Tool: NSObject {
    
    static let sharedInstance = Tool()
    
    class func documentDirectory() -> String {
        
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
    }
    
    class func md5(_ sourceString:String?) -> String {
        
        if let data = sourceString?.data(using: String.Encoding.utf8) {
            
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
            
            var digestHex = ""
            for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
                digestHex += String(format: "%02x", digest[index])
            }
            
            return String(describing: digest).lowercased()
        }
        
        return ""
    }
    
    class func showAlert(_ title:String?, message:String?) {
        
        let alert = UIAlertView(title: title, message: message
            , delegate: nil, cancelButtonTitle: "OK")
        alert.tag = 110
        alert.show()
    }
    
    class func isPad() -> Bool {
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return true
        }
        
        return false
    }
    
    //MARK: - Parser
    class func parseToDictionary(_ jsonString:String?) -> [String:AnyObject]? {
        
        if let data = jsonString?.data(using: String.Encoding.utf8) {
            
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
            } catch let error as NSError{
                print(error)
            }
        }
        
        return nil
    }
    
    class func parseToArray(_ jsonString:String?) -> [AnyObject]? {
        
        if let data = jsonString?.data(using: String.Encoding.utf8) {
            
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        
        return nil
    }
    
    //MARK: - Networking
    class func isReachableViaInternet() -> Bool {
        
        let reaching = Reachability.forInternetConnection()
        let networkStatus: Int = reaching!.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
    class func isReachableViaWifi() -> Bool {
        let reaching = Reachability.forInternetConnection()
        let networkStatus: Int = reaching!.currentReachabilityStatus().rawValue
        return networkStatus == 1
    }
    
    //MARK: - File Manager
    class func isExistingFile(_ path: String) -> Bool {
        return FileManager.default .fileExists(atPath: path)
    }
    
    class func saveImage(_ imageData: Data?, imageUrl: String!) -> Bool {
        
        if imageData == nil {
            return false
        }
        
        if imageUrl.characters.count <= 0 {
            return false
        }
        
        let directoryPath = NSTemporaryDirectory() + "/images/"
        if Tool.isExistingFile(directoryPath) == false {
            
            do {
                try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: nil)
            } catch {
                return false
            }
        }
        
        //        var suffix = "";
        //        var range = imageUrl.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
        //        if let range = range where range.count <= 4 {
        //            suffix = imageUrl.substringFromIndex(range.startIndex)
        //        }
        
        if let savePath = Tool.getImageLocalPath(imageUrl) {
            return ((try? imageData!.write(to: URL(fileURLWithPath: savePath), options: [.atomic])) != nil)
        }
        
        return false
    }
    
    class func getImageLocalPath(_ imageUrl: String?) -> String? {
        
        if let imageUrl = imageUrl, imageUrl.characters.count > 0 {
            let directoryPath = NSTemporaryDirectory() + "/images/"
            let md5String = Tool.md5(imageUrl)
            return directoryPath + "\(md5String)"
        }
        
        return nil
    }
    
    class func getImageFromLocal(_ imageUrl: String?) -> UIImage? {
        
        if let imageLocalPath = Tool.getImageLocalPath(imageUrl) {
            
            if FileManager.default.fileExists(atPath: imageLocalPath) {
                return UIImage(contentsOfFile: imageLocalPath)
            }
        }
        
        return nil
    }
    
    //MARK: - Decrypt
    
    class func decrypt(_ encryptedString : String!) -> String? {
        
        return RCEncryption.decryptUseDES(encryptedString, key: GlobalDefinitions.secretKey)
    }
    
    
    class func getBannerAd() -> UIView? {
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            return appDelegate.bannerView
        }
        
        return nil
    }
    
    class func getInterstitial() -> GADInterstitial? {
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            return appDelegate.interstitial
        }
        
        return nil
    }
    
    class func showInterstitial(vc: UIViewController, immediately: Bool = false) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            return appDelegate.showInterstitial(vc:vc, immediately: immediately)
        }
        
        
        return;
    }
    
    class func recordSaveTimes() {
        
        var times = 0
        if let number = UserDefaults.standard.object(forKey: "save_times") as? NSNumber {
            
            times = number.intValue + 1
        }
        else
        {
            times = 1
        }
        
        UserDefaults.standard.set(times, forKey: "save_times")
        UserDefaults.standard.synchronize()
    }
    
    class func getSaveTimes() -> Int {
        
        var times = 0
        if let number = UserDefaults.standard.object(forKey: "save_times") as? NSNumber {
            times = number.intValue
        }
        
        return times
    }
    
    class func recordLaunchTimes() -> Int {
        
        var times = 0
        if let number = UserDefaults.standard.object(forKey: "launch_times") as? NSNumber {
            
            times = number.intValue + 1
        }
        else
        {
            times = 1
        }
        
        UserDefaults.standard.set(times, forKey: "launch_times")
        UserDefaults.standard.synchronize()
        return times
    }
    
    class func recordRate() {
        UserDefaults.standard.set(true, forKey: "is_rated")
        UserDefaults.standard.synchronize()
    }
    
    class func isRated() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "is_rated")
    }
    
    class func toast(message: String) {
        
        if Tool.recordLaunchTimes() < 30 {
            UIApplication.shared.keyWindow?.rootViewController?.view .makeToast(message, duration: CSToastManager.defaultDuration(), position: CSToastPositionCenter)
        }
        
    }
    
    class func isOpenAll() -> Bool {
        
        let comps = NSDateComponents()
        comps.day = 7
        comps.month = 1
        comps.year = 2018
        
        let date = NSCalendar.current.date(from: comps as DateComponents)
        let startDate = Date()
        
        if startDate .timeIntervalSince(date!) > 3*24*60*60 {
            
            return true
        }
        
        return false
    }
    
    class func newRateUs() {
        
        if let newClass = NSClassFromString("SKStoreReviewController") {
            
            if newClass.responds(to: #selector(newClass.requestReview)) == true {
                newClass.requestReview()
            }
        }
        
    }
    
    class func showParticleEffect() {
        
        showParticleEffectTimes += 1
        
        if showParticleEffectTimes % 10 == 0 || showParticleEffectTimes == 2 {
            
            SnowParticleEffects.show()
            
        }
        
    }
    
}


extension UIColor {
    
    class func color(_ hexString:String) -> UIColor {
        
        //var hexString:NSString = NSString(string: hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercased())
        
        var hexString: NSString = NSString(string: hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased())
        
        // String should be 6 or 8 characters
        if hexString.length < 6 {
            return UIColor.clear
        }
        
        // strip 0X if it appears
        if hexString.hasPrefix("0X") || hexString.hasPrefix("0x"){
            hexString = hexString.substring(from: 2) as NSString
        }
        if hexString.hasPrefix("#") {
            hexString = hexString.substring(from: 1) as NSString
        }
        if hexString.length != 6 {
            return UIColor.clear
        }
        
        // Separate into r, g, b substrings
        var range = NSRange.init(location: 0, length: 2)
        
        //r
        let rString = hexString.substring(with: range)
        
        //g
        range.location = 2;
        let gString = hexString.substring(with: range)
        
        //b
        range.location = 4;
        let bString = hexString.substring(with: range)
        
        // Scan values 
        var r, g, b: UInt32
        r = 0; g = 0; b = 0
        
        Scanner.init(string: rString).scanHexInt32(&r);
        Scanner.init(string: gString).scanHexInt32(&g);
        Scanner.init(string: bString).scanHexInt32(&b);
        
        
        return UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: 1.0)
    }
}
