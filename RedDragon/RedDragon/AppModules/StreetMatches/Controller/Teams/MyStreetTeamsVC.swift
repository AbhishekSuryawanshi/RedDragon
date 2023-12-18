//
//  MyStreetTeamsVC.swift
//  RedDragon
//
//  Created by Remya on 12/9/23.
//

import UIKit
import Combine

class MyStreetTeamsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCreateTeam: UIButton!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var fixedMyTeams: UILabel!
    
    var isForSelection = false
    var passTeam:((StreetTeam?)->Void)?
    var myTeamViewModel:StreetMyTeamViewModel?
    var teams:[StreetTeam]?
    var isFromProfile = false
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    
    @IBAction func actionCreateTeam(_ sender: Any) {
        navigateToViewController(CreateStreetTeamVC.self,storyboardName: StoryboardName.streetMatches)
    }
    
    func initialSettings(){
        setupLocalisation()
        registerCells()
        configureViewModel()
        if !isFromProfile{
            makeNetworkCall()
        }
    }
    
    func setupLocalisation(){
        lblEmpty.text = "No Teams Found!".localized
        fixedMyTeams.text = "My Teams".localized
        btnCreateTeam.setTitle("Create Team".localized, for: .normal)
    }
    
    func registerCells(){
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.newTeamTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func configureViewModel() {
       
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
             .sink(receiveValue: { [weak self] response in
                 if let list = response?.response?.data{
                     self?.execute_onMyTeamData(teamList: list)
                 }
             })
             .store(in: &cancellable)
    }
    
   
    
    func execute_onMyTeamData(teamList:[StreetTeam]){
        teams = teamList
        tableView.reloadData()
    }
    
    func makeNetworkCall(){
        myTeamViewModel?.fetchMyStreetTeamsAsyncCall(isMyteams: 1)
    }
}

//extension MyStreetTeamsVC: MyTeamViewModelDelegate{
//    func didFinishTeamFetch(){
//        tableView.reloadData()
//        if viewModel.teams?.count ?? 0 > 0{
//            emptyView.isHidden = true
//        }
//        else{
//            emptyView.isHidden = false
//        }
//    }
//}
//
//
//
extension MyStreetTeamsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teams?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newTeamTableViewCell) as! NewTeamTableViewCell
        cell.configureCell(obj: teams?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isForSelection{
            passTeam?(teams?[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
        else{
            gotoTeamDetails(team:teams?[indexPath.row])
        }
    }
    
    func gotoTeamDetails(team:StreetTeam?){
        navigateToViewController(StreetTeamDetailsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.teamID = team?.id
        }
    }
}
