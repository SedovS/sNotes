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
        
//        let splash = UIStoryboard.init(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
//        window?.rootViewController = splash

        ProfileDM.setDefaultProfile()
        FolderDM.setDefaultFolder() 
        
        let vc = NotesVC()
        window?.rootViewController = vc //splash
        
        return true
    }

}

