//
//  AppDelegate.swift
//  sNotes
//
//  Created by Sergey Sedov on 22.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTime: BackgroundTime?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        start(window: window)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        removeBlurEffect()
        backgroundTime?.show()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        backgroundTime = BackgroundTime(time: Date())
        showBlurEffect()
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return false
    }
        
    func start(window: UIWindow?) {
        let splash = UIStoryboard.init(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.rootViewController = splash
        
        if ProfileDM.getProfile() == nil {
            WorkWithKeychain.clearKeychain()
        }
        
        ProfileDM.setDefaultProfile()
        FolderDM.setDefaultFolder()
        
        let vc = SetPassCodeVC()
        window?.rootViewController = vc
    }
    
    private func showBlurEffect() {
        
        usleep(200000) // 0.2 seconds
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window!.frame
        blurEffectView.tag = 221122
        self.window?.addSubview(blurEffectView)
    }
    
    private func removeBlurEffect() {
        self.window?.viewWithTag(221122)?.removeFromSuperview()
    }
}

