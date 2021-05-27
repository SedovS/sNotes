//
//  FolderCell.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class FolderCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initCell(title: String, color: UIColor) {
        var image = UIImage()
        switch color {
        case .gray:
            image = #imageLiteral(resourceName: "grayFolder")
        case .green:
            image = #imageLiteral(resourceName: "greenFolder")
        case .blue:
             image = #imageLiteral(resourceName: "blueFolder")
        case .orange:
             image = #imageLiteral(resourceName: "orangeFolder")
        case .purple:
             image = #imageLiteral(resourceName: "purpleFolder")
        case .red:
             image = #imageLiteral(resourceName: "redFolder")
        default:
            image = #imageLiteral(resourceName: "grayFolder")
        }
        
        self.title.text = title
        self.image.image = image
    }
}
