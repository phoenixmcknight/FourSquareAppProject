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

class ListTableViewController:UIViewController {
  
    var venueTableViewData = [Venue]() {
        didSet {
            listTableView.reloadData()
        }
    }
    
    var listImageArray = [UIImage]()
        
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
         
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     listTableView.reloadData()
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
extension ListTableViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueTableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let venue = venueTableViewData[indexPath.row]
        let image = listImageArray[indexPath.row]
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: RegisterCell.listTableViewCell.rawValue, for: indexPath) as? ListTableViewCell else {return UITableViewCell()}
        
        cell.nameLabel.text = venue.name
        cell.photoImage.image = image
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentVenue = SavedVenues(image: listImageArray[indexPath.row].pngData()!, venueName: venueTableViewData[indexPath.row].name, venueType: venueTableViewData[indexPath.row].returnCategory(searchString: "Unknown Category"), tip:""  )
        
       let detailVC = DetailVenueVC()
        detailVC.currentVenue = currentVenue
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
