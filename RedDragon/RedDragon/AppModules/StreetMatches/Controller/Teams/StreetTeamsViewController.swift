//
//  StreetTeamsViewController.swift
//  RedDragon
//
//  Created by Remya on 12/6/23.
//

import UIKit
import Combine

class StreetTeamsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var fixedEmpty: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var btnCreateTeam: UIButton!
    //Variables
    var teamViewModel : StreetTeamViewModel?
    var myTeamViewModel : StreetMyTeamViewModel?
    //var onlyOwn = 0
    var headers = ["My Teams".localized,"All Teams".localized]
    var isSearchMode = false
    var teams:[StreetTeam]?
    var teams_Original:[StreetTeam]?
    var myTeams:[StreetTeam]?
    private var cancellable = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLocalisations()
//        if Utility.isUserLoggedIn(){
//            viewModel.getTeams(isMyteams: 1)
//        }
        myTeamViewModel?.fetchMyStreetTeamsAsyncCall(isMyteams: 1)
        teamViewModel?.fetchStreetTeamsAsyncCall(isMyteams: 0)
        
    }
    
    
    @IBAction func actionCreateTeam(_ sender: Any) {
        navigateToViewController(CreateStreetTeamVC.self,storyboardName: StoryboardName.streetMatches)
    }
   
    func initialSetup(){
        nibInitialization()
        configureViewModel()
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.teamCollectionTableViewCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.newTeamTableViewCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.streetHomeHeaderTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func configureViewModel() {
       teamViewModel = StreetTeamViewModel()
        teamViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        teamViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        teamViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] teamList in
                self?.execute_onResponseData(teamList: teamList!)
            })
            .store(in: &cancellable)
        
        
        myTeamViewModel = StreetMyTeamViewModel()
        myTeamViewModel?.showError = { [weak self] error in
             self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
         }
        myTeamViewModel?.displayLoader = { [weak self] value in
             self?.showLoader(value)
         }
        myTeamViewModel?.$responseData
             .receive(on: DispatchQueue.main)
             .dropFirst()
             .sink(receiveValue: { [weak self] teamList in
                 self?.execute_onMyTeamData(teamList: teamList!)
             })
             .store(in: &cancellable)
    }
    
    func execute_onResponseData(teamList:[StreetTeam]){
        teams_Original = teamList
        teams = teamList
        tableView.reloadData()
        if teams?.count ?? 0 == 0{
            emptyView.isHidden = false
        }
        else{
            emptyView.isHidden = true
        }
        
    }
    
    func execute_onMyTeamData(teamList:[StreetTeam]){
        myTeams = teamList
        tableView.reloadData()
    }
    
    func setupLocalisations(){
        fixedEmpty.text = "No Teams Found!".localized
        btnCreateTeam.setTitle("Create Team".localized, for: .normal)
        searchBar.placeholder = "Search".localized
        headers = ["My Teams".localized,"All Teams".localized]

    }
  
}


extension StreetTeamsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getSectionCount()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearchMode{
            if section == 0 && (myTeams?.count ?? 0 > 0){
                
                return 1
            }
        }
        return teams?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isSearchMode{
            if indexPath.section == 0 && (myTeams?.count ?? 0 > 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.teamCollectionTableViewCell) as! TeamCollectionTableViewCell
                cell.teams = myTeams
                cell.passTeam = { [weak self] team in
                    self?.gotoTeamDetails(team: team)
                }
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newTeamTableViewCell) as! NewTeamTableViewCell
        cell.configureCell(obj: teams?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           gotoTeamDetails(team: teams?[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetHomeHeaderTableViewCell) as! StreetHomeHeaderTableViewCell
        cell.lblTitle.text = headers[section]
        cell.btnMore.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && (myTeams?.count ?? 0 == 0){
            
         return CGFloat.leastNormalMagnitude
        }
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func getSectionCount()->Int{
        if (myTeams?.count ?? 0 == 0) || isSearchMode{
            return 1
        }
        return 2
    }
    
    func gotoTeamDetails(team:StreetTeam?){
        navigateToViewController(StreetTeamDetailsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.teamID = team?.id
        }

    }
    
}



extension StreetTeamsViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        isSearchMode = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTeams(searchText: searchText)
    }
    
    func searchTeams(searchText:String){
        if searchText == ""{
            teams = teams_Original
            isSearchMode = false
            tableView.reloadData()
            searchBar.endEditing(true)
        }
        else{
            isSearchMode = true
            //teams?.removeAll()
            teams = teams_Original?.filter{$0.name.lowercased().contains(searchText.lowercased())}
            tableView.reloadData()
        }
    }
}
