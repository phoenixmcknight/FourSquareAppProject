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
        
        
        return iv
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
        
    }
    
    private func configureConstraints() {
        fourSquareImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fourSquareImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            fourSquareImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fourSquareImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fourSquareImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
}
