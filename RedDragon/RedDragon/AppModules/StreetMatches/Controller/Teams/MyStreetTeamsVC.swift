//
//  MyStreetTeamsVC.swift
//  RedDragon
//
//  Created by Remya on 12/9/23.
//

import UIKit

class MyStreetTeamsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCreateTeam: UIButton!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var emptyView: UIView!
    var isForSelection = false
    var passTeam:((StreetTeam?)->Void)?
    var viewModel:MyTeamViewModel?
    var teams:[StreetTeam]?
    var isFromProfile = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool){
//        if !isFromProfile{
//            viewModel.getTeams()
//        }
    }
    
    @IBAction func actionCreateTeam(_ sender: Any) {
        navigateToViewController(CreateStreetTeamVC.self,storyboardName: StoryboardName.streetMatches)
    }
    
    func initialSettings(){
        setupLocalisation()
        registerCells()
    }
    
    func setupLocalisation(){
        lblEmpty.text = "No Teams Found!".localized
//        if isForSelection{
//            self.navigationItem.titleView = getHeaderLabel(title: "Choose a team".localized)
//        }
//        else{
//            self.navigationItem.titleView = getHeaderLabel(title: "My Teams".localized)
//        }
        btnCreateTeam.setTitle("Create Team".localized, for: .normal)
        
    }
    
    func registerCells(){
        tableView.register(UINib(nibName: "NewTeamTableViewCell", bundle: nil), forCellReuseIdentifier: "newTeamTableViewCell")
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
//extension MyStreetTeamsVC:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.teams?.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "newTeamTableViewCell") as! NewTeamTableViewCell
//        cell.configureCell(obj: viewModel.teams?[indexPath.row])
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if isForSelection{
//            passTeam?(viewModel.teams?[indexPath.row])
//            self.navigationController?.popViewController(animated: true)
//        }
//        else{
//            gotoTeamDetails(team: viewModel.teams?[indexPath.row])
//        }
//    }
//    
//    func gotoTeamDetails(team:Team?){
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeamDetailsViewController") as! TeamDetailsViewController
//        vc.teamID = team?.id
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//  
//}
