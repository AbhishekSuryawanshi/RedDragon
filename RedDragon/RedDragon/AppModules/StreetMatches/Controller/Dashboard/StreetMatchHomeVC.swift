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
        if !isUserLoggedIn(){
            self.customAlertView_2Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                /// Show login page to login/register new user
                /// hide tabbar before presenting a viewcontroller
                /// show tabbar while dismissing a presented viewcontroller in delegate
                self.tabBarController?.tabBar.isHidden = true
                self.presentOverViewController(LoginVC.self, storyboardName: StoryboardName.login) { vc in
                    vc.delegate = self
                }
            }
            return
        }
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
            .sink(receiveValue: { [weak self] response in
                if response?.response?.data != nil{
                    self?.execute_onResponseData(homeData: response!.response!.data!)
                }
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(homeData:StreetMatchHome) {
        self.homeData = homeData
        self.matches = homeData.matches
        self.tableView.reloadData()
    }
    
    func makeNetworkCall(){
        streethomeVM?.fetchStreetHomeAsyncCall(id: nil)
    }
}

extension StreetMatchHomeVC: LoginVCDelegate {
    func viewControllerDismissed() {
        self.tabBarController?.tabBar.isHidden = false
        presentOverViewController(ChooseOptionsVC.self,storyboardName: StoryboardName.streetMatches)
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
                if  (homeData?.stadiums?.count ?? 0) >= 2{
                    return 2
                }
                else{
                    return homeData?.stadiums?.count ?? 0
                }
            }
            else if section == 1{
                if (homeData?.events?.count ?? 0) >= 3{
                    return 3
                }
                else{
                    return homeData?.events?.count ?? 0
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
                cell.configureCell(obj: homeData?.stadiums?[indexPath.row])
                return cell
            }
            else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.feedsTableViewCell, for: indexPath) as! FeedsTableViewCell
                cell.configureCell(obj: homeData?.events?[indexPath.row])
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchTableViewCell, for: indexPath) as! StreetMatchTableViewCell
                cell.configureCell(obj: matches?[indexPath.row])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            openStadiumDetails(index: indexPath.row)
        }
        else if indexPath.section == 1{
            openEventDetails(index: indexPath.row)
        }
        else{
            openMatchDetails(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetHomeHeaderTableViewCell) as! StreetHomeHeaderTableViewCell
        cell.lblTitle.text = headers[section]
        cell.callSelection = {
            if section == 0{
                self.goToStadiums()
            }
            else if section == 1{
                self.goToEvents()
            }
            else{
                self.goToMatches()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func openStadiumDetails(index:Int){
        navigateToViewController(StadiumDetailsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.stadium = self.homeData?.stadiums?[index]
        }
    }
    func openMatchDetails(index:Int){
        navigateToViewController(StreetMatchesDetailsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.matchID = self.homeData?.matches?[index].id
        }
    }
    func openEventDetails(index:Int){
        navigateToViewController(StreetEventDetailsViewController.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.details = self.homeData?.events?[index]
        }
    }
    
    func goToStadiums(){
        print(self.parent)
        if let vc = self.parent as? StreetMatchesDashboardVC{
            vc.headerCollectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            vc.headerCollectionView.delegate?.collectionView?(vc.headerCollectionView, didSelectItemAt: IndexPath(row: 1, section: 0))
        }
    }
    
    func goToMatches(){
        if let vc = self.parent as? StreetMatchesDashboardVC{
            vc.headerCollectionView.selectItem(at: IndexPath(row: 3, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            vc.headerCollectionView.delegate?.collectionView?(vc.headerCollectionView, didSelectItemAt: IndexPath(row: 3, section: 0))
        }
        
    }
    
    func goToEvents(){
        if let vc = self.parent as? StreetMatchesDashboardVC{
            vc.headerCollectionView.selectItem(at: IndexPath(row: 2, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            vc.headerCollectionView.delegate?.collectionView?(vc.headerCollectionView, didSelectItemAt: IndexPath(row: 2, section: 0))
        }
        
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
            matches = homeData?.matches?.filter{($0.address?.lowercased().contains(text.lowercased()) ?? false) || ($0.homeTeam?.name?.lowercased().contains(text.lowercased()) ?? false) || ($0.awayTeam?.name?.lowercased().contains(text.lowercased()) ?? false)}
            isSearchMode = true
            tableView.reloadData()
        }
    }
}
