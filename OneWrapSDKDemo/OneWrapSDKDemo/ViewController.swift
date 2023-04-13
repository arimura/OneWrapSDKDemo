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
       

        
        setupButtons()
    }
    
    private func setupButtons() {
        let button1 = createButton(title: "Show ad inspector", action: #selector(button1Tapped))
        let button2 = createButton(title: "Show rewarded video", action: #selector(button2Tapped))
        let button3 = createButton(title: "Show banner", action: #selector(button3Tapped))
        
        let stackView = UIStackView(arrangedSubviews: [button1, button2, button3])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func button1Tapped() {
        GADMobileAds.sharedInstance().presentAdInspector(from: self) { error in
            if let error = error {
                // Error will be non-nil if there was an issue and the inspector was not displayed.
                print("Ad Inspector Error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func button2Tapped() {
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
    
    @objc private func button3Tapped() {
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        // Define constraints
        let horizontalConstraint = bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])

        bannerView.adUnitID = "ca-app-pub-2222899768110117/6180027201"
        bannerView.rootViewController = self
        bannerView.delegate = self
        let request = GADRequest()
        let extras = AdMobOpenWrapAdNetworkExtras()
        extras.debug = true // Set to `false` if you want to disable debug mode
        extras.testModeEnabled = true
        request.register(extras)
        bannerView.load(request)
        print("Button 3 tapped")
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
