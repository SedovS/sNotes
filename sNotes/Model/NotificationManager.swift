//
//  NotificationManager.swift
//  sNotes
//
//  Created by Sergey Sedov on 08.06.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func addLocalPushForNotes() {
        remove()
        
        let arrayNotes = NoteDM.getNotesForReminder()
        
        if arrayNotes.count == 0 {
            return
        }
        register()
       
//        //TODO: add on product
        let calendar = Calendar.current
        var i = 0

        arrayNotes.forEach {

            if i >= 64 { return}
            let date = $0.dateReminder
            if date != nil {
                var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
                dateComponents.second = 0
                createLocalPush(dateMatching: dateComponents, alertTitle: "sReminder", alertBody: "\(NSLocalizedString("Note", comment: "")) \($0.title ?? "")", notificationId: "\(date!)")
                i += 1
                dateComponents.hour! -= 1
                createLocalPush(dateMatching: dateComponents, alertTitle: "sReminder", alertBody: "\(NSLocalizedString("1HoursBefore", comment: "")) \($0.title ?? "")", notificationId: "\(date!)")
                i += 1
            }
        }
                
    }
    
    func createLocalPush(dateMatching: DateComponents, alertTitle: String, alertBody: String, notificationId: String) {
        
        let content = UNMutableNotificationContent()
//        content.title = alertTitle
        content.body = alertBody
        content.badge = 1
        content.threadIdentifier = "sNotes" //identifier for grooup push
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: false)
       
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print(#function, "Error add notification", error.localizedDescription)
            } else {
//                print(#function, "add request ok")
            }
            
        }
    
    }
    
    func register() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else {return}
            notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else {return}
            }
        }
    }
    
    
    func remove() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }
}
