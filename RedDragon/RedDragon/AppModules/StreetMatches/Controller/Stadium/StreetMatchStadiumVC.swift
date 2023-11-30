//
//  StreetMatchStadiumVC.swift
//  RedDragon
//
//  Created by Remya on 11/28/23.
//

import UIKit
import Combine

class StreetMatchStadiumVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    //Variables
    private var stadiumListVM : StadiumListViewModel?
    private var cancellable = Set<AnyCancellable>()
    var stadiumList:[Stadium]?
    var originalStadiumList:[Stadium]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
        fetchStadiumListViewModel()
        makeNetworkCall()

        // Do any additional setup after loading the view.
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.stadiumTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func fetchStadiumListViewModel() {
        stadiumListVM = StadiumListViewModel()
        stadiumListVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        stadiumListVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        stadiumListVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] stadiumList in
                self?.execute_onResponseData(stadiumList: stadiumList!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(stadiumList:[Stadium]) {
        self.stadiumList = stadiumList
        self.originalStadiumList = stadiumList
        self.tableView.reloadData()
    }
    
    func makeNetworkCall(){
        stadiumListVM?.fetchStadiumListAsyncCall()
    }
}


extension StreetMatchStadiumVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stadiumList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.stadiumTableViewCell, for: indexPath) as! StadiumTableViewCell
        cell.configureCell(obj:stadiumList?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetails(index: indexPath.row)
        
    }
    
    func openDetails(index:Int){
        navigateToViewController(StadiumDetailsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.stadium = self.stadiumList?[index]
        }
    }
}


extension StreetMatchStadiumVC:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTeams(searchText: searchText)
    }
    
    func searchTeams(searchText:String){
        if searchText == ""{
            stadiumList = originalStadiumList
            tableView.reloadData()
            searchBar.endEditing(true)
        }
        else{
            stadiumList?.removeAll()
            stadiumList = originalStadiumList?.filter{$0.name.lowercased().contains(searchText.lowercased()) }
            tableView.reloadData()
        }
    }
    
}
