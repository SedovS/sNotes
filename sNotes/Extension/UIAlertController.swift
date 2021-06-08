//
//  UIAlertController.swift
//  sNotes
//
//  Created by Sergey Sedov on 30.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func createOkAlert(WithTitle title: String?, message: String?, okTitle: String = "Ок") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        alertController.tintColor()
        return alertController
    }
    
    static func createLogOutAlert(WithTitle title: String?, message: String?, okTitle: String = "Выход", cancelTitle: String = "Отмена" , okDidTap: @escaping () -> ()) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: okTitle, style: .default) { (result : UIAlertAction) -> Void in
            okDidTap()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.tintColor()
        return alertController
    }
    
    func tintColor(color: UIColor = .customBlueForPassCode()) {
        self.view.tintColor = color
    }
    
    static func createPhotoForProfileAlert(WithTitle title: String?, message: String?, cameraTitle: String = "Открыть камеру", libraryTitle: String = "Открыть библиотеку", cancelTitle: String = "Отмена", completion: @escaping(_ isLibrary: Bool) -> ()) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancelTitle, style: .default, handler: nil)
        
        let library = UIAlertAction(title: libraryTitle, style: .default) { (result : UIAlertAction) -> Void in
            completion(true)
        }
        let camera = UIAlertAction(title: cameraTitle, style: .default) { (result : UIAlertAction) -> Void in
            completion(false)
        }
        
        alertController.addAction(library)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        alertController.tintColor(color: .customBlueForProfile())
        
        return alertController
    }
}
