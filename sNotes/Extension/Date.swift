//
//  Date.swift
//  sNotes
//
//  Created by Sergey Sedov on 30.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

extension Date {
    func minutesDifference(to secondDate: Date, calendar: Calendar = Calendar.current) -> Int {
        return calendar.dateComponents([.minute], from: self, to: secondDate).minute!
    }
    
    func seconds(to secondDate: Date, calendar: Calendar = Calendar.current) -> Int {
        return calendar.dateComponents([.second], from: self, to: secondDate).second!
    }
}
