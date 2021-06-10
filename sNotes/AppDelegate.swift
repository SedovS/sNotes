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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        start(window: window)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    func start(window: UIWindow?) {
        let splash = UIStoryboard.init(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.rootViewController = splash
        
        ProfileDM.setDefaultProfile()
        FolderDM.setDefaultFolder()
        
        let vc = SetPassCodeVC()
        window?.rootViewController = vc
    }
    
}

