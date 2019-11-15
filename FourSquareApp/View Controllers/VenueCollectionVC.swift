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
    
    //MARK: Variables
    var savedCollection = [CreateVenueCollection]() {
        didSet {
            venueCollectionView.reloadData()
        }
    }
    
    var currentVenue:SavedVenues!
    //MARK: Views
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
    
    lazy var viewArray = [self.tipTextField,self.venueCollectionView]
    
    
    //MARK:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviewsToView()
        configureTipTextFieldConstraints()
        configureVenueCollectionConstraints()
        setDelegates()
        gradientColorBackGrounds()
        
       
        navigationItem.title = " Venue: \(currentVenue.venueName)"
    }
     
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCollectionViewCount()
    }
    //MARK: Private Functions
    
    private func setDelegates() {
        venueCollectionView.dataSource = self
        venueCollectionView.delegate = self
    }
    
    private func addSubviewsToView() {
        for i in viewArray {
            i.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(i)
        }
    }
    
    private func gradientColorBackGrounds() {
        venueCollectionView.backgroundColor = .clear
        CustomLayer.shared.setGradientBackground(colorTop: .darkGray, colorBottom: .white, newView: view)
        
    }
    
    //MARK: Set Constraints
    private func configureTipTextFieldConstraints() {
        NSLayoutConstraint.activate([
            tipTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            
            tipTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            
            tipTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            tipTextField.heightAnchor.constraint(equalToConstant: view.frame.height * 0.040)
        ])
    }
    private func configureVenueCollectionConstraints() {
        
        NSLayoutConstraint.activate([
            venueCollectionView.topAnchor.constraint(equalTo: tipTextField.bottomAnchor,constant: 10),
            venueCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            venueCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            venueCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    
    //MARK: Load Data
    
    private func loadData() {
        guard let collection = try? VenueCollectionPersistenceManager.manager.getSavedCollection()  else {return}
        if collection.count > 0 {
            savedCollection = collection
        }
        
    }
    
    //MARK:Alerts
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
            
           
            
            self?.alreadySavedOrCreatedAlert(title: "Saved", message: "Saved \(self?.currentVenue.venueName ?? "Current Venue")")
           
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
    private func checkCollectionViewCount() {
           if savedCollection.count == 0 {
               checkCollectionAlert(title: "Create A Collection First", message: "You Must Create A Collection Before You Add Venues")
            
            navigationController?.popViewController(animated: true)
           } else {
                alreadySavedOrCreatedAlert(title: "Click on the '+' Symbol to Add a Venue", message: "")
       }
       }
    private func checkCollectionAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] (action) in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        present(alert,animated: true)
    }
}

//MARK: Extensions
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
            alreadySavedOrCreatedAlert(title: "⚠️ Warning ⚠️", message: "\(currentVenue.venueName) Venue Has Already Been Saved To This Collection")
            return
        }
        actionSheetWarning(alertTitle: "This Will Save: \(currentVenue.venueName) to The Selected Collection", saveMessage: "Save", indexPath: indexPath.item)

    }
}

