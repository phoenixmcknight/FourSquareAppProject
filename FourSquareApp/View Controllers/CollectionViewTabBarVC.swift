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
        
      lazy var searchBarOne:UISearchBar = {
               let sbo = UISearchBar()
               sbo.tag = 0
               sbo.backgroundColor = .lightGray
               sbo.barTintColor = .clear
               return sbo
           }()
    
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
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            addToViewSubview()
            configureConstraints()
            venueCollectionView.dataSource = self
            venueCollectionView.delegate = self
            searchBarOne.delegate = self
            
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            loadData()
         
        }
    private func addToViewSubview() {
        view.addSubview(searchBarOne)
        view.addSubview(venueCollectionView)
    }
        private func configureConstraints() {
            venueCollectionView.translatesAutoresizingMaskIntoConstraints = false
            searchBarOne.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                searchBarOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
                searchBarOne.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                searchBarOne.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
                
                searchBarOne.heightAnchor.constraint(equalToConstant: view.frame.height * 0.040),
                
                
                venueCollectionView.topAnchor.constraint(equalTo: searchBarOne.bottomAnchor,constant: 10),
                
                
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
           
            let listVC = ListTableViewController()
            listVC.precedingVC = .collectionVC
            listVC.currentIndex = indexPath.item
            listVC.collectionTableViewData = savedCollection[indexPath.item].savedVenue
            navigationController?.pushViewController(listVC, animated: true)
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
       
       




