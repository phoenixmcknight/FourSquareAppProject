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


