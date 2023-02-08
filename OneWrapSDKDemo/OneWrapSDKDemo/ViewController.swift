//
//  ViewController.swift
//  OneWrapSDKDemo
//
//  Created by k-arimura on 2023/02/08.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADFullScreenContentDelegate{
    
    private var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
                           request: request,
                           completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                    return
                }
                rewardedAd = ad
                print("Rewarded ad loaded.")
                rewardedAd?.fullScreenContentDelegate = self
            
                if let ad = rewardedAd {
                    ad.present(fromRootViewController: self) {
                        let reward = ad.adReward
                        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                        // TODO: Reward the user.
                    }
                } else {
                    print("Ad wasn't ready")
                }
            }
        )
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")

    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}
