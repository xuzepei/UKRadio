//
//  AppDelegate.swift
//  UKRadio
//
//  Created by xuzepei on 16/9/23.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var bannerView: GADBannerView? = nil;


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        GADMobileAds.configure(withApplicationID: "YOUR_ADMOB_APP_ID")
        
        UINavigationBar.appearance().barTintColor = GlobalDefinitions.navigationBarColor
        UINavigationBar.appearance().tintColor = UIColor.color("#fdfefa")//UIColor.white
        
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
        colorView.backgroundColor = UIColor.color("#00901c")//GlobalDefinitions.tableViewCellSelectedColor
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        requestBannerAd()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func requestBannerAd() {
    
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.bannerView = GADBannerView(adSize: kGADAdSizeLeaderboard)
        } else {
            self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        }
        
        self.bannerView?.delegate = self
        self.bannerView?.adUnitID = "ca-app-pub-3940256099942544/2934735716"  //ca-app-pub-3940256099942544/4411468910
        
        self.bannerView?.rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        self.bannerView?.load(GADRequest())
    }
}

extension AppDelegate: GADBannerViewDelegate {

    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(bannerView)
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

}

