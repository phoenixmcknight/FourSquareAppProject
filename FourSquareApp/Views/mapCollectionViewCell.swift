//
//  mapCollectionViewCell.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/4/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
    
    
    lazy var fourSquareImageView:UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "photo")
        
        return iv
    }()
    
    lazy var venueNameLabel:UILabel = {
        let vnl = UILabel(font: UIFont(name: "Courier-Bold", size: 12.0)!)
        return vnl
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureConstraints()
    }
    
    private func addViews(){
        contentView.addSubview(fourSquareImageView)
        contentView.addSubview(venueNameLabel)
        
    }
    
    private func configureConstraints() {
        fourSquareImageView.translatesAutoresizingMaskIntoConstraints = false
        
        venueNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fourSquareImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            fourSquareImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fourSquareImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width * 1),
            
            fourSquareImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.8),
            venueNameLabel.topAnchor.constraint(equalTo: fourSquareImageView.topAnchor,constant: 20),
            venueNameLabel.leadingAnchor.constraint(equalTo: fourSquareImageView.leadingAnchor,constant: 10),
            venueNameLabel.trailingAnchor.constraint(equalTo: fourSquareImageView.trailingAnchor,constant: -10),
            venueNameLabel.bottomAnchor.constraint(equalTo: fourSquareImageView.centerYAnchor,constant: 10)
            //set label to bottom of imageview
            //reuse detailVC for listVC
            
        ])
    }
    
    
}
