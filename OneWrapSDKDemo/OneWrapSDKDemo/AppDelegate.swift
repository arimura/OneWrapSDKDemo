//
//  AppDelegate.swift
//  OneWrapSDKDemo
//
//  Created by k-arimura on 2023/02/08.
//

import UIKit
import GoogleMobileAds
import OpenWrapSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let appInfo = POBApplicationInfo()
        appInfo.storeURL = URL(string: "https://apps.apple.com/jp/app/%E7%AF%80%E7%B4%84-%E9%80%9A%E4%BF%A1%E9%87%8F%E3%83%81%E3%82%A7%E3%83%83%E3%82%AB%E3%83%BC-%E3%81%B4%E3%82%88%E3%83%91%E3%82%B1/id956084814")!
        OpenWrapSDK.setApplicationInfo(appInfo)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

