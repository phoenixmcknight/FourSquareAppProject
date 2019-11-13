//
//  DetailVenueVC.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/7/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

protocol DetailVenueDeleteDelegate:AnyObject {
    func deleteVenue(venueID:String)
}
class DetailVenueVC:UIViewController {
    lazy var resturantLabel:UILabel = {
        
        let rl = UILabel(font: UIFont(name: "Courier-Bold", size: 36.0)!)
        return rl
    }()
    
    lazy var typeOfVenueLabel:UILabel = {
           
           let rl = UILabel(font: UIFont(name: "Courier-Bold", size: 24.0)!)
           return rl
       }()
    
    lazy var tipLabel:UILabel = {
           
           let rl = UILabel(font: UIFont(name: "Courier-Bold", size: 24.0)!)
           return rl
       }()
    lazy var directionsTapGesture: UITapGestureRecognizer = {
        let dtg = UITapGestureRecognizer()
        dtg.addTarget(self, action: #selector(getDirections))
        return dtg
    }()
    
    lazy var addressTextView:UITextView = {
        let atv = UITextView()
        atv.adjustsFontForContentSizeCategory = true
        atv.textAlignment = .center
        atv.textColor = .black
        atv.backgroundColor = .clear
        atv.font = UIFont(name: "Courier-Bold", size: 24.0)
        atv.isEditable = false
        atv.isSelectable = false
        atv.addGestureRecognizer(self.directionsTapGesture)
        atv.isUserInteractionEnabled = true
        return atv
    }()
    
    lazy var venueImageView:UIImageView = {
        let vIv = UIImageView()
        vIv.contentMode = .scaleAspectFit
        vIv.tintColor = .black
        return vIv
    }()
    var precedingVC:PrecedingVC!
   var currentVenue:SavedVenues!
    weak var delegate:DetailVenueDeleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    configureConstraints()
        createBarButton()
        CustomLayer.shared.setGradientBackground(colorTop: .lightGray, colorBottom: .white, newView: view)
       genericAlert(title: "Click On the Address For Directions To \(currentVenue.venueName)", message: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addDetailsToSubviews()
       
    }
    private func createBarButton() {
        switch precedingVC {
            
        case .mapVC:
             navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addToCollection))
        case .collectionVC:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteFromCollection))
            
        default:
            break
        }
    }
    
    @objc private func getDirections() {
        guard let lat = currentVenue.lat, let long = currentVenue.long else { genericAlert(title:"Invalid Location Data",message:"")
            
            return}
                
             let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                   
               let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = currentVenue.venueName
               mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])

    }
        
        private func genericAlert(title:String,message:String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert,animated: true)
        }
    private func configureConstraints() {
        let outletArray = [resturantLabel,venueImageView,typeOfVenueLabel,tipLabel,addressTextView]
        
        for i in outletArray {
            i.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(i)
        }
        
        
        NSLayoutConstraint.activate([
            resturantLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20),
            resturantLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
              resturantLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:  -10),
              resturantLabel.heightAnchor.constraint(equalToConstant: 50),
              venueImageView.topAnchor.constraint(equalTo: resturantLabel.bottomAnchor),
              venueImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
              venueImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
              
              addressTextView.topAnchor.constraint(equalTo: venueImageView.bottomAnchor,constant: 10),
              
              addressTextView.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.height * 0.3),
              
              addressTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              addressTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              
              typeOfVenueLabel.topAnchor.constraint(equalTo: addressTextView.bottomAnchor),
               typeOfVenueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
                typeOfVenueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                typeOfVenueLabel.heightAnchor.constraint(equalToConstant: 50),
                tipLabel.topAnchor.constraint(equalTo: typeOfVenueLabel.bottomAnchor),
                tipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                tipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            tipLabel.heightAnchor.constraint(equalToConstant: 50),
            tipLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
              
        ])
    }
 
    
    @objc private func addToCollection() {
    
      
       
        let venueCollection = CollectionVC()
        
        venueCollection.currentVenue = currentVenue
        
    navigationController?.pushViewController(venueCollection, animated: true)
        
    }
    @objc private func deleteFromCollection() {
actionSheetWarning(alertTitle: "Delete From Collection?", saveOrDeleteMessage: "Delete")
    }
    
    private func addDetailsToSubviews() {
        resturantLabel.text = currentVenue.venueName
        venueImageView.image = UIImage(data: currentVenue.image)
        typeOfVenueLabel.text = currentVenue.venueType
        tipLabel.text = currentVenue.tip
        addressTextView.text = currentVenue.address
    }
  private func actionSheetWarning(alertTitle:String,saveOrDeleteMessage:String)  {
       
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .actionSheet)
        
        let saveOrDelete = UIAlertAction(title: saveOrDeleteMessage, style: .default) { [weak self] (result) in
            guard let id = self?.currentVenue.id else {return}
           
            self?.delegate?.deleteVenue(venueID: id)
            self?.navigationController?.popViewController(animated: true)
       
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveOrDelete)
        alert.addAction(cancel)
        present(alert,animated: true)
        }
    }


    
    

