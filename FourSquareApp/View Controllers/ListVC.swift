//
//  vi.swift
//  FourSquareApp
//
//  Created by Phoenix McKnight on 11/4/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import Foundation
import UIKit

enum PrecedingVC {
    case collectionVC
    case mapVC
}
class ListTableViewController:UIViewController {
  
    var venueTableViewData = [Venue]() {
        didSet {
            print("print data")
            listTableView.reloadData()
        }
    }
    
    var collectionTableViewData = [SavedVenues]() {
        didSet {
            listTableView.reloadData()
        }
    }
    
    var listImageArray = [UIImage]()
    
    var currentIndex:Int? = nil
    
    lazy var listTableView:UITableView = {
        let tv = UITableView()
      
        tv.register(ListTableViewCell.self, forCellReuseIdentifier: RegisterCells.listTableViewCell.rawValue)
    
        
        
return tv
    }()
    
    var precedingVC:PrecedingVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createConstraints()
        listTableView.dataSource = self
        listTableView.delegate = self
         
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     listTableView.reloadData()
        print("print data")
        
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
    
    private func backButtonPressed() {
        
    }
}
extension ListTableViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch precedingVC {
        case .mapVC:
            return venueTableViewData.count
        case .collectionVC:
            return collectionTableViewData.count
        case .none:
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: RegisterCells.listTableViewCell.rawValue, for: indexPath) as? ListTableViewCell else {return UITableViewCell()}
        switch precedingVC {
            
        case .collectionVC:
             let savedVenues = collectionTableViewData[indexPath.row]
            cell.nameLabel.text = savedVenues.venueName
            cell.photoImage.image = UIImage(data: savedVenues.image)
        case .mapVC:
            let venue = venueTableViewData[indexPath.row]
            let image = listImageArray[indexPath.row]
            cell.nameLabel.text = venue.name
            cell.photoImage.image = image
        case .none:
            return UITableViewCell()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currentVenue:SavedVenues!
        switch precedingVC {
        case.mapVC:
             currentVenue = SavedVenues(image: listImageArray[indexPath.row].pngData()!, venueName: venueTableViewData[indexPath.row].name, venueType: venueTableViewData[indexPath.row].returnCategory(searchString: "Unknown Category"), tip:""  )
            
        case .collectionVC:
            currentVenue = SavedVenues(image: collectionTableViewData[indexPath.row].image, venueName: collectionTableViewData[indexPath.row].venueName, venueType: collectionTableViewData[indexPath.row].venueType, tip:collectionTableViewData[indexPath.row].tip  )
        case .none:
            print("error")
        }
        
    
       let detailVC = DetailVenueVC()
        detailVC.currentVenue = currentVenue
        detailVC.precedingVC = precedingVC
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension ListTableViewController:DetailVenueDeleteDelegate {
    func deleteVenue(venueName: String) {
        collectionTableViewData = collectionTableViewData.filter({$0.venueName != venueName})
        var collectionViewCategories = try! VenueCollectionPersistenceManager.manager.getSavedCollection()
        if let index = currentIndex {
            collectionViewCategories[index].savedVenue = collectionTableViewData
            try? VenueCollectionPersistenceManager.manager.replaceAllFunction(newCollection: collectionViewCategories)
        }
        
    }
    
    
}
