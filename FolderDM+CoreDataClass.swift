//
//  FolderDM+CoreDataClass.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import UIKit
import CoreData


public class FolderDM: NSManagedObject {

}

extension FolderDM {
    enum SortByDate: String {
        case dateCreate
        case dateLastOpen
        case dateLastChange
    }
    
    static func setDefaultFolder() {

        let folder = getDefaultFolder()
        if folder == nil {
            let persistenceManager = PersistenceManager.shared
            
            let folderDM = FolderDM(context: persistenceManager.context)
            folderDM.name = "Все заметки"
            folderDM.color = UIColor.customGrayForArray() as NSObject
            folderDM.isDefaultFolder = true
            folderDM.dateCreate = Date()
            folderDM.dateLastChange = Date()
            folderDM.dateLastOpen = Date()
            
            persistenceManager.saveContext()
        }
    }
    
    static func addDefaultFolder() -> FolderDM {
        let persistenceManager = PersistenceManager.shared

        let folderDM = FolderDM(context: persistenceManager.context)
        folderDM.name = ""
        folderDM.color = UIColor.customGrayForArray() as NSObject
        folderDM.isDefaultFolder = false
        folderDM.dateCreate = Date()
        folderDM.dateLastChange = Date()
        folderDM.dateLastOpen = Date()

//        persistenceManager.saveContext()
        
        return folderDM
    }
    
    static func getFolders(sortDescriptor: SortByDate = .dateLastOpen) -> [FolderDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<FolderDM> = FolderDM.fetchRequest()
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: false)]

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getDefaultFolder() -> FolderDM? {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<FolderDM> = FolderDM.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isDefaultFolder = true")
        fetchRequest.sortDescriptors = nil

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return nil
        }
        
        if result.count == 0 {
            return nil
            
        }
        return result[0]
    }
    
    static func getAnchoreFolders(sortDescriptor: SortByDate = .dateLastOpen) -> [FolderDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<FolderDM> = FolderDM.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isAnchor = true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: false)]

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getNameFolders(sortDescriptor: SortByDate = .dateLastOpen) -> [String] {
        
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<FolderDM> = FolderDM.fetchRequest()
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: false)]
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        var nameArray = [String]()
        for el in result {
            nameArray.append(el.name)
        }
        return nameArray
    }
    
    func changeFolderColor(color: UIColor) {
        self.color = color as NSObject
        PersistenceManager.shared.saveContext()
    }
    
    func changeAnchor() {
        self.isAnchor = !self.isAnchor
        PersistenceManager.shared.saveContext()
    }
    
    func changeName(newName: String?) {
        guard let name = newName else {
            return
        }
        self.name = name
    }
    
    func changeDateLastOpen(date: Date = Date()) {
        self.dateLastOpen = date
        PersistenceManager.shared.saveContext()
    }
    
    func changeDateLastChange(date: Date = Date()) {
        self.dateLastChange = date
        PersistenceManager.shared.saveContext()
    }
    
}
