//
//  AppDelegate.swift
//  UKRadio
//
//  Created by xuzepei on 16/9/23.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit
import GoogleMobileAds

private let BANNER_ID = ""
private let INTERSTITIAL_ID = ""
private let REWARDED_ID = ""
private let APPSTORE_URL = "https://itunes.apple.com/app/id1272769033"

@UIApplicationMain
@objc class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var bannerView: GADBannerView? = nil
    var interstitial: GADInterstitial? = nil
    var rewaredAd: GADRewardBasedVideoAd? = nil
    var needShowInterstitial = false
    var showTimes = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //GADMobileAds.configure(withApplicationID: "ca-app-pub-1207330468801232~2402219186")
        
        UINavigationBar.appearance().barTintColor = GlobalDefinitions.navigationBarColor
        UINavigationBar.appearance().tintColor = UIColor.color("#ffffff")//UIColor.white
        //UINavigationBar.appearance().isTranslucent = false
        
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: GlobalDefinitions.navigationBarTitleColor, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 22)]
        UITabBar.appearance().tintColor = GlobalDefinitions.navigationBarColor
        UITabBar.appearance().barTintColor = UIColor.black
        
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
        
        if #available(iOS 10.0, *) {
            //UITabBar.appearance().unselectedItemTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        
        // set up your background color view
        let colorView = UIView()
        colorView.backgroundColor = UIColor.color("#24c180")//GlobalDefinitions.tableViewCellSelectedColor
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.needShowInterstitial = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Request Ads
        requestBannerAd()
        requestInterstitial()
        requestRewardedAd()
        
        //Rate
        let times = Tool.recordLaunchTimes()
        if times % 20 == 0 && Tool.isRated() == false {
        
            self.needShowInterstitial = false
            
            let alertView = UIAlertView(title: "感谢您的使用", message: "程序猿很苦逼，请到AppStore给一个5星好评, 支持一下，不甚感激！", delegate: self, cancelButtonTitle: "残忍拒绝", otherButtonTitles: "欣然接受")
            alertView.show()
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    
    func showInterstitial(vc: UIViewController) {
        
        self.showTimes += 1
        
        if self.showTimes % 3 == 0 {
            
            print("###will show interstitial");
        
            if let interstitial = self.interstitial, interstitial.isReady == true {
                
                interstitial.present(fromRootViewController: vc)
            }
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

