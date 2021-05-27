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
        if folder.count == 0 {
            let persistenceManager = PersistenceManager.shared
            
            let folderDM = FolderDM(context: persistenceManager.context)
            folderDM.name = "Все заметки"
            folderDM.color = UIColor.gray as NSObject
            folderDM.isDefaultFolder = true
            
            persistenceManager.saveContext()
        }
    }
    
    static func setFolder() {
        let persistenceManager = PersistenceManager.shared

        let folderDM = FolderDM(context: persistenceManager.context)
        folderDM.name = "Test Folder"
        
        persistenceManager.saveContext()
    }
    
    static func getFolders(sortDescriptor: SortByDate = .dateLastOpen) -> [FolderDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<FolderDM> = FolderDM.fetchRequest()
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: true)]

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getDefaultFolder() -> [FolderDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<FolderDM> = FolderDM.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isDefaultFolder = true")
        fetchRequest.sortDescriptors = nil

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getAnchoreFolders(sortDescriptor: SortByDate = .dateLastOpen) -> [FolderDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<FolderDM> = FolderDM.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isAnchor = true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: true)]

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getNameFolders(sortDescriptor: SortByDate = .dateLastOpen) -> [String] {
        
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<FolderDM> = FolderDM.fetchRequest()
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: true)]
        
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
        self.color = color
    }
    
    func addToAnchor() {
        self.isAnchor = true
    }
    
    func changeName(newName: String?) {
        guard let name = newName else {
            return
        }
        self.name = name
    }
}
