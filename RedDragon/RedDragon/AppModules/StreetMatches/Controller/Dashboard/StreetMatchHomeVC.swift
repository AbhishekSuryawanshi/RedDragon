//
//  StreetMatchHomeVC.swift
//  RedDragon
//
//  Created by Remya on 11/24/23.
//

import UIKit
import Combine

enum StreetMatchStates:String{
    case NOT_STARTED = "NOT_STARTED"
    case FINISHED =  "FINISHED"
    var description:String{
        switch self{
        case .NOT_STARTED:
            return "Upcoming".localized
        case .FINISHED:
            return "Finished".localized
        }
    }
}

enum FeedsType:String{
    
    case searchTeam = "SEARCH_TEAM"
    case searchPlayer = "SEARCH_PLAYERS"
    case challengeTeam = "CHALLENGE_TEAM"
    
    var description:String{
        switch self{
        case .searchTeam:
            return "Search Team".localized
        case .searchPlayer:
            return "Search Players".localized
        case .challengeTeam:
            return "Challenge Team".localized
        }
    }
    
}

class StreetMatchHomeVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var headers = ["Available Stadiums".localized,"Feeds".localized,"Matches".localized]
    var homeData:StreetMatchHome?
    var matches: [StreetMatch]?
    var isSearchMode = false
    private var streethomeVM: StreetHomeViewModel?
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
        fetchStreetHomeViewModel()
        makeNetworkCall()
    }
    
    
    @IBAction func actionCreate(_ sender: Any) {
        presentOverViewController(ChooseOptionsVC.self,storyboardName: StoryboardName.streetMatches)
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.stadiumTableViewCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.feedsTableViewCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.streetMatchTableViewCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.streetHomeHeaderTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func fetchStreetHomeViewModel() {
        streethomeVM = StreetHomeViewModel()
        streethomeVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        streethomeVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        streethomeVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] homeData in
                self?.execute_onResponseData(homeData: homeData!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(homeData:StreetMatchHome) {
        self.homeData = homeData
        self.matches = homeData.matches
        self.tableView.reloadData()
    }
    
    func makeNetworkCall(){
        streethomeVM?.fetchStreetHomeAsyncCall()
    }
}

extension StreetMatchHomeVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchMode{
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode{
            return matches?.count ?? 0
        }
        else{
            if section == 0{
                if  (homeData?.stadiums.count ?? 0) >= 2{
                    return 2
                }
                else{
                    return homeData?.stadiums.count ?? 0
                }
            }
            else if section == 1{
                if (homeData?.events.count ?? 0) >= 3{
                    return 3
                }
                else{
                    return homeData?.events.count ?? 0
                }
            }
            else {
                return matches?.count ?? 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearchMode{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchTableViewCell, for: indexPath) as! StreetMatchTableViewCell
            cell.configureCell(obj: matches?[indexPath.row])
            return cell
            
        }
        else{
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.stadiumTableViewCell, for: indexPath) as! StadiumTableViewCell
                cell.configureCell(obj: homeData?.stadiums[indexPath.row])
                return cell
            }
            else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.feedsTableViewCell, for: indexPath) as! FeedsTableViewCell
                cell.configureCell(obj: homeData?.events[indexPath.row])
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchTableViewCell, for: indexPath) as! StreetMatchTableViewCell
                cell.configureCell(obj: matches?[indexPath.row])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetHomeHeaderTableViewCell) as! StreetHomeHeaderTableViewCell
        cell.lblTitle.text = headers[section]
        return cell
    }
    
    
}


extension StreetMatchHomeVC:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch(text: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func doSearch(text:String){
        if text == ""{
            matches = homeData?.matches
            isSearchMode = false
            tableView.reloadData()
        }
        else{
            matches = homeData?.matches.filter{($0.address.lowercased().contains(text.lowercased()) ) || ($0.homeTeam.name.lowercased().contains(text.lowercased()) ) || ($0.awayTeam.name.lowercased().contains(text.lowercased()) )}
            isSearchMode = true
            tableView.reloadData()
        }
    }
}
