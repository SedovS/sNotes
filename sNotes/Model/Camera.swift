//
//  Camera.swift
//  sNotes
//
//  Created by Sergey Sedov on 08.06.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import MobileCoreServices

class Camera {
    
    var delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate
    
    init(delegate_: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        delegate = delegate_
    }
    
    func presentPhotoLibrary(_ target: UIViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            
            return
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        imagePicker.navigationBar.isTranslucent = false
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            imagePicker.sourceType = .photoLibrary
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                
                if (availableTypes as NSArray).contains(type) {
                    
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            
            imagePicker.sourceType = .savedPhotosAlbum
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                
                if (availableTypes as NSArray).contains(type) {
                    
                    imagePicker.mediaTypes = [type]
                }
                
            }
        } else {
            
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func presentPhotoCamera(_ target: UIViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            return
        }
        
        let type1 = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                
                if (availableTypes as NSArray).contains(type1) {
                    
                    imagePicker.mediaTypes = [type1]
                    imagePicker.sourceType = UIImagePickerController.SourceType.camera
                }
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                
                imagePicker.cameraDevice = UIImagePickerController.CameraDevice.rear
                
            } else if UIImagePickerController.isCameraDeviceAvailable(.front) {
                
                imagePicker.cameraDevice = UIImagePickerController.CameraDevice.front
            }
            
        } else {
            
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.showsCameraControls = true
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
    }
}

