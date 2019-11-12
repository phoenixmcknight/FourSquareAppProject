//
//  CollectionVC.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/7/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation
import UIKit

class CollectionVC:UIViewController {
    var savedCollection = [CreateVenueCollection]() {
        didSet {
            venueCollectionView.reloadData()
        }
    }
    
    lazy var venueCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout(placeHolder: "placeholder")
        let vcv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        vcv.register(VenueCollectionViewCell.self, forCellWithReuseIdentifier: RegisterCells.venueCollectionViewCell.rawValue)
        return vcv
    }()
    
    lazy var tipTextField:UITextField = {
        let ttf = UITextField()
        ttf.placeholder = "Enter Tip Here"
        ttf.textAlignment = .center
        ttf.textColor = .black
        ttf.borderStyle = .roundedRect
        return ttf
    }()
    
    lazy var collectionViewNameTextField:UITextField = {
        let ttf = UITextField()
        ttf.placeholder = "Enter a New Collection Title Here"
        ttf.textAlignment = .center
        ttf.textColor = .black
        ttf.borderStyle = .roundedRect
        
        return ttf
    }()
    
    lazy var outletArray = [self.tipTextField,self.collectionViewNameTextField,self.venueCollectionView]
        
    var currentVenue:SavedVenues! {
        didSet {
            print("got data")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(create))
        venueCollectionView.dataSource = self
        venueCollectionView.delegate = self
       gradientColorBackGrounds()
        navigationItem.title = " Venue : \(currentVenue.venueName)"
        alreadySavedOrCreatedAlert(title: "Click on the '+' Symbol to Add a Venue", message: "")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    @objc private func create() {
        guard collectionViewNameTextField.hasText else {
            alreadySavedOrCreatedAlert(title: "⚠️ Warning ⚠️", message: "Invalid Text Field Entry")
            return}
        if savedCollection.contains(where: {$0.name == collectionViewNameTextField.text}) {
        alreadySavedOrCreatedAlert(title:"⚠️ Warning ⚠️" , message: "A Collection With That Name Already Exists")
                  return
        } else {
        let newCollection = CreateVenueCollection(name: collectionViewNameTextField.text!, image: currentVenue.image,savedVenue:[] )
        
        try? VenueCollectionPersistenceManager.manager.save(newCollection: newCollection)
        
        loadData()
        }
    }
    
    private func gradientColorBackGrounds() {
        venueCollectionView.backgroundColor = .clear
        CustomLayer.shared.setGradientBackground(colorTop: .darkGray, colorBottom: .white, newView: view)
       
    }
    private func configureConstraints() {
        for i in outletArray {
            i.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(i)
        }
        NSLayoutConstraint.activate([
            collectionViewNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            collectionViewNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            collectionViewNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
            collectionViewNameTextField.heightAnchor.constraint(equalToConstant: view.frame.height * 0.040),
            
            tipTextField.topAnchor.constraint(equalTo: collectionViewNameTextField.bottomAnchor,constant: 20),
            
            tipTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            
            tipTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            tipTextField.heightAnchor.constraint(equalToConstant: view.frame.height * 0.040),
            
            venueCollectionView.topAnchor.constraint(equalTo: tipTextField.bottomAnchor,constant: 10),
            
            
            venueCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            venueCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            venueCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    private func loadData() {
        guard let collection = try? VenueCollectionPersistenceManager.manager.getSavedCollection()  else {return}
        if collection.count > 0 {
            savedCollection = collection
        }
        
    }
    private func actionSheetWarning(alertTitle:String,saveMessage:String,indexPath:Int)  {
         
         
          let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .actionSheet)
          
          let saveOrDelete = UIAlertAction(title: saveMessage, style: .default) { [weak self] (result) in
            
            let listVC = ListTableViewController()
                  listVC.precedingVC = .collectionVC
                  
            guard let tip = self?.tipTextField.text else {return}
            
           self?.currentVenue.tip = tip
            guard let venue = self?.currentVenue else {return}
            self?.savedCollection[indexPath].addSavedVenue(venue: venue)
            
            guard let collection = self?.savedCollection else {return}
                  
            try? VenueCollectionPersistenceManager.manager.replaceAllFunction(newCollection:collection)
                  
                  listVC.collectionTableViewData = collection[indexPath].savedVenue
          }
          let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alert.addAction(saveOrDelete)
          alert.addAction(cancel)
          present(alert,animated: true)
          }

    private func alreadySavedOrCreatedAlert(title:String,message:String) {

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
    alert.addAction(cancel)
    present(alert,animated: true)
}
}
extension CollectionVC:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let savedCell = savedCollection[indexPath.item]
        let cell = venueCollectionView.dequeueReusableCell(withReuseIdentifier: RegisterCells.venueCollectionViewCell.rawValue, for: indexPath) as! VenueCollectionViewCell
        cell.backgroundColor = .clear
        cell.plusImageView.image = UIImage(named: "plusGreen")
        cell.collectionImage.image = UIImage(data: savedCell.image)
        cell.nameLabel.text = savedCell.name
        
        cell.changeColorOfBorderCellFunction = {
            CustomLayer.shared.createCustomlayer(layer: cell.layer, shadowOpacity: 0.0)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !savedCollection[indexPath.item].savedVenue.contains(where: {$0.venueName == currentVenue.venueName}) else {
             alreadySavedOrCreatedAlert(title: "⚠️ Warning ⚠️", message: "\(currentVenue.venueName) Venue has Already Been Saved To This Collection")
                 return
        }
        actionSheetWarning(alertTitle: "This Will Save: \(currentVenue.venueName) to Your Collection", saveMessage: "Save", indexPath: indexPath.item)
    }
    }

