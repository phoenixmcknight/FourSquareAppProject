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
        let vcv = UICollectionView()
        let layout = UICollectionViewFlowLayout(placeHolder: "placeholder")
        
        return vcv
    }()
    
    lazy var tipTextField:UITextField = {
        let ttf = UITextField()
        ttf.placeholder = "Enter Tip Here"
        ttf.textAlignment = .center
        ttf.textColor = .black
        
        return ttf
    }()
    
    lazy var collectionViewNameTextField:UITextField = {
          let ttf = UITextField()
          ttf.placeholder = "Enter a New Collection Title Here"
          ttf.textAlignment = .center
          ttf.textColor = .black
          
          return ttf
      }()
    
    lazy var outletArray = [self.tipTextField,self.collectionViewNameTextField,self.venueCollectionView]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    private func configureConstraints() {
        for i in outletArray {
            i.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(i)
        }
        NSLayoutConstraint.activate([
            collectionViewNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: view.frame.height * 0.1),
            collectionViewNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tipTextField.topAnchor.constraint(equalTo: collectionViewNameTextField.bottomAnchor,constant: view.frame.height * 0.1),
            
            tipTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            tipTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            venueCollectionView.topAnchor.constraint(equalTo: tipTextField.bottomAnchor,constant: view.frame.height * 0.1),
            venueCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            venueCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            venueCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    private func loadData() {
        guard try! VenueCollectionPersistenceManager.manager.getSavedCollection().count != 0  else {return}
        savedCollection = try! VenueCollectionPersistenceManager.manager.getSavedCollection()
        }
    }

