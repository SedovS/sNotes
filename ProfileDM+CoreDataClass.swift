//
//  ProfileDM+CoreDataClass.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import UIKit
import CoreData


public class ProfileDM: NSManagedObject {

}

extension ProfileDM {
    
    static func setProfile() {
        let persistenceManager = PersistenceManager.shared

        let profileDM = ProfileDM(context: persistenceManager.context)
        profileDM.userName = "Sergey"
        profileDM.userSurname = "S"
        
//        profileDM.photoProfile =
        
        persistenceManager.saveContext()
    }
    
    static func setDefaultProfile() {
        
        if getProfile() != nil {
            return
        }
        
        let persistenceManager = PersistenceManager.shared
        let profileDM = ProfileDM(context: persistenceManager.context)
        profileDM.userName = "Sergey"
        profileDM.userSurname = "S"
        profileDM.dateCreate = Date()
        profileDM.photoProfile = UIImage(named: "defaultPhotoProfile")!.pngData()
        persistenceManager.saveContext()
    }
    
    static func getProfile() -> ProfileDM? {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<ProfileDM> = ProfileDM.fetchRequest()

        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return nil
        }
        
        if result.count == 0 {
            return nil
        }
        return result[0]
    }
    
    static func getPhotoProfile() -> UIImage {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<ProfileDM> = ProfileDM.fetchRequest()

        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return UIImage(named: "defaultPhotoProfile")!
            
        }
        
        let defaultPhotoProfile = UIImage(named: "defaultPhotoProfile")!
        if result.count == 0 {
            return defaultPhotoProfile
        }
        guard let data = result[0].photoProfile else {
            return defaultPhotoProfile
        }
        
        return UIImage(data: data) ?? defaultPhotoProfile
    }
    
    static func getIsAuthenticationWithBiometrics() -> Bool {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<ProfileDM> = ProfileDM.fetchRequest()

        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return false
        }
        
        if result.count == 0 {
            return false
        }
        return result[0].isAuthenticationWithBiometrics
    }

    
    func changeAuthenticationWithBiometrics() {
        self.isAuthenticationWithBiometrics = !self.isAuthenticationWithBiometrics
        PersistenceManager.shared.saveContext()
    }
    
    func changeTimeBlockSingin(date: Date?) {
        self.timeBlockSingin = date
        PersistenceManager.shared.saveContext()
    }
}
