//
//  TabBarView.swift
//  sNotes
//
//  Created by Sergey Sedov on 26.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

protocol TabBarViewDelegate: class {
    func pressAddButton()
}

class TabBarView: UIView, NibLoadableView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var notesButton: UIButton!
    @IBAction func pressNotesButton(_ sender: UIButton) {
        let vc = NotesVC()
        window?.rootViewController = vc
    }
    
    @IBOutlet weak var lockerButton: UIButton!
    @IBAction func pressLockerButton(_ sender: UIButton) {
        let vc = LockerVC()
        window?.rootViewController = vc
    }
    
    @IBOutlet weak var reminderButton: UIButton!
    @IBAction func pressReminderButton(_ sender: Any) {
        let vc = ReminderVC()
        window?.rootViewController = vc
    }
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBAction func pressAddButton(_ sender: UIButton) {
        delegate?.pressAddButton()
    }
    
    
    weak var delegate: TabBarViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        addSubview(contentView)
        self.initAppearance()
    }
        
    
    internal func initAppearance() {
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.shadow(cornerRadius: 25)
        
    }
    
    func notesSelected() {
        notesButton.imageView?.image = UIImage(named: "icNoteSelected")
    }
    
    func lockerSelected() {
        lockerButton.imageView?.image = UIImage(named: "icLockerSelected")
    }
    
    func reminderSelected() {
        reminderButton.imageView?.image = UIImage(named: "icReminderSelected")
    }
}
