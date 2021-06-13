//
//  BackgroundTime.swift
//  sNotes
//
//  Created by Sergey Sedov  on 13.06.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class BackgroundTime {
    var didEnterBackgroundTime: Date
    
    init(time: Date) {
        self.didEnterBackgroundTime = time
    }
    
    func show() {
        let willEnterForeground = Date()
        let dateDiff = didEnterBackgroundTime.seconds(to: willEnterForeground)

        if dateDiff >= 2400 {
            showPasscode()
        }
    }
    
    private func showPasscode() {
        let vc = SetPassCodeVC()

        
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        
        //ПРОВЕРИТЬ НУЖЕН ЛИ while. Сейчас, с одним экрано в него не заходит.
        //Будет ли заходить когда ссылки заработают
//        guard let test = topController.presentedViewController else {
//            print(":((")
//            return
//        }
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        topController.present(vc, animated: false, completion: nil)
    }

}
