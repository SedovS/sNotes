//
//  NotesVC.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class NotesVC: UIViewController {
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var tabBarView: TabBarView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var arrayAnchoreNotes: [NoteDM] = {
        return NoteDM.getAnchoreNotes()
    }()
    
    fileprivate lazy var arrayAnchoreFolders: [FolderDM] = {
        return FolderDM.getAnchoreFolders()
    }()
    
    fileprivate lazy var arrayRecentlyNotes: [NoteDM] = {
        return NoteDM.getRecentlyNotes()
    }()
    
    fileprivate lazy var arrayFolders: [FolderDM] = {
        return FolderDM.getFolders(sortDescriptor: .dateLastChange)
    }()
    
    let arrayNameImage = ["icAddNote", "icAddCheckList", "icAddImage", "icAddAudio", "icAddFolder"]


    override func viewDidLoad() {
        super.viewDidLoad()

        searchView.delegate = self
        tabBarView.delegate = self
        tabBarView.notesSelected()

        //collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "NoteCell", bundle: nil), forCellWithReuseIdentifier: "noteCell")
        collectionView.register(UINib.init(nibName: "FolderCell", bundle: nil), forCellWithReuseIdentifier: "folderCell")
        collectionView.register(UINib.init(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        
        setLayoutCollectionView()
        
        //table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.registerCell(IconCell.self)
        tableView.backgroundColor = .customBlueForTableView()
        tableView.cornerRadius = 21
        
        tableView.isScrollEnabled = false
    }
        
    override func viewDidLayoutSubviews() {
        tableView.sz_heightConstraint()?.constant = tableView.contentSize.height
        tableView.sz_trailingConstraint()?.constant = self.view.frame.width/8 - 52/2
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tableView.isHidden = true
    }
    
    private func setLayoutCollectionView() {
        if #available(iOS 13.0, *) {
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.estimated(44)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 2)
            group.interItemSpacing = .fixed(17)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 0, trailing: 16)
            section.interGroupSpacing = 20
            
            
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(30)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            collectionView.collectionViewLayout = layout
        }
    }

}

//MARK:- SearchViewDelegate
extension NotesVC: SearchViewDelegate {
    func changeSearchtextField(text: String) {
        //Add search
    }
}

//MARK:- TapBarViewDelegate
extension NotesVC: TabBarViewDelegate {
    func pressAddButton() {
        tableView.isHidden = false

    }
}

//MARK:- UICollectionViewDataSource
extension NotesVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0, 1:
            return 0
        case 2:
            return arrayAnchoreNotes.count + arrayAnchoreFolders.count
        case 3:
            return arrayRecentlyNotes.count
        case 4:
            return arrayFolders.count
        default:
            return  0
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var titleText = ""
        switch indexPath.section {
        case 0,1:
            titleText = ""
        case 2:
            titleText = "Закрепленные"
        case 3:
            titleText = "Недавние"
        case 4:
            titleText = "Папки"
        default:
            titleText = ""
        }
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader", for: indexPath) as? SectionHeader {
            sectionHeader.title.text = titleText
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 2:
            var index = indexPath.row
            if index >= arrayAnchoreNotes.count {
                index -=  arrayAnchoreNotes.count
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCell
                cell.initCell(title: arrayFolders[index].name, color: arrayFolders[index].color as? UIColor ?? .customGrayForArray())
                return cell

            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCell
                cell.initCell(title: arrayAnchoreNotes[index].tittle ?? "", text: arrayAnchoreNotes[index].text ?? "")
                cell.shadow()
                return cell
            }
        case 3:
            let index = indexPath.row
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCell
            cell.initCell(title: arrayRecentlyNotes[index].tittle ?? "", text: arrayRecentlyNotes[index].text ?? "")
            cell.shadow()
            return cell
        case 4:
            let index = indexPath.row
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCell
            cell.initCell(title: arrayFolders[index].name, color: arrayFolders[index].color as? UIColor ?? .customGrayForArray())
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch indexPath.section {
        case 0,1:
            return
        case 2: break
            
        case 3:
            let vc = NoteVC()
            vc.note = arrayRecentlyNotes[indexPath.row]
//            let navigationController = UINavigationController(rootViewController: vc)
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true)
            UIApplication.shared.keyWindow?.rootViewController = vc
        case 4:
            let vc = FolderVC()
            vc.folder = arrayFolders[indexPath.row]
            UIApplication.shared.keyWindow?.rootViewController = vc
        default: break
//            titleText = ""
        }
        
        
    }

}

//MARK:- UITableViewDataSource
extension NotesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNameImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath as IndexPath) as IconCell
        cell.icon.image = UIImage(named: arrayNameImage[indexPath.row])

        return cell
    }
    
}

//MARK:- UITableViewDelegate
extension NotesVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch arrayNameImage[indexPath.row] {
        case "icAddNote":
            let vc = NoteVC()
            vc.note = NoteDM.addDefaultNote()
            vc.isCrateNote = true
            UIApplication.shared.keyWindow?.rootViewController = vc

        case "icAddCheckList": break
        case "icAddImage": break
        case "icAddAudio": break

        case "icAddFolder":
            let vc = FolderVC()
            vc.folder = FolderDM.addDefaultFolder()
            vc.isCrateFolder = true
            UIApplication.shared.keyWindow?.rootViewController = vc

        default:
            break
        }
        tableView.isHidden = true
    }
}

