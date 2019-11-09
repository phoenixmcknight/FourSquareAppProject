//
//  DetailVenueVC.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/7/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation
import UIKit

class DetailVenueVC:UIViewController {
    lazy var resturantLabel:UILabel = {
        
        let rl = UILabel(font: UIFont(name: "Courier-Bold", size: 24.0)!)
        return rl
    }()
    
    lazy var typeOfVenueLabel:UILabel = {
           
           let rl = UILabel(font: UIFont(name: "Courier-Bold", size: 14.0)!)
           return rl
       }()
    
    lazy var tipLabel:UILabel = {
           
           let rl = UILabel(font: UIFont(name: "Courier-Bold", size: 14.0)!)
           return rl
       }()
    
    
    lazy var venueImageView:UIImageView = {
        let vIv = UIImageView()
        vIv.contentMode = .scaleAspectFit
        vIv.tintColor = .black
        return vIv
    }()
    
   var currentVenue:SavedVenues!
//var currentVenue:Venue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    configureConstraints()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addDetailsToSubviews()
    }
 
    private func configureConstraints() {
        let outletArray = [resturantLabel,venueImageView,typeOfVenueLabel,tipLabel]
        
        for i in outletArray {
            i.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(i)
        }
         navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addToCollection))
        
        NSLayoutConstraint.activate([
            resturantLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20),
            resturantLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
              resturantLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:  -10),
              resturantLabel.heightAnchor.constraint(equalToConstant: 50),
              venueImageView.topAnchor.constraint(equalTo: resturantLabel.bottomAnchor),
              venueImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
              venueImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
              
              typeOfVenueLabel.topAnchor.constraint(equalTo: venueImageView.bottomAnchor),
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
    
    private func addDetailsToSubviews() {
        resturantLabel.text = currentVenue.venueName
        venueImageView.image = UIImage(data: currentVenue.image)
        typeOfVenueLabel.text = currentVenue.venueType
        tipLabel.text = currentVenue.tip
    }
}
