//
//  ProfileVC.swift
//  sNotes
//
//  Created by Apple on 08.06.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import Foundation

class ProfileVC: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var photoProfile: UIImageView!
    @IBOutlet weak var nameProfileTextField: UITextField!
    
    @IBOutlet weak var biometricsLabel: UILabel!
    @IBOutlet weak var biometricsSwitch: UISwitch!

    @IBOutlet weak var logOutButton: UIButton!
    
    var profile: ProfileDM = {
        return ProfileDM.getProfile()!
    }()
    
    var camera: Camera?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //nameProfileTextField
        nameProfileTextField.placeholder = NSLocalizedString("NameSurname", comment: "")
        nameProfileTextField.text = returnNameProfile()
        nameProfileTextField.delegate = self
        if nameProfileTextField.text != nil {
            nameProfileTextField.borderStyle = .none
        }
        
        //photoProfile
        photoProfile.cornerRadius = photoProfile.frame.width / 2
        photoProfile.image = (profile.photoProfile != nil) ? UIImage(data: profile.photoProfile!) : UIImage(named: "defaultPhotoProfile")!
        photoProfile.isUserInteractionEnabled = true

        let tapPhotoProfile = UITapGestureRecognizer(target: self, action: #selector(self.handlerTapPhotoProfile(_:)))
        photoProfile.addGestureRecognizer(tapPhotoProfile)
        
        //logOutButton
        logOutButton.setTitle(NSLocalizedString("LogOut", comment: ""), for: .normal)
        logOutButton.titleLabel?.textColor = .customBlueForProfile()
        logOutButton.backgroundColor = .customGrayForProfile()
        logOutButton.shadow()

        //biometrics
        biometricsLabel.text = NSLocalizedString("UseBiometricsToSignIn", comment: "")
        setColorSwitch(switch: biometricsSwitch, isOn: profile.isAuthenticationWithBiometrics)
        
        camera = Camera(delegate_: self)
    }
    
    private func setColorSwitch(switch uiSwitch: UISwitch, isOn: Bool) {
        uiSwitch.isOn = isOn
        uiSwitch.onTintColor = isOn ? .customBlueForProfile() : .customGrayForProfile()
        uiSwitch.thumbTintColor = isOn ? .customGrayForProfile() : .customBlueForProfile()
    }
    
    private func returnNameProfile() -> String? {
        if profile.userName == nil && profile.userSurname == nil {
            return nil
        }
        if profile.userName != nil && profile.userSurname != nil {
            return profile.userName! + " " + profile.userSurname!
        }
        return profile.userName != nil ? profile.userName : profile.userSurname
    }
    
    @IBAction func pressBiometricsSwitch(_ sender: UISwitch) {
        setColorSwitch(switch: sender, isOn: sender.isOn)
        profile.changeAuthenticationWithBiometrics()
    }
    
    @IBAction func pressLogOutButton(_ sender: UIButton) {
        let alert = UIAlertController.createLogOutAlert(WithTitle: NSLocalizedString("AreYouSureYouWantToLogOut", comment: ""), message: NSLocalizedString("AllYourDataWillHaveToBeDeleted", comment: "")) {
            PersistenceManager.shared.deleteAll()
            WorkWithKeychain.clearKeychain()
            AppDelegate().start(window: UIApplication.shared.windows.filter {$0.isKeyWindow}.first)
        }
        show(alert, sender: nil)
    }
    
    @objc func handlerTapPhotoProfile(_ sender: UITapGestureRecognizer? = nil) {

        let alert = UIAlertController.createPhotoForProfileAlert(WithTitle: nil, message: nil) { (isLibrary) in
            if isLibrary {
                self.camera?.presentPhotoLibrary(self, canEdit: true)
            } else {
                self.camera?.presentPhotoCamera(self, canEdit: true)
            }
        }
        
        show(alert, sender: nil)
    }
    
}

extension ProfileVC: UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil {
            let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            self.photoProfile.image = image

            profile.changePhotoProfile(image: image)
            
        } else{

        }
    }

}

extension ProfileVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let string = textField.text?.uppercased() else {
            return
        }
        
        let arrayString = string.components(separatedBy: " ")
        let name = arrayString[0]
        var surname: String? //= arrayString.count > 1 ? arrayString[1] : nil

        if string.count > name.count + 1 {
            surname = string
            surname!.removeFirst(name.count)
            surname = surname!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        profile.changeNameProfile(name: name, surname: surname)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.text = textField.text?.removingLeadingSpaces()
        textField.text = textField.text?.uppercased()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
