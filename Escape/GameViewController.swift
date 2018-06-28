//
//  GameViewController.swift
//  Escape
//
//  Created by Администратор on 16.11.2017.
//  Copyright © 2017 alejandra. All rights reserved.
//
import GoogleMobileAds
import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GADInterstitialDelegate, GKGameCenterControllerDelegate  {
    
    var interstitial: GADInterstitial?
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        registerNotificationToShowAds()
        authenticationPlayer()
    }
    
    // MARK: GoogleAdMob
    func registerNotificationToShowAds() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showAd(_:)),
                                               name: NSNotification.Name(rawValue: "gameStateOff"), object: nil)
    }
    @objc func showAd(_: Notification) {
        interstitial = createAndLoadInterstitial()
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4458876222654719/3355404893")
        
        guard let interstitial = interstitial else { return nil }
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if (ad.isReady) {
            interstitial?.present(fromRootViewController: self)
        }
    }
    
   override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let menu = MenuScene()
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        menu.size = view.bounds.size
        skView.presentScene(menu)
    }
    
    // MARK: Game Center authentication
    func authenticationPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil {
                self.present(view!, animated: true)
            } else {
                print(GKLocalPlayer.localPlayer().isAuthenticated)
                print(error!)
            }
        }
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscape }
    override var prefersStatusBarHidden: Bool { return true }
}


