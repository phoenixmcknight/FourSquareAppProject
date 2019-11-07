//
//  vi.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/4/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation
import UIKit

enum RegisterCell:String {
    case mapCollectionViewCell
    case listTableViewCell
}

class VenueTableViewController:UIViewController {
  
    var venueTableViewData = [Venue]() {
        didSet {
            listTableView.reloadData()
        }
    }
        
    lazy var listTableView:UITableView = {
        let tv = UITableView()
      
        tv.register(ListTableViewCell.self, forCellReuseIdentifier: RegisterCell.listTableViewCell.rawValue)
    
        
        
return tv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createConstraints()
        listTableView.dataSource = self
        listTableView.delegate = self
         listTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
    }
    

    private func createConstraints() {
        
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(listTableView)
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
             listTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
              listTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
               listTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
extension VenueTableViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueTableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let venue = venueTableViewData[indexPath.row]
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: RegisterCell.listTableViewCell.rawValue, for: indexPath) as? ListTableViewCell else {return UITableViewCell()}
        
        cell.nameLabel.text = venue.name
        MapPictureAPIClient.manager.getFourSquarePictureData(venueID: venue.id) { (results) in
            switch results {
                
            case .success(let data):
                ImageHelper.shared.getImage(urlStr: data[0].returnPictureURL()) { (results) in
                    switch results {
                        
                    case .success(let image):
                        cell.photoImage.image = image
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
}
