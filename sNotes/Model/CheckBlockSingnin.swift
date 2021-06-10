//
//  CheckBlockSingnin.swift
//  sNotes
//
//  Created by Sergey Sedov on 30.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
import UIKit

class CheckBlockSingnin {
    private var count = 1
    private var timeBlock: Date?
    private let minutesBlock = 5
    private let countBlock = 5
    private let profile = ProfileDM.getProfile()

    init() {
        timeBlock = profile?.timeBlockSingin
    }
    
    func changeCount() {
        self.count += 1
    }
    
    func isBlock() -> Bool {
        guard let blockTime = timeBlock else {
            return false
        }
        
        let timeNow = Date()
        
        if blockTime.minutesDifference(to: timeNow) < minutesBlock {
            return true
        } else {
            clearBlockDate()
            return false
        }
    }
    
    func isBlock(view: UIViewController) -> Bool {
        guard let blockTime = timeBlock else {
            return false
        }
        
        let timeNow = Date()
        
        if blockTime.minutesDifference(to: timeNow) < minutesBlock {
            showAlertBlockTime(view: view)
            return true
        } else {
            clearBlockDate()
            return false
        }
    }
    
    func isBlockCount(view: UIViewController) -> Bool {
        if isAttempsMore() {
            timeBlock = Date()
            saveBlockDate(date: timeBlock!)
            showAlertBlockCount(view: view)
            return true
        }
        return false
    }
    
    func resetCountOfAttemptsSignin() {
        count = 1
    }
    
    private func showAlertBlockCount(view: UIViewController) {
        let alert = UIAlertController.createOkAlert(WithTitle: NSLocalizedString("LoginAttemptsBlocked", comment: ""), message: localizatedBlocked(count: UInt(countBlock), minutes: UInt(minutesBlock)))
        view.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertBlockTime(view: UIViewController)  {
        let timeNow = Date()
        
        let minutesPassed = timeBlock!.minutesDifference(to: timeNow)
        let minutesLeft = minutesBlock - minutesPassed
        let alert = UIAlertController.createOkAlert(WithTitle: NSLocalizedString("LoginAttemptsBlocked", comment: ""), message: localizatedTryThrought(minutes: UInt(minutesLeft)))
        view.present(alert, animated: true, completion: nil)
    }
    
    private func isAttempsMore() -> Bool {
        if count > countBlock {
            return true
        } else {
            return false
        }
    }
    
    private func saveBlockDate(date: Date) {
        profile?.changeTimeBlockSingin(date: date)
    }
    
    private func clearBlockDate() {
        profile?.changeTimeBlockSingin(date: nil)
    }
    
    private func localizatedBlocked(count: UInt, minutes: UInt) -> String {
        let loginAttempts : String = NSLocalizedString("More login attempts",
                                                      comment: "")
        let resultLoginAttempts : String = String.localizedStringWithFormat(loginAttempts, count)
        
        let block: String = NSLocalizedString("Entrance blocked on",
                                                      comment: "")
        let resultBlock: String = String.localizedStringWithFormat(block, minutes)
        return resultLoginAttempts + " " + resultBlock;
    }
    
    private func localizatedTryThrought(minutes: UInt) -> String {
        let formatString: String = NSLocalizedString("Try through",
                                                      comment: "")
        let resultString: String = String.localizedStringWithFormat(formatString, minutes)
        return resultString;
    }
    
    
}
