//
//  ListTableViewCell.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/6/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

   lazy  var photoImage:UIImageView = {
        let pi = UIImageView()
        pi.image = UIImage(systemName: "photo")
        pi.contentMode = .scaleAspectFit
        
        return pi
        
    }()
    
   lazy var nameLabel:UILabel = {
        let nl = UILabel()
        
        nl.adjustsFontSizeToFitWidth = true
        nl.textAlignment = .center
        nl.textColor = .black
    nl.numberOfLines = 0
        return nl
    }()
    
    var changeColorOfBorderCellFunction: (()->()) = {}

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
           configureConstraints()
       }
       
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
   private  func addSubviews() {
    contentView.addSubview(nameLabel)
        contentView.addSubview(photoImage)
    }

    private func configureConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints  = false
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           
            photoImage.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2),
            nameLabel.leadingAnchor.constraint(equalTo: photoImage.trailingAnchor,constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
}
