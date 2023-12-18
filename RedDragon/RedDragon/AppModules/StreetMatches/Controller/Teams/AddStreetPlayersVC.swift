//
//  AddStreetPlayersVC.swift
//  RedDragon
//
//  Created by Remya on 12/9/23.
//

import UIKit
import Combine

class AddStreetPlayersVC: UIViewController {

    @IBOutlet weak var btnAddPlayers: UIButton!
    @IBOutlet weak var tableViewPlayers: UITableView!
    
    //Variables
    var playerListViewModel:StreetPlayersListViewModel?
    var passPlayers:(([StreetMatchPlayer]?)->Void)?
    var chosenPlayers:[StreetMatchPlayer]?
    var players:[StreetMatchPlayer]?
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
  
    func initialSettings(){
        btnAddPlayers.setTitle("Add Players".localized, for: .normal)
        nibInitialization()
        configureViewModel()
        makeNetworkRequest()
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableViewPlayers, cellName: CellIdentifier.streetMatchPlayerTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func configureViewModel() {
        playerListViewModel = StreetPlayersListViewModel()
        playerListViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        playerListViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        playerListViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let playerList = response?.response?.data{
                    self?.execute_onResponseData(playerList: playerList)
                }
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(playerList:[StreetMatchPlayer]){
        players = playerList
        let ids:[Int] = self.chosenPlayers?.map{$0.id ?? 0} ?? []
        for i in 0 ... (players?.count ?? 0)-1{
            if ids.contains(players?[i].id ?? 0){
                players?[i].selected = true
            }
        }
       
        tableViewPlayers.reloadData()
    }
    
    func makeNetworkRequest(){
        playerListViewModel?.fetchStreetPlayerListAsyncCall()
    }
    
    func toPlayerDetails(player:StreetMatchPlayer?){
//        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//        vc.isOtherPlayer = true
//        vc.playerID = player?.id
//        vc.userID = player?.creatorUserId
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionAddPlayers(_ sender: Any) {
        let players = players?.filter{$0.selected == true}
        passPlayers?(players)
        self.navigationController?.popViewController(animated: true)
    }
}


extension AddStreetPlayersVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchPlayerTableViewCell, for: indexPath) as! StreetMatchPlayerTableViewCell
        cell.configureCell(obj: players?[indexPath.row])
        cell.callSelection = {
            self.toPlayerDetails(player: self.players?[indexPath.row])
        }
        cell.btnInfo.isHidden = false
        cell.handleSelection(selected: players?[indexPath.row].selected ?? false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = players?[indexPath.row].selected ?? false
       players?[indexPath.row].selected = !selected
        self.tableViewPlayers.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
    }
}
