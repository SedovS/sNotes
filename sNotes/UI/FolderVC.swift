//
//  FolderVC.swift
//  sNotes
//
//  Created by Sergey Sedov on 26.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class FolderVC: UIViewController {

    
    @IBOutlet weak var tabBarView: TabBarView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageFolder: UIImageView!
    @IBOutlet weak var nameFolder: UITextField!
    
    var folder: FolderDM?
    let arrayNameImage = ["icAddCheckList", "icAddImage", "icAddAudio", "icPin"]
    let arrayNameColor: [UIColor] = [.customGrayForArray(), .customRedForArray(), .customOrangeForArray(), .customPurpleForArray(), .customGreenForArray(), .customBlueForArray()]
    var isChangeColor = false
    
    fileprivate lazy var arrayNotes: [NoteDM] = {
        if self.folder == nil {
            return []
        }
        return NoteDM.getNotesForFolder(folder: self.folder!)
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if folder == nil {
//            return
        } else {
//            imageFolder.image = image(color: folder?.color as! UIColor)
        }
        
        nameFolder.text = folder?.name
        nameFolder.textColor = folder?.color as? UIColor
        
        if nameFolder.text == nil ||  nameFolder.text == "" {
            nameFolder.placeholder = "Введите название папки"
            nameFolder.textColor = .customGreenForArray()
            imageFolder.image = CustomImage.image(color: .customGrayForArray())
        }
        
        tabBarView.delegate = self
        nameFolder.delegate = self
        
        //table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.registerCell(IconCell.self)
        tableView.registerCell(ColorCell.self)
        tableView.backgroundColor = .customBlueForTableView()
        tableView.cornerRadius = 21
        tableView.isScrollEnabled = false
        
        //collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "NoteCell", bundle: nil), forCellWithReuseIdentifier: "noteCell")

        setLayoutCollectionView()
    }

    
    override func viewDidLayoutSubviews() {
        tableView.sz_heightConstraint()?.constant = tableView.contentSize.height
        tableView.sz_trailingConstraint()?.constant = self.view.frame.width/8 - 52/2
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tableView.isHidden = true
        isChangeColor = false
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
                heightDimension: .absolute(40)
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

//MARK:- TapBarViewDelegate
extension FolderVC: TabBarViewDelegate {
    func pressAddButton() {
        tableView.isHidden = false
    }
}

//MARK:- UITextFieldDelegate
extension FolderVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.folder?.changeName(newName: textField.text)
        return false
    }

}

//MARK:- UICollectionViewDataSource
extension FolderVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCell
        cell.initCell(title: arrayNotes[indexPath.row].tittle ?? "", text: arrayNotes[indexPath.row].tittle ?? "")
        cell.shadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK:- add logic present note
    }
    
}

//MARK:- UITableViewDataSource
extension FolderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isChangeColor {
            return arrayNameColor.count
        }
        return arrayNameImage.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isChangeColor {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath as IndexPath) as ColorCell
            cell.setColor(color: arrayNameColor[indexPath.row])
            return cell
        }
        
        if indexPath.row < arrayNameImage.count {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath as IndexPath) as IconCell
            cell.icon.image = UIImage(named: arrayNameImage[indexPath.row])
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath as IndexPath) as ColorCell
        cell.setColor(color: folder?.color as? UIColor ?? .green)
        return cell
    }
    
}

//MARK:- UITableViewDelegate
extension FolderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isChangeColor {
            isChangeColor = false
            tableView.isHidden = true
            nameFolder.textColor = arrayNameColor[indexPath.row]
            imageFolder.image = CustomImage.image(color: arrayNameColor[indexPath.row])
            folder?.changeFolderColor(color:arrayNameColor[indexPath.row])
            tableView.reloadData()
            tableView.sz_heightConstraint()?.constant = tableView.contentSize.height
        } else {
            if arrayNameImage.count > indexPath.row {
                
                switch arrayNameImage[indexPath.row] {
                case "icAddCheckList": break
                case "icAddImage": break
                case "icAddAudio": break

                case "icPic":
                    folder?.addToAnchor()
                default:
                    return
                }
                

                let vc = NotesVC()
                UIApplication.shared.keyWindow?.rootViewController = vc
                
            } else {
                isChangeColor = true
                tableView.reloadData()
            }
        }
        
    }
    
}

