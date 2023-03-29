//
//  ViewController.swift
//  OneWrapSDKDemo
//
//  Created by k-arimura on 2023/02/08.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdMobPubMaticAdapter
import OpenWrapSDK

class ViewController: UIViewController, GADFullScreenContentDelegate, GADBannerViewDelegate{
    
    private var rewardedAd: GADRewardedAd?
    private var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OpenWrapSDK.setLogLevel(POBSDKLogLevel.debug)
       
        let button = UIButton(type: .system)
        button.setTitle("Click Me!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
       
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        // Define constraints
        let horizontalConstraint = bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])

        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    @objc func buttonClicked() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status: ATTrackingManager.AuthorizationStatus) in
                // Use trackingAuthorizationStatus to determine the app-tracking permission status.
                // See ATTrackingManager.AuthorizationStatus for status enums.
                
                // Do any additional setup after loading the view.
                let request = GADRequest()
                let extras = AdMobOpenWrapAdNetworkExtras()
                extras.debug = true // Set to `false` if you want to disable debug mode
//                extras.testModeEnabled = true
                request.register(extras)
                
                GADRewardedAd.load(withAdUnitID:"ca-app-pub-2222899768110117/8412446094",
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
        }
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
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
