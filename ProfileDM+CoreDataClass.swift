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
    
    static func getProfile() -> [ProfileDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<ProfileDM> = ProfileDM.fetchRequest()

        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getPhotoProfile() -> UIImage {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<ProfileDM> = ProfileDM.fetchRequest()

        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return UIImage(named: "defaultPhotoProfile")!
            
        }
        
        guard let data = result[0].photoProfile else {
            return #imageLiteral(resourceName: "IMG_0084.jpg")
        }
        
        return UIImage(data: data) ?? #imageLiteral(resourceName: "IMG_0084.jpg")
    }
}
