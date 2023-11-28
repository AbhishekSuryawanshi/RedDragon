//
//  StreetMatchEventsVC.swift
//  RedDragon
//
//  Created by Remya on 11/28/23.
//

import UIKit
import Combine

class StreetMatchEventsVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    private var feedsListVM : FeedsListViewModel?
    private var cancellable = Set<AnyCancellable>()
    var feedsList:[StreetEvent]?
    var originalFeedsList:[StreetEvent]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
        fetchFeedsListViewModel()
        makeNetworkCall()

        // Do any additional setup after loading the view.
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.feedsTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func fetchFeedsListViewModel() {
        feedsListVM = FeedsListViewModel()
        feedsListVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        feedsListVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        feedsListVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] feedsList in
                self?.execute_onResponseData(eventList: feedsList!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(eventList:[StreetEvent]) {
        self.feedsList = eventList
        self.originalFeedsList = eventList
        self.tableView.reloadData()
    }
    
    func makeNetworkCall(){
        feedsListVM?.fetchFeedsListAsyncCall()
    }
   
}


extension StreetMatchEventsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsList?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.feedsTableViewCell, for: indexPath) as! FeedsTableViewCell
        cell.configureCell(obj: feedsList?[indexPath.row])
        return cell
    }
    
}


extension StreetMatchEventsVC:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTeams(searchText: searchText)
    }
    
    func searchTeams(searchText:String){
        if searchText == ""{
            feedsList = originalFeedsList
            tableView.reloadData()
            searchBar.endEditing(true)
        }
        else{
            feedsList?.removeAll()
            feedsList = originalFeedsList?.filter{$0.creatorName.lowercased().contains(searchText.lowercased()) }
            tableView.reloadData()
        }
    }
    
}
