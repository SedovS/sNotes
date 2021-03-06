//
//  PasswordDM+CoreDataClass.swift
//  sNotes
//
//  Created by Apple on 31.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import Foundation
import CoreData


public class PasswordDM: NSManagedObject {

}

extension PasswordDM {
    
    static func addPassword(website: String, login: String, descriptionPassword: String?) -> PasswordDM {
        let persistenceManager = PersistenceManager.shared
        let passwordDM = PasswordDM(context: persistenceManager.context)
        
        
        passwordDM.website = website.capitalizingFirstLetter()
        passwordDM.login = ChaChaPolyHelpers.encrypt(string: login)
        passwordDM.descriptionPassword = ChaChaPolyHelpers.encrypt(string: descriptionPassword)
        passwordDM.dateCreate = Date()
        passwordDM.dateLastOpen = Date()

        passwordDM.profile = ProfileDM.getProfile()
        persistenceManager.saveContext()
        return passwordDM
    }
    
    
    static func getPassword() -> [PasswordDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<PasswordDM> = PasswordDM.fetchRequest()
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateLastOpen", ascending: false)]

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    func changeDateLastOpen(date: Date = Date()) {
           self.dateLastOpen = date
           PersistenceManager.shared.saveContext()
       }
}
