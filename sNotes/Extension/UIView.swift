//
//  UIView.swift
//  sNotes
//
//  Created by SergeySedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func shadow(cornerRadius: CGFloat = 15) {
        self.cornerRadius = cornerRadius
        
        self.shadowRadius = 2 // устанавливает ширину тени
        self.shadowOpacity = 1 //устанавливает прозрачность тени, где 0 невидимо, а 1 максимально сильно.
        self.shadowOffset = .zero //CGSize(width: 3, height: 0) //Устанавливает, как далеко от вида должна быть тень, чтобы получить эффект 3D-смещения.
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}


//MARK: - shadowRadius
extension UIView {
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}



//MARK: - for Constraints
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    func sz_heightConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if (type(of: constraint) == NSLayoutConstraint.self) && constraint.firstAttribute == .height {
                return constraint
            }
        }
        return nil
    }
    
    func sz_widthConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if (type(of: constraint) == NSLayoutConstraint.self) && constraint.firstAttribute == .width {
                return constraint
            }
        }
        return nil
    }
    
    func sz_leadingConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if constraint.firstItem === self && constraint.firstAttribute == .leading {
                return constraint
            } else if constraint.secondItem === self && constraint.secondAttribute == .leading {
                return constraint
            }
        }
        for constraint in superview!.constraints {
            if constraint.firstItem === self && constraint.firstAttribute == .leading {
                return constraint
            } else if constraint.secondItem === self && constraint.secondAttribute == .leading {
                return constraint
            }
        }
        return nil
    }
    
    func sz_trailingConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if constraint.firstItem === self && constraint.firstAttribute == .trailing {
                return constraint
            } else if constraint.secondItem === self && constraint.secondAttribute == .trailing {
                return constraint
            }
        }
        for constraint in superview!.constraints {
            if constraint.firstItem === self && constraint.firstAttribute == .trailing {
                return constraint
            } else if constraint.secondItem === self && constraint.secondAttribute == .trailing {
                return constraint
            }
        }
        return nil
    }
    
    func sz_topConstraint() -> NSLayoutConstraint? {
        for constraint in superview!.constraints {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == .top {
                return constraint
            } else if constraint.secondItem as! NSObject == self && constraint.secondAttribute == .top {
                return constraint
            }
        }
        return nil
    }
    
    func sz_bottomConstraint() -> NSLayoutConstraint? {
        for constraint in superview!.constraints {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == .bottom {
                return constraint
            } else if constraint.secondItem as! NSObject == self && constraint.secondAttribute == .bottom {
                return constraint
            }
        }
        return nil
    }
    
    func sz_yCenterConstraint() -> NSLayoutConstraint? {
        for constraint in superview!.constraints {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == .centerY {
                return constraint
            } else if constraint.secondItem as! NSObject == self && constraint.secondAttribute == .centerY {
                return constraint
            }
        }
        return nil
    }
    
    func sz_xCenterConstraint() -> NSLayoutConstraint? {
        for constraint in superview!.constraints {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == .centerX {
                return constraint
            } else if constraint.secondItem as! NSObject == self && constraint.secondAttribute == .centerX {
                return constraint
            }
        }
        return nil
    }
}
