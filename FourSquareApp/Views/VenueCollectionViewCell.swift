//
//  VenueCollectionViewCell.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/8/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import UIKit

class VenueCollectionViewCell: UICollectionViewCell {
    
    lazy var collectionImage:UIImageView = {
        let ci = UIImageView()
        ci.contentMode = .scaleAspectFit
        return ci
    }()
    
    lazy var nameLabel:UILabel = {
        let nl = UILabel(font: UIFont(name: "Courier-Bold", size: 16.0)!)
        return nl
    }()
    
    lazy var plusImageView:UIImageView = {
       let plus = UIImageView()
        plus.contentMode = .scaleAspectFit
        return plus
    }()
    
    lazy var outletArray = [self.collectionImage,self.nameLabel]
    
    var changeColorOfBorderCellFunction: (()->()) = {}

    
    override init(frame: CGRect) {
        super.init(frame:frame)
        configureConstraints()
    }
    
    private func configureConstraints() {
        for outlet in outletArray {
            outlet.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(outlet)
        }
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionImage.addSubview(plusImageView)
       
        NSLayoutConstraint.activate([
            collectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionImage.heightAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.height * 0.8),
            plusImageView.centerXAnchor.constraint(equalTo: collectionImage.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: collectionImage.centerYAnchor),
            plusImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height / 3),
            plusImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width / 3),
            nameLabel.topAnchor.constraint(equalTo: collectionImage.bottomAnchor),
             nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
              nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) 
            
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
