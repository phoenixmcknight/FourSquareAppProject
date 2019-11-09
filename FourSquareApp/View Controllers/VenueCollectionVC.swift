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
            print("receivedData")
            print(self.savedCollection.count)
        }
    }
    
    lazy var venueCollectionView:UICollectionView = {
         let layout = UICollectionViewFlowLayout(placeHolder: "placeholder")
        let vcv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        vcv.register(VenueCollectionViewCell.self, forCellWithReuseIdentifier: RegisterCells.venueCollectionViewCell.rawValue)
        
        vcv.backgroundColor = .white
        return vcv
    }()
    
    lazy var tipTextField:UITextField = {
        let ttf = UITextField()
        ttf.placeholder = "Enter Tip Here"
        ttf.textAlignment = .center
        ttf.textColor = .black
        ttf.backgroundColor = .blue
        ttf.borderStyle = .roundedRect
        return ttf
    }()
    
    lazy var collectionViewNameTextField:UITextField = {
          let ttf = UITextField()
          ttf.placeholder = "Enter a New Collection Title Here"
          ttf.textAlignment = .center
          ttf.textColor = .black
        ttf.backgroundColor = .red
        ttf.borderStyle = .roundedRect

          return ttf
      }()
    
    lazy var outletArray = [self.tipTextField,self.collectionViewNameTextField,self.venueCollectionView]
    
    var currentVenue:SavedVenues! {
        didSet {
            print("got data")
        }
    }
   // var currentVenue:Venue!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureConstraints()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(create))
        venueCollectionView.dataSource = self
        venueCollectionView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
     
    }
    @objc private func create() {
       let newCollection = CreateVenueCollection(name: collectionViewNameTextField.text!, image: currentVenue.image,savedVenue:[] )
     //   let newCollection = CreateVenueCollection(name: collectionViewNameTextField.text!, image:  currentVenue.picture!,savedVenue:[] )
        
        try? VenueCollectionPersistenceManager.manager.save(newCollection: newCollection)
        
        loadData()
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
            
            
            venueCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            venueCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            venueCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10)
            
        ])
    }
    private func loadData() {
        guard let collection = try? VenueCollectionPersistenceManager.manager.getSavedCollection()  else {return}
        if collection.count > 0 {
        savedCollection = collection
        print("sending data")
        }
    
    }
}

extension CollectionVC:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let savedCell = savedCollection[indexPath.item]
        let cell = venueCollectionView.dequeueReusableCell(withReuseIdentifier: RegisterCells.venueCollectionViewCell.rawValue, for: indexPath) as! VenueCollectionViewCell
        
        cell.collectionImage.image = UIImage(data: savedCell.image)
        cell.nameLabel.text = savedCell.name
        
        cell.changeColorOfBorderCellFunction = {
            CustomLayer.shared.createCustomlayer(layer: cell.layer, shadowOpacity: 0.0)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let listVC = ListTableViewController()
        listVC.present = .collectionVC
        guard !tipTextField.text!.isEmpty || tipTextField.text != nil else {return}
        currentVenue.tip = tipTextField.text!
        savedCollection[indexPath.item].addSavedVenue(venue: currentVenue)
      print(savedCollection)
        
        try? VenueCollectionPersistenceManager.manager.replaceAllFunction(newCollection:savedCollection)
        
        listVC.collectionTableViewData = savedCollection[indexPath.item].savedVenue
        navigationController?.pushViewController(listVC, animated: true)
    }
    
}
