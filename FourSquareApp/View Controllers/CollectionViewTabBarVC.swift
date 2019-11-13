//
//  CollectionViewTabBarVC.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/9/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import UIKit



class CollectionViewTabBarVC: UIViewController {
        var savedCollection = [CreateVenueCollection]() {
            didSet {
                venueCollectionView.reloadData()
            }
        }
        
    lazy var collectionViewNameTextField:UITextField = {
          let ttf = UITextField()
          ttf.placeholder = "Enter a Title For a New Collection Here"
          ttf.textAlignment = .center
          ttf.textColor = .black
          ttf.borderStyle = .roundedRect
        ttf.backgroundColor = .clear
          return ttf
      }()

        lazy var venueCollectionView:UICollectionView = {
             let layout = UICollectionViewFlowLayout(placeHolder: "placeholder")
            let vcv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
            vcv.register(VenueCollectionViewCell.self, forCellWithReuseIdentifier: RegisterCells.venueCollectionViewCell.rawValue)
            
            vcv.backgroundColor = .clear
            return vcv
        }()
        
      lazy var searchBarOne:UISearchBar = {
               let sbo = UISearchBar()
               sbo.tag = 0
              sbo.backgroundColor = .clear
        sbo.placeholder = "Search"
              sbo.searchBarStyle = .minimal
               return sbo
           }()
    
    lazy var outletArray = [self.collectionViewNameTextField,self.searchBarOne,self.venueCollectionView]
    
    var searchString:String? = nil {
        didSet {
            venueCollectionView.reloadData()
        }
    }
    
    var searchResults:[CreateVenueCollection] {
        guard let search = searchString else {return savedCollection}
        guard !search.isEmpty else {
            return savedCollection
        }
        return savedCollection.filter({$0.name.lowercased().contains(search.lowercased())})
    }
    
    var collectionViewImage = UIImage(systemName: "photo")
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            configureConstraints()
            venueCollectionView.dataSource = self
            venueCollectionView.delegate = self
            searchBarOne.delegate = self
            gradientColorBackGrounds()
            navigationItem.title = "Venue Collection"
             navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(create))
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            loadData()
         
        }
    @objc private func create() {
        guard collectionViewNameTextField.hasText else {
            alreadySavedOrCreatedAlert(title: "⚠️ Warning ⚠️", message: "Invalid Text Field Entry")
            return}
        guard !savedCollection.contains(where: {$0.name == collectionViewNameTextField.text})
            else {
            alreadySavedOrCreatedAlert(title:"⚠️ Warning ⚠️" , message: "A Collection With That Name Already Exists")
                return
                
        }
        
            presentVenuePhotoVC()
        

        }
    
    private func presentVenuePhotoVC() {
        let alert = UIAlertController(title: "Picture Type", message: "", preferredStyle: .actionSheet)
        let customPicture = UIAlertAction(title: "Use Custom Picture", style: .default) { [weak self] (result) in
            
            let pictureVC = VenuePhotoCollectionVC()
            pictureVC.delegate = self
            self?.dismiss(animated: true) {
                self?.present(pictureVC,animated: true)
            }
           
        }
        let useDefaultImage = UIAlertAction(title: "Use Default Image", style: .cancel) { [weak self] (result) in
            let newCollection = CreateVenueCollection(name: (self?.collectionViewNameTextField.text!)!, image: (self?.collectionViewImage?.pngData())!,savedVenue:[] )
              
              try? VenueCollectionPersistenceManager.manager.save(newCollection: newCollection)
            self?.collectionViewImage = UIImage(systemName: "photo")
            self?.savedCollection.append(newCollection)
        //    venueCollectionView.reloadData()
        }
//        let useDefaultImage = UIAlertAction(title: "Use Default Image", style: .cancel, handler: nil)
        alert.addAction(customPicture)
        alert.addAction(useDefaultImage)
        present(alert,animated: true)
        
    }
    
        private func configureConstraints() {
            for outlet in outletArray {
                outlet.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(outlet)
            }
            
            NSLayoutConstraint.activate([
                
                collectionViewNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
                collectionViewNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                collectionViewNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
                
                collectionViewNameTextField.heightAnchor.constraint(equalToConstant: view.frame.height * 0.040),
                
                searchBarOne.topAnchor.constraint(equalTo: collectionViewNameTextField.bottomAnchor,constant: 20),
                searchBarOne.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                searchBarOne.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
                
                searchBarOne.heightAnchor.constraint(equalToConstant: view.frame.height * 0.040),
                
                
                venueCollectionView.topAnchor.constraint(equalTo: searchBarOne.bottomAnchor,constant: 20),
                
                
                venueCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                venueCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                venueCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                
            ])
        }
        private func loadData() {
            guard let collection = try? VenueCollectionPersistenceManager.manager.getSavedCollection()  else {return}
            if collection.count > 0 {
            savedCollection = collection
            print("sending data")
            }
        
        }
    private func gradientColorBackGrounds() {
        CustomLayer.shared.setGradientBackground(colorTop: .white, colorBottom: .darkGray, newView: view)
    }
    
      private func alreadySavedOrCreatedAlert(title:String,message:String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    private func deleteOrLookAtCollectionAlert(indexPath:Int) {
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self](delete) in
            self?.savedCollection.remove(at: indexPath)
            guard let collection = self?.savedCollection else {return}
            try? VenueCollectionPersistenceManager.manager.replaceAllFunction(newCollection: collection)
        }
        let viewTableview = UIAlertAction(title: "Look Inside \(savedCollection[indexPath].name)", style: .default) { [weak self](result) in
             let listVC = ListTableViewController()
                       listVC.precedingVC = .collectionVC
                       listVC.currentIndex = indexPath
            listVC.collectionTableViewData = self?.savedCollection[indexPath].savedVenue
            guard let title = self?.savedCollection[indexPath].name else {return}
            
            listVC.navigationItem.title = title
            self?.navigationController?.pushViewController(listVC, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(delete)
        alert.addAction(viewTableview)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    }

    extension CollectionViewTabBarVC:UICollectionViewDataSource,UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return searchResults.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let savedCell = searchResults[indexPath.item]
            let cell = venueCollectionView.dequeueReusableCell(withReuseIdentifier: RegisterCells.venueCollectionViewCell.rawValue, for: indexPath) as! VenueCollectionViewCell
            
            cell.collectionImage.image = UIImage(data: savedCell.image)
            cell.nameLabel.text = savedCell.name
            
            cell.changeColorOfBorderCellFunction = {
                CustomLayer.shared.createCustomlayer(layer: cell.layer, shadowOpacity: 0.0)
            }
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           

            deleteOrLookAtCollectionAlert(indexPath: indexPath.item)
        }
        
    }
extension CollectionViewTabBarVC:UISearchBarDelegate {
      func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
          searchBarOne.showsCancelButton = true
        
           return true
       }
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
                    searchBarOne.showsCancelButton = false
                     searchBarOne.resignFirstResponder()
               
       }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
    }
           }
       
       

extension CollectionViewTabBarVC:VenuePhotoCollectionDelegate {
    func addPhoto(photo: UIImage) {
    collectionViewImage = photo
        let newCollection = CreateVenueCollection(name: collectionViewNameTextField.text!, image: (collectionViewImage?.pngData())!,savedVenue:[] )
          
          try? VenueCollectionPersistenceManager.manager.save(newCollection: newCollection)
          collectionViewImage = UIImage(systemName: "photo")
        savedCollection.append(newCollection)
        //venueCollectionView.reloadData()
    }
    
    
}


