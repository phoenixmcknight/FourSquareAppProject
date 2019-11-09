//
//  OutletExtensions.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/7/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
public convenience init(font:UIFont){
    self.init()
    self.textAlignment = .center
    self.textColor = .black
    self.adjustsFontSizeToFitWidth = true
    self.numberOfLines = 0
    self.font = font
    }

}

extension UICollectionViewFlowLayout {
    public convenience init(placeHolder:String) {
    self.init()
        self.scrollDirection = .vertical
    self.itemSize = CGSize(width: 150, height:150)
        self.minimumInteritemSpacing = 20
        self.minimumLineSpacing = 20
        self.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
}
}
