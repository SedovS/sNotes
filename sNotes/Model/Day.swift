//
//  Day.swift
//  sNotes
//
//  Created by Sergey Sedov on 07.06.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

class Day {
    
    static func convertStringDateFromCardToDate(date: String) -> Date? {
        let calendar = Calendar.current
        
        var dayComponents =  DateComponents()
        dayComponents.year = Int("20\(date[3...4])")
        dayComponents.month = Int(date[0...1])
        dayComponents.day = 01
        dayComponents.hour = 12
        dayComponents.minute = 00

        return calendar.date(from: dayComponents)
    }
}
