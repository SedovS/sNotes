//
//  ColorCell.swift
//  sNotes
//
//  Created by Sergey Sedov on 26.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class ColorCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        colorView.borderWidth = 3
        colorView.borderColor = .white
        colorView.cornerRadius = 29/2
        
        contentView.backgroundColor = .customBlueForTableView()
    }

    func setColor(color: UIColor) {
        colorView.backgroundColor = color
    }
    
}
