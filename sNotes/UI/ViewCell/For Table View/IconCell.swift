//
//  IconCell.swift
//  sNotes
//
//  Created by Sergey Sedov on 26.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class IconCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        icon.backgroundColor = .customBlueForTableView()
        contentView.backgroundColor = .customBlueForTableView()
    }
    
}
