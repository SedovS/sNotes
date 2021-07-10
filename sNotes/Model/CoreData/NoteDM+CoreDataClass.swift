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
    
    static func addDefaultNote() -> NoteDM {
        let persistenceManager = PersistenceManager.shared

        let noteDM = NoteDM(context: persistenceManager.context)
        noteDM.dateCreate = Date()
        noteDM.dateLastChange = Date()
        noteDM.dateLastOpen = Date()
        
        noteDM.isAnchor = false
        noteDM.title = ""
        noteDM.text = ChaChaPolyHelpers.encrypt(string: NSLocalizedString("NoteText", comment: ""))
        noteDM.profile = ProfileDM.getProfile()
        noteDM.folder = FolderDM.getDefaultFolder()
        
//        persistenceManager.saveContext()
        return noteDM
    }
    
    static func getNotes(sortDescriptor: SortByDate = .dateLastOpen) -> [NoteDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: false)]
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getAnchoreNotes(sortDescriptor: SortByDate = .dateLastOpen) -> [NoteDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isAnchor = true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: false)]

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getRecentlyNotes(sortDescriptor: SortByDate = .dateLastOpen) -> [NoteDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(sortDescriptor)", ascending: false)]
        fetchRequest.fetchLimit = 4

        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getNotesForFolder(folder: FolderDM, sortDescriptor: SortByDate = .dateLastOpen) -> [NoteDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY folder = %@", folder)
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "\(sortDescriptor)", ascending: false)]
        
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    static func getNotesForReminder() -> [NoteDM] {
        let persistenceManager = PersistenceManager.shared
        let fetchRequest: NSFetchRequest<NoteDM> = NoteDM.fetchRequest()
        fetchRequest.predicate = nil
        fetchRequest.predicate = NSPredicate(format: "dateReminder != nil")

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateReminder", ascending: true)]
//        fetchRequest.gro
        guard let result = try? persistenceManager.context.fetch(fetchRequest) else {
            return []
        }
        
        return result
    }
    
    func changeFolder(newFolder: FolderDM) {
        self.folder = newFolder
        PersistenceManager.shared.saveContext()
    }
    
    func changeAnchor() {
        self.isAnchor = !self.isAnchor
        PersistenceManager.shared.saveContext()
    }

    func changeTitle(newTitle: String) {
        self.title = newTitle
        PersistenceManager.shared.saveContext()
    }
    
    func changeText(newText: String) {
        self.text = ChaChaPolyHelpers.encrypt(string: newText)
        PersistenceManager.shared.saveContext()
    }
    
    func changLDateLastOpen(date: Date = Date()) {
        self.dateLastOpen = date
        PersistenceManager.shared.saveContext()
    }
    
    func changeDeteLastChange(date: Date = Date()) {
        self.dateLastChange = date
        PersistenceManager.shared.saveContext()
    }
    
    func changedateReminder(date: Date?) {
        self.dateReminder = date
        PersistenceManager.shared.saveContext()
    }
    
}
