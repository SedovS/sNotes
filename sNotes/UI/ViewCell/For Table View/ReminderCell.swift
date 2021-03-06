//
//  ReminderCell.swift
//  sNotes
//
//  Created by Apple on 31.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var numberDay: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var reminderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberDay.textColor = .red
        month.textColor = .red
        
        numberDay.text = ""
        month.text = ""
        name.text = ""
        time.text = ""
        self.selectionStyle = .none
        reminderView.shadow()
        reminderView.backgroundColor = .white
        // Initialization code
    }
    
    func initCell(date: Date, name: String) {
        self.name.text = name
        
        let components = Calendar.current.dateComponents([.day, .month, .hour, .minute], from: date)
        
        numberDay.text = String(components.day!)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        month.text = dateFormatter.string(from: date)
        if let hour = components.hour, let minute = components.minute {
            var minutes = "\(minute)"
            if minute < 10 {
                minutes = "0\(minutes)"
            }
            var hours = "\(hour)"
            if hour < 10 {
                hours = "0\(hour)"
            }
            time.text = "\(hours):\(minutes)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
