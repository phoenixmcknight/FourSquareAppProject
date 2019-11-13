//
//  VenuePhotoCollectionVc.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/12/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation
import UIKit

protocol VenuePhotoCollectionDelegate:AnyObject {
    func addPhoto(photo:UIImage)
}

class VenuePhotoCollectionVC:UIViewController {

var pictureData = [Hit]() {
       didSet {
       savePhotosFromImageHelper()
       }
   }
   
   //MARK: Variables - Label Outlets
    
    lazy var searchBarOne:UISearchBar = {
                  let sbo = UISearchBar()
                  sbo.tag = 0
        sbo.backgroundColor = .clear
        sbo.placeholder = "Search Images"
                 sbo.searchBarStyle = .minimal
                  return sbo
              }()
   
   lazy var introLabel:UILabel = {
       let label = UILabel(font: UIFont(name: "Courier-Bold", size: 36.0)!)
       return label
   }()
    
    lazy var venueCollectionView:UICollectionView = {
               let layout = UICollectionViewFlowLayout(placeHolder: "placeholder")
        
              let vcv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
              vcv.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: RegisterCells.mapCollectionViewCell.rawValue)
              
              vcv.backgroundColor = .clear
              return vcv
          }()
   
   lazy var placeHolderActivity:UIActivityIndicatorView = {
       
       let image = UIActivityIndicatorView()
    image.hidesWhenStopped = true
    image.style = .large
    
return image
   }()
    
    lazy var outletArray = [self.introLabel,self.searchBarOne,self.venueCollectionView,self.placeHolderActivity]
    
    weak var delegate:VenuePhotoCollectionDelegate?
    
    var imageArray:[UIImage] = [] {
        didSet {
            guard self.imageArray.count == pictureData.count else {return}
            venueCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConstraints()
        setDelegates()
        CustomLayer.shared.setGradientBackground(colorTop: .white, colorBottom: .lightGray, newView: view)
    }
    private func setDelegates() {
        searchBarOne.delegate = self
        venueCollectionView.delegate = self
        venueCollectionView.dataSource = self
    }
    
    private func loadData(searchTerm:String) {
           PictureAPIClient.shared.getPictures(searchTerm:searchTerm) {
               (results) in
               DispatchQueue.main.async {
                   switch results {
                   case .failure(let error):
                       print(error)
                   case .success(let data):
                       self.pictureData = data
                   }
               }
           }
       }
    private func savePhotosFromImageHelper() {
        for picture in pictureData {
            guard let url = picture.largeImageURL else {return}
           
            ImageHelper.shared.getImage(urlStr: url) { [weak self] (result) in
                DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    self?.imageArray.append(image)
                }
            }
            }
        }
    }
    private func configureConstraints() {
              for outlet in outletArray {
                  outlet.translatesAutoresizingMaskIntoConstraints = false
                  view.addSubview(outlet)
              }
              
              NSLayoutConstraint.activate([
                
                  introLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
                  introLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                  introLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
                  
                  introLabel.heightAnchor.constraint(equalToConstant: view.frame.height * 0.060),
                  
                  searchBarOne.topAnchor.constraint(equalTo: introLabel.bottomAnchor,constant: 20),
                  searchBarOne.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                  searchBarOne.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
                  
                  searchBarOne.heightAnchor.constraint(equalToConstant: view.frame.height * 0.040),
                  
                  
                  venueCollectionView.topAnchor.constraint(equalTo: searchBarOne.bottomAnchor,constant: 20),
                  
                  
                  venueCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                  venueCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                  venueCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                  
              ])
          }
    private func genericAlertFunction(title:String,message:String,indexPath:Int) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] (result) in
            guard let image = self?.imageArray[indexPath] else {return}
            self?.delegate?.addPhoto(photo: image)
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        present(alert,animated: true)
    }
}
extension VenuePhotoCollectionVC:UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
               searchBar.showsCancelButton = true
        return true
          
       }
      
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
       }
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text  else {return}
        guard search != "" else {return}
        
        loadData(searchTerm: search)
           
       }
}
extension VenuePhotoCollectionVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = imageArray[indexPath.item]
        let cell = venueCollectionView.dequeueReusableCell(withReuseIdentifier: RegisterCells.mapCollectionViewCell.rawValue, for: indexPath) as! MapCollectionViewCell
        cell.backgroundColor = .clear
        
        cell.fourSquareImageView.image = image
        
        CustomLayer.shared.createCustomlayer(layer: cell.layer, shadowOpacity: 0.5)
        cell.layer.borderWidth = 0.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tag = pictureData[indexPath.item].tags else {return}
        genericAlertFunction(title: "Selected Photo: \(tag)", message: "",indexPath: indexPath.item)
        
        
    }
    
    
}

