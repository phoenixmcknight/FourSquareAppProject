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

//MARK:Custom Delegate Functions
protocol DetailVenueDeleteDelegate:AnyObject {
    func deleteVenue(venueID:String)
}
class DetailVenueVC:UIViewController {
    
    //MARK: Variables
    
    var precedingVC:PrecedingVC!
    var currentVenue:SavedVenues!
    weak var delegate:DetailVenueDeleteDelegate?
    
    //MARK: Views
    
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
    
    //MARK:LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviewsToView()
        configureResturantConstraints()
        configureVenueImageViewConstraints()
        configureTextViewConstraints()
        configureTypeOfVenueLabel()
        configureTipLabelConstraints()
        genericAlert(title: "Click On the Address For Directions To \(currentVenue.venueName)", message: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addDetailsToSubviews()
    }
    
    //MARK:Add Subviews to Views
    private func addSubviewsToView() {
        switch precedingVC {
            
        case .mapVC:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addToCollection))
        case .collectionVC:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteFromCollection))
            
        default:
            break
        }
        let viewArray = [resturantLabel,venueImageView,typeOfVenueLabel,tipLabel,addressTextView]
        
        for i in viewArray {
            i.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(i)
        }
        CustomLayer.shared.setGradientBackground(colorTop: .lightGray, colorBottom: .white, newView: view)
    }
    
    //MARK: Set Constraints
    
    private func configureResturantConstraints() {
        NSLayoutConstraint.activate([
            resturantLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20),
            resturantLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            resturantLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:  -10),
            resturantLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func configureVenueImageViewConstraints() {
        NSLayoutConstraint.activate([
            venueImageView.topAnchor.constraint(equalTo: resturantLabel.bottomAnchor),
            venueImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            venueImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10)
        ])
        
    }
    private func configureTextViewConstraints() {
        NSLayoutConstraint.activate([
            addressTextView.topAnchor.constraint(equalTo: venueImageView.bottomAnchor,constant: 10),
            
            addressTextView.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.height * 0.2),
            
            addressTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addressTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureTypeOfVenueLabel() {
        NSLayoutConstraint.activate([
            typeOfVenueLabel.topAnchor.constraint(equalTo: addressTextView.bottomAnchor),
            typeOfVenueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            typeOfVenueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            typeOfVenueLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureTipLabelConstraints() {
        NSLayoutConstraint.activate([
            tipLabel.topAnchor.constraint(equalTo: typeOfVenueLabel.bottomAnchor),
            tipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            tipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            tipLabel.heightAnchor.constraint(equalToConstant: 50),
            tipLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    //MARK:@Objc Functions
    
    @objc private func addToCollection() {
        let venueCollection = CollectionVC()
        
        venueCollection.currentVenue = currentVenue
     navigationController?.pushViewController(venueCollection, animated: true)
        
    }
    @objc private func deleteFromCollection() {
        actionSheetWarning(alertTitle: "Delete \(currentVenue.venueName) From Collection?", saveOrDeleteMessage: "Delete")
    }
    
    @objc private func getDirections() {
        guard let lat = currentVenue.lat, let long = currentVenue.long else { genericAlert(title:"Invalid Location Data",message:"")
            
            return}
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = currentVenue.venueName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    //MARK: Alerts
    
    private func genericAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert,animated: true)
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
    //MARK:Add Information To Views
    private func addDetailsToSubviews() {
        resturantLabel.text = currentVenue.venueName
        venueImageView.image = UIImage(data: currentVenue.image)
        typeOfVenueLabel.text = currentVenue.venueType
        tipLabel.text = currentVenue.tip
        addressTextView.text = currentVenue.address
    }
}




