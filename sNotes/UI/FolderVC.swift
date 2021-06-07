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
    var isCrateFolder = false
    let arrayNameImage = ["icAddNote", "icAddCheckList", "icAddImage", "icAddAudio", "icPin"]
    let arrayNameColor: [UIColor] = [.customGrayForArray(), .customRedForArray(), .customOrangeForArray(), .customPurpleForArray(), .customGreenForArray(), .customBlueForArray()]
    var isChangeColor = false
    
    fileprivate lazy var arrayNotes: [NoteDM] = {
        if self.folder == nil {
            return []
        }
        return NoteDM.getNotesForFolder(folder: self.folder!)
    }()

    
    @IBAction func swipedLeft(_ sender: UIScreenEdgePanGestureRecognizer) {
        let vc = NotesVC()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if folder == nil {
            return
        }
        
        if isCrateFolder {
            nameFolder.becomeFirstResponder()
        }
        
        nameFolder.text = folder?.name
        let colorFolder = folder?.color as? UIColor ?? .customGrayForArray()
        nameFolder.textColor = colorFolder
        imageFolder.image = CustomImage.image(color: colorFolder)
        
        if nameFolder.text == nil ||  nameFolder.text == "" {
            nameFolder.placeholder = "Введите название папки"
        }
        
        folder?.changeDateLastOpen()
        
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
        folder?.changeName(newName: textField.text)
        folder?.changeDateLastChange()
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
        cell.initCell(title: arrayNotes[indexPath.row].tittle ?? "", text: arrayNotes[indexPath.row].text ?? "")
        cell.shadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = NoteVC()
        vc.note = arrayNotes[indexPath.row]
        UIApplication.shared.keyWindow?.rootViewController = vc
        
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

            if arrayNameImage[indexPath.row] == "icPin" && folder?.isAnchor ?? false {
                    cell.icon.image = UIImage(named: "icUnPin")
                    return cell
            }

            cell.icon.image = UIImage(named: arrayNameImage[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath as IndexPath) as ColorCell
        cell.setColor(color: folder?.color as? UIColor ?? .customGrayForArray())
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
                case "icAddNote":
                    let vc = NoteVC()
                    vc.note = NoteDM.addDefaultNote()
                    vc.note?.changeFolder(newFolder: folder!)
                    UIApplication.shared.keyWindow?.rootViewController = vc
                case "icAddCheckList": break
                case "icAddImage": break
                case "icAddAudio": break

                case "icPin":
                    folder?.changeAnchor()
                    folder?.changeDateLastChange()
                default:
                    break
                }
                tableView.isHidden = true
                tableView.reloadData()
            } else {
                isChangeColor = true
                tableView.reloadData()
            }
        }
        
    }
    
}

