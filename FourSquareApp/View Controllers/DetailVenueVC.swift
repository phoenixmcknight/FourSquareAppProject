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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            resturantLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: -10),
            resturantLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
              resturantLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:  -10),
              resturantLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.03),
              venueImageView.topAnchor.constraint(equalTo: resturantLabel.bottomAnchor),
              venueImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
              venueImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
              
              venueImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9),
              typeOfVenueLabel.topAnchor.constraint(equalTo: venueImageView.bottomAnchor),
               typeOfVenueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
                typeOfVenueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                tipLabel.topAnchor.constraint(equalTo: typeOfVenueLabel.bottomAnchor),
                tipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                tipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10)
              
        ])
    }
}
