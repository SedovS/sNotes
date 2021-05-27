//
//  UITableView.swift
//  sNotes
//
//  Created by Sergey Sedov on 26.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_: T.Type) {
        register(UINib(nibName: T.nibName, bundle: Bundle(for: T.self)), forCellReuseIdentifier: T.reuseIdentifier)

    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath:IndexPath) -> T  {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell: ReusableView {}

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


