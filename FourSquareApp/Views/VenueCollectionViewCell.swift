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
    
    var changeColorOfBorderCellFunction: (()->()) = {}

    
    override init(frame: CGRect) {
        super.init(frame:frame)
        configureConstraints()
    }
    
    private func configureConstraints() {
        contentView.addSubview(collectionImage)
        contentView.addSubview(nameLabel)
        
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: collectionImage.bottomAnchor),
             nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
              nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
