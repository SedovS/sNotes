//
//  NibLoadableView.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

protocol NibNameable: class {
    static var nibName: String { get }
}

extension NibNameable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
    
    var nibName : String {
        return String(describing: type(of: self))
    }
}

extension UITableViewCell: NibNameable {}

protocol NibLoadableView: NibNameable {
}

extension NibLoadableView where Self: UIView {
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}
