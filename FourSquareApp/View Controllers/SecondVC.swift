//
//  vi.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/4/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation
import UIKit

class VenueTableViewController:UIViewController {
  
    var venue = [Venue]() {
        didSet {
            
        }
    }
    
    var image = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
