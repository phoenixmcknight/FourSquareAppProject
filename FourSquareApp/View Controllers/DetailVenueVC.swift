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
    
    var holdImage:UIImage!
    
    var holdTitle:String!
    
    var holdTypeOfResturant:String!
    
    var tip:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
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
        }
        
        NSLayoutConstraint.activate([
            resturantLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20),
            resturantLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
              resturantLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:  -10),
              resturantLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
              venueImageView.topAnchor.constraint(equalTo: resturantLabel.bottomAnchor),
              venueImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
              venueImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
              
              venueImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
              typeOfVenueLabel.topAnchor.constraint(equalTo: venueImageView.bottomAnchor),
               typeOfVenueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
                typeOfVenueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                typeOfVenueLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
                tipLabel.topAnchor.constraint(equalTo: typeOfVenueLabel.bottomAnchor),
                tipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                tipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            tipLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
            tipLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
              
        ])
    }
    private func addSubviews() {
        view.addSubview(resturantLabel)
        view.addSubview(venueImageView)
        view.addSubview(typeOfVenueLabel)
        view.addSubview(tipLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addToCollection))
    }
    
    @objc private func addToCollection() {
        
    }
    
    private func addDetailsToSubviews() {
        resturantLabel.text = holdTitle
        venueImageView.image = holdImage
        typeOfVenueLabel.text = holdTypeOfResturant
        tipLabel.text = tip
    }
}
