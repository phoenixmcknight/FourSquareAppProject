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
            fourSquareImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            fourSquareImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fourSquareImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.8),
            
            fourSquareImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.8)
        ])
    }
    
    
}
