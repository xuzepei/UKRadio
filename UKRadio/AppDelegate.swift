//
//  AppDelegate.swift
//  UKRadio
//
//  Created by xuzepei on 16/9/23.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit
import GoogleMobileAds

fileprivate let BANNER_ID = ""
fileprivate let INTERSTITIAL_ID = "ca-app-pub-1207330468801232/7340792458"
fileprivate let REWARDED_ID = ""
fileprivate let APP_ID = "ca-app-pub-1207330468801232~2342072055"
fileprivate let APPSTORE_URL = "https://itunes.apple.com/app/id1329377896?action=write-review"
fileprivate let APP_INFO_URL = "http://appdream.sinaapp.com/notch/info.php"


@UIApplicationMain
@objc class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var bannerView: GADBannerView? = nil
    var interstitial: GADInterstitial? = nil
    var rewaredAd: GADRewardBasedVideoAd? = nil
    var didEnterBackground = false
    var needShowInterstitial = false
    var isLaunched = false
    var showTimes = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GADMobileAds.configure(withApplicationID: APP_ID)
        
        //UINavigationBar.appearance().barTintColor = GlobalDefinitions.navigationBarColor
        //UINavigationBar.appearance().tintColor = UIColor.color("#ffffff")//UIColor.white
        //UINavigationBar.appearance().isTranslucent = false
        
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: GlobalDefinitions.navigationBarTitleColor, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 22)]
        //UITabBar.appearance().tintColor = GlobalDefinitions.navigationBarColor
        //UITabBar.appearance().barTintColor = UIColor.black
        
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
        
//        if #available(iOS 10.0, *) {
//            //UITabBar.appearance().unselectedItemTintColor = UIColor.white
//        } else {
//            // Fallback on earlier versions
//        }
        
        // set up your background color view
//        let colorView = UIView()
//        colorView.backgroundColor = UIColor.color("#24c180")//GlobalDefinitions.tableViewCellSelectedColor
//        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        self.isLaunched = true
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSLog("applicationDidEnterBackground")
        self.didEnterBackground = true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if isLaunched == true {
            self.isLaunched = false
        }
        else if self.didEnterBackground == true
        {
            self.perform(#selector(checkNetwork), with: nil, afterDelay: 20)
            
            self.didEnterBackground = false
            self.needShowInterstitial = true
        }
        
        getAppInfo()
        rate()
        getAd()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Network Checking
    func checkNetwork() {
        
        if Tool.isOpenAll() == false {
            return
        }
        
        if Tool.isReachableViaInternet() == false {
            let alertController = UIAlertController(title: "Tip", message: "To get more wallpapers, turn on WLAN for this app in Setting - Apps Using WLAN & Cellular", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action) in
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                
                if UIApplication.shared.canOpenURL(URL(string: "prefs:root=WIFI")!) == true {
                    UIApplication.shared.open(URL(string: "prefs:root=WIFI")!, options: [:], completionHandler: nil)
                } else if UIApplication.shared.canOpenURL(URL(string: "App-Prefs:root=WIFI")!) == true {
                    UIApplication.shared.open(URL(string: "App-Prefs:root=WIFI")!, options: [:], completionHandler: nil)
                }
            }))
            
            if let temp = UIApplication.shared.delegate!.window as? UIWindow {
                temp.rootViewController?.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    //MARK: - App Info
    
    func getAppInfo() {
        
        let request = HttpRequest(delegate: self)
        let b = request.get(APP_INFO_URL, resultSelector: #selector(requestFinished(_:)), token: nil)
        if b == true {
        }
        
    }
    
    func requestFinished(_ dict: NSDictionary) {
        
        if let jsonString = Tool.decrypt(dict.object(forKey: "k_json") as! String) {
            if let info = HttpParser.sharedInstace().parse(toDictionary: jsonString) as NSDictionary? {
                
                UserDefaults.standard.set(info, forKey: "app_info")
                UserDefaults.standard.synchronize()
                
                doAlert()
            }
        }
    }
    
    func doAlert()
    {
        if let info = UserDefaults.standard.dictionary(forKey: "app_info") as NSDictionary? {
            
            var title = ""
            if let temp = info["title"] as! String?, temp.count > 0{
                title = temp
            }
            
            var message = ""
            if let temp = info["message"] as! String?, temp.count > 0{
                message = temp
            }
            
            var noButton = NSLocalizedString("Cancel", comment: "")
            if let temp = info["b0_name"] as! String?, temp.count > 0{
                noButton = temp
            }
            
            var yesButton = NSLocalizedString("OK", comment: "")
            if let temp = info["b1_name"] as! String?, temp.count > 0{
                yesButton = temp
            }
            
            if message.count > 0 {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action1 = UIAlertAction(title: noButton, style: .default) { (action:UIAlertAction) in
                    print("You've pressed noButton");
                }
                
                let action2 = UIAlertAction(title: yesButton, style: .default) { (action:UIAlertAction) in
                    print("You've pressed yesButton");
                    
                    if let link = info["link"] as! String?, link.count > 0 {
                        UIApplication.shared.openURL(URL(string: link)!)
                    }

                }
                
                if noButton.count > 0 {
                    alertController.addAction(action1)
                }
                
                if yesButton.count > 0 {
                    alertController.addAction(action2)
                }
                
                if let temp = UIApplication.shared.delegate!.window as? UIWindow {
                    temp.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
            
            
            
        }
    }
    
    
    //MARK: - AD
    func getAd() {
        
        NSLog("getAD");
        
        self.requestInterstitial()
    }
    
    func requestBannerAd() {
        
        if BANNER_ID.count == 0 {
            return
        }
        
        if nil == self.bannerView {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.bannerView = GADBannerView(adSize: kGADAdSizeLeaderboard)
            } else {
                self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            }
        }
        
        self.bannerView?.delegate = self
        self.bannerView?.adUnitID = BANNER_ID
        
        self.bannerView?.rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        let request = GADRequest()
        //request.testDevices = ["624b4d7c554c69bc470b39c4ea547cf2"]
        self.bannerView?.load(request)
    }
    
    func requestInterstitial() {
        
        if Tool.isOpenAll() == false {
            return
        }
        
        if INTERSTITIAL_ID.count == 0 {
            return
        }
        
        self.interstitial = GADInterstitial(adUnitID: INTERSTITIAL_ID)
        self.interstitial?.delegate = self
        self.interstitial?.load(GADRequest())
    }
    
    func requestRewardedAd() {
        
        if REWARDED_ID.count == 0 {
            return
        }
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: REWARDED_ID)
        
    }
    
    func showInterstitial(vc: UIViewController, immediately: Bool = false) {
        
        if Tool.isOpenAll() == false {
            return
        }
        
        self.showTimes += 1
        
        if self.showTimes % 10 == 0  || immediately == true {
            
            print("###will show interstitial");
            
            if let interstitial = self.interstitial, interstitial.isReady == true {
                
                self.showTimes = 0
                interstitial.present(fromRootViewController: vc)
            }
        }
    }
    
    //MARK: - Rate
    func rate() {
        
        if Tool.isOpenAll() == false {
            return
        }
        
        let times = Tool.recordLaunchTimes()
        
        if times % 10 == 0 && false == Tool.isRated() {
            
            self.needShowInterstitial = false
            
            let title = NSLocalizedString("Notch Free", comment: "")
            let message = NSLocalizedString("If you enjoy using Notch Free, please give it a good rating and a review on AppStore. Thanks a lot.", comment: "")
            let noButton = NSLocalizedString("NO", comment: "")
            let yesButton = NSLocalizedString("OK", comment: "")
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action1 = UIAlertAction(title: noButton, style: .default) { (action:UIAlertAction) in
                NSLog("You've pressed noButton");
            }
            
            let action2 = UIAlertAction(title: yesButton, style: .default) { (action:UIAlertAction) in
                
                NSLog("go to appstore")
                Tool.recordRate()
                UIApplication.shared.openURL(URL(string: APPSTORE_URL)!)
            }
            
            alertController.addAction(action1)
            alertController.addAction(action2)
            
            if let temp = UIApplication.shared.delegate!.window as? UIWindow {
                temp.rootViewController?.present(alertController, animated: true, completion: nil)
            }
            
        }
            
        else if times % 5 == 0 && false == Tool.isRated() {
            
            self.needShowInterstitial = false
            Tool.newRateUs()
        }
    }
}

extension AppDelegate: UIAlertViewDelegate, GADBannerViewDelegate, GADInterstitialDelegate, GADRewardBasedVideoAdDelegate {
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            print("go to appstore")
            Tool.recordRate()
            UIApplication.shared.openURL(URL(string: APPSTORE_URL)!)
        }
        
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("$$$adViewDidReceiveAd")
        
        //        if nil == bannerView.superview {
        //            UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(bannerView)
        //        }
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("$$$adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        
        self.perform(#selector(AppDelegate.requestBannerAd), with: nil, afterDelay: 10)
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("$$$interstitialDidReceiveAd")
        
        if self.needShowInterstitial == true && ad.isReady == true {
            
            self.needShowInterstitial = false
            ad.present(fromRootViewController: (UIApplication.shared.delegate?.window??.rootViewController)!)
            
        }
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("$$$interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
        
        self.perform(#selector(AppDelegate.requestInterstitial), with: nil, afterDelay: 10)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
        self.requestInterstitial()
    }
    
    //MARK: - 
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        
        requestRewardedAd();
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
        
        requestRewardedAd();
    }
    
}

