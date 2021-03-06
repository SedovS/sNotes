//
//  LockerVC.swift
//  sNotes
//
//  Created by Sergey Sedov on 27.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import CoreData

class LockerVC: UIViewController {

    
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabBarView: TabBarView!
    
    
    let arrayNameImage = ["icAddCard", "icAddPassword"]
    fileprivate lazy var arrayCards: [CardDM] = {
        return CardDM.getCards()
    }()
    
    fileprivate lazy var arrayPassword: [PasswordDM] = {
        return PasswordDM.getPassword()
    }()
    
    fileprivate lazy var frc: NSFetchedResultsController<PasswordDM> = {
        let context = PersistenceManager.shared.context
        let fetchRequest : NSFetchRequest<PasswordDM> = PasswordDM.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateLastOpen", ascending: false)]
        let tmpFrc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        tmpFrc.delegate = self
        try? tmpFrc.performFetch()
        return tmpFrc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchView.textField.placeholder = NSLocalizedString("FindAmongData", comment: "")
        searchView.delegate = self
        
        tabBarView.delegate = self
        tabBarView.lockerSelected()
                
        //table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.registerCell(IconCell.self)
        tableView.backgroundColor = .customBlueForTableView()
        tableView.cornerRadius = 21
        tableView.isScrollEnabled = false

        
        //collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        collectionView.register(UINib.init(nibName: "PasswordCell", bundle: nil), forCellWithReuseIdentifier: "passwordCell")
        collectionView.register(UINib.init(nibName: "AddCard", bundle: nil), forCellWithReuseIdentifier: "addCard")
        
        collectionView.register(UINib.init(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        
        
        setLayoutCollectionView()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        tableView.sz_heightConstraint()?.constant = tableView.contentSize.height
        tableView.sz_trailingConstraint()?.constant = self.view.frame.width/8 - 52/2
        tableView.cornerRadius = tableView.frame.width / 2
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
extension LockerVC: SearchViewDelegate {
    func pressProfileButton() {
        show(ProfileVC(), sender: nil)
    }
    
    func changeSearchtextField(text: String) {
        //Add search
    }
    
}

//MARK:- TapBarViewDelegate
extension LockerVC: TabBarViewDelegate {
    func pressAddButton() {
        tableView.isHidden = false
    }
}


//MARK:- UICollectionViewDataSource
extension LockerVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0,1:
            return 0
        case 2:
            return arrayCards.count == 0 ? 1 : arrayCards.count
        case 3:
            return frc.fetchedObjects?.count == 0 ? 1 : frc.fetchedObjects!.count//arrayPassword.count == 0 ? 1 : arrayPassword.count
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
            titleText = NSLocalizedString("Cards", comment: "")
        case 3:
            titleText = NSLocalizedString("Passwords", comment: "")
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
            if arrayCards.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCard", for: indexPath) as! AddCard
                cell.initCellCard()
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCell
            cell.initCell(card: arrayCards[indexPath.row])
            return cell
        case 3:
            if arrayPassword.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCard", for: indexPath) as! AddCard
                cell.initCellPassword()
                return cell
            }
            let object = frc.object(at: IndexPath(item: indexPath.row, section: 0))
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "passwordCell", for: indexPath) as! PasswordCell
            let password = object
            cell.initCell(name: password.website, description: password.login)
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch indexPath.section {
        case 0,1:
            return
        case 2:
            let vc = CardVC()
            if arrayCards.count == 0 {
                vc.isAddCard = true
            } else {
                vc.card = arrayCards[indexPath.row]
            }
            show(vc, sender: nil)
        case 3:
            let vc = PasswordVC()
            if arrayPassword.count == 0 {
                vc.isAddPassword = true
            } else {
                vc.passwordDM = frc.object(at: IndexPath(item: indexPath.row, section: 0))

            }
            show(vc, sender: nil)

        default: break

        }
        
    }

}


//MARK:- UITableViewDataSource
extension LockerVC: UITableViewDataSource {
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
extension LockerVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch arrayNameImage[indexPath.row] {
        case "icAddCard":
            let vc = CardVC()
            vc.isAddCard = true
            show(vc, sender: nil)

        case "icAddPassword":
            let vc = PasswordVC()
            vc.isAddPassword = true
            show(vc, sender: nil)
        default:
            break
        }
        tableView.isHidden = true
    }
}

extension LockerVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}

