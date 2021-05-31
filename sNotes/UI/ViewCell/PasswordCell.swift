//
//  PasswordCell.swift
//  sNotes
//
//  Created by Sergey Sedov on 27.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class PasswordCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.text = ""
        descriptions.text = ""
        contentView.backgroundColor = .white
        contentView.shadow()
//        contentView.cornerRadius = 10
        // Initialization code
    }

    func initCell(name: String, description: String) {
        self.name.text = name
        self.descriptions.text = description
    }
    
}
