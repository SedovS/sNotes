//
//  NoteDM+CoreDataClass.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//
//

import Foundation
import CoreData


public class NoteDM: NSManagedObject {

}

extension NoteDM {
    enum SortByDate: String {
        case dateCreate
        case dateLastOpen
        case dateLastChange
    }
    static func setNote() {
        let persistenceManager = PersistenceManager.shared

        let noteDM = NoteDM(context: persistenceManager.context)

        persistenceManager.saveContext()
    }
    
    static func getNotes(sortDescriptor: SortByDate = .dateLastOpen) -> [NoteDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: true)]
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getAnchoreNotes(sortDescriptor: SortByDate = .dateLastOpen) -> [NoteDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isAnchor = true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: true)]

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getRecentlyNotes(sortDescriptor: SortByDate = .dateLastOpen) -> [NoteDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: true)]

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getNotesForFolder(folder: FolderDM, sortDescriptor: SortByDate = .dateLastOpen) -> [NoteDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY folder = %@", folder)
            fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "\(sortDescriptor)", ascending: true)]
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    func changeFolder(newFolder: FolderDM) {
        self.folder = newFolder
    }
    
    func addToAnchor() {
        self.isAnchor = true
    }

    
}
