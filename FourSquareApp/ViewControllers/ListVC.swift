
import Foundation
import UIKit

enum PrecedingVC {
    case collectionVC
    case mapVC
}
class ListTableViewController:UIViewController {
    
    //MARK: Variables
    var venueTableViewData = [Venue]() {
        didSet {
            
            listTableView.reloadData()
        }
    }
    
    var collectionTableViewData:[SavedVenues]! {
        didSet {
            listTableView.reloadData()
        }
    }
    
    var listImageArray = [UIImage]()
    
    var currentIndex:Int? = nil 
    
    var precedingVC:PrecedingVC!
    
    var searchString:String? = nil {
        didSet {
            listTableView.reloadData()
        }
    }
    
    var mapSearchResults:[Venue] {
        guard let searchString = searchString else {
            return venueTableViewData}
        
        guard searchString != "" else {
            return venueTableViewData
        }
        return venueTableViewData.filter({$0.name.lowercased().contains(searchString.lowercased())})
    }
    
    var collectionViewSearchResults:[SavedVenues] {
        guard let searchString = searchString else {
            return collectionTableViewData}
        
        guard searchString != "" else {
            return collectionTableViewData
        }
        return collectionTableViewData.filter({$0.venueName.lowercased().contains(searchString.lowercased())})
    }
    
    //MARK: Views
    
    lazy var searchBarOne:UISearchBar = {
        let sbo = UISearchBar()
        sbo.tag = 0
        sbo.backgroundColor = .clear
        sbo.barTintColor = .clear
        sbo.searchBarStyle = .minimal
        return sbo
    }()
    
    lazy var listTableView:UITableView = {
        let tv = UITableView()
        
        tv.register(ListTableViewCell.self, forCellReuseIdentifier: RegisterCells.listTableViewCell.rawValue)
        tv.backgroundColor = .clear
        
        
        return tv
    }()
    
    lazy var viewArray = [self.searchBarOne,self.listTableView]

    //MARK:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsToSubview()
        configureSearchBarConstraints()
        configureTableviewConstraints()
        setDelegates()
        navigationItem.title = "Venue List"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listTableView.reloadData()        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if collectionTableViewData?.count != nil  {
            
        navigationController?.popViewController(animated: false)
   
        }
    }
    //MARK:Set Delegates
    private func setDelegates() {
        listTableView.dataSource = self
        listTableView.delegate = self
        searchBarOne.delegate = self
    }
    //MARK:Add Subviews to View
    private func addViewsToSubview() {
        for aview in viewArray {
            aview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(aview)
        }
        CustomLayer.shared.setGradientBackground(colorTop: .white, colorBottom: .lightGray, newView: view)
    }
    //MARK:Set Constraints
    private func configureSearchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBarOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarOne.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarOne.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
   
    private func configureTableviewConstraints() {
        NSLayoutConstraint.activate([
            
            listTableView.topAnchor.constraint(equalTo: searchBarOne.bottomAnchor),
            listTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
extension ListTableViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch precedingVC {
        case .mapVC:
            return mapSearchResults.count
        case .collectionVC:
            return collectionViewSearchResults.count
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: RegisterCells.listTableViewCell.rawValue, for: indexPath) as? ListTableViewCell else {return UITableViewCell()}
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        switch precedingVC {
            
        case .collectionVC:
            let savedVenues = collectionViewSearchResults[indexPath.row]
            cell.nameLabel.text = savedVenues.venueName
            cell.photoImage.image = UIImage(data: savedVenues.image)
        case .mapVC:
            let venue = mapSearchResults[indexPath.row]
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
            let selectedVenue = mapSearchResults[indexPath.row]
            
            currentVenue = SavedVenues(image: listImageArray[indexPath.row].pngData()!, venueName: selectedVenue.name, venueType: selectedVenue.returnCategory(), tip:"",id: selectedVenue.id,address:selectedVenue.location?.returnFormattedAddress() ?? "Location Data Unavailable",lat: selectedVenue.location?.lat,long: selectedVenue.location?.lng)
            
        case .collectionVC:
            let selectedVenue = collectionViewSearchResults[indexPath.row]
            
            currentVenue = SavedVenues(image: selectedVenue.image, venueName: selectedVenue.venueName, venueType: selectedVenue.venueType, tip:selectedVenue.tip, id:selectedVenue.id,address: selectedVenue.address,lat: selectedVenue.lat,long: selectedVenue.long  )
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
    func deleteVenue(venueID: String) {
        collectionTableViewData = collectionTableViewData.filter({$0.id != venueID})
        var collectionViewCategories = try! VenueCollectionPersistenceManager.manager.getSavedCollection()
        if let index = currentIndex {
            collectionViewCategories[index].savedVenue = collectionTableViewData
            try? VenueCollectionPersistenceManager.manager.replaceAllFunction(newCollection: collectionViewCategories)
        }
        
    }
}
extension ListTableViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
    }
}
