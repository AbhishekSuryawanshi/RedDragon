//
//  StreetEventRequestsViewController.swift
//  RedDragon
//
//  Created by Remya on 12/13/23.
//

import UIKit
import Combine

class StreetEventRequestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    //Variables
    var feedType:FeedsType?
    var eventID:Int?
    var requests:[StreetEventRequest]?
    var requestListViewModel:StreetEventRequestViewModel?
    var requestAcceptViewModel:StreetEventRequestAcceptViewModel?
    
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
      }
    
    
    func initialSettings(){
        configureViewModel()
        lblNoData.text = "No Requests Found".localized
        nibInitialization()
        makeNetworkCall()
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.feedsPlayerTableViewCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.feedsTeamTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func configureViewModel() {
        requestListViewModel = StreetEventRequestViewModel()
        requestListViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        requestListViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        requestListViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.handleResponse(data: response!)
            })
            .store(in: &cancellable)
        
        
        requestAcceptViewModel = StreetEventRequestAcceptViewModel()
        requestAcceptViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        requestAcceptViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        requestAcceptViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                
                self?.acceptRequestSuccess(message: response?.response?.messages?.first ?? "")
            })
            .store(in: &cancellable)
    }
    
    func handleResponse(data:[StreetEventRequest]){
        self.requests = data
        tableView.reloadData()
        if requests?.count ?? 0 > 0{
            emptyView.isHidden = true
        }
        else{
            emptyView.isHidden = false
        }
        
    }
    
    func acceptRequestSuccess(message:String){
        self.customAlertView(title: ErrorMessage.success.localized, description: message, image: ImageConstants.successImage) {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func makeNetworkCall(){
        requestListViewModel?.getEventRequestsAsyncCall(eventID: eventID!)
    }
    
    func goToPlayerProfile(player:Player?){
//        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//        vc.isOtherPlayer = true
//        vc.playerID = player?.id
//        vc.userID = player?.userId
//        self.navigationController?.pushViewController(vc, animated: true)
    }
   

}

extension StreetEventRequestsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if feedType == .searchPlayer{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.feedsPlayerTableViewCell, for: indexPath) as! FeedsPlayerTableViewCell
            cell.configureCell(obj: requests?[indexPath.row].creator)
            if requests?[indexPath.row].isAccepted == 1{
                cell.btnAccept.isHidden = true
            }
            else{
                cell.btnAccept.isHidden = false
            }
            cell.callAccept = {
                if let id = self.requests?[indexPath.row].id{
                    self.requestAcceptViewModel?.acceptEventRequestsAsyncCall(eventRequestID: id)
                }
                
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.feedsTeamTableViewCell, for: indexPath) as! FeedsTeamTableViewCell
            if requests?[indexPath.row].isAccepted == 1{
                cell.btnAccept.isHidden = true
            }
            else{
                cell.btnAccept.isHidden = false
            }
            cell.configureCell(obj: requests?[indexPath.row].team)
            cell.callAccept = {
                if let id = self.requests?[indexPath.row].id{
                    self.requestAcceptViewModel?.acceptEventRequestsAsyncCall(eventRequestID: id)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if feedType == .searchPlayer{
            
        //goToPlayerProfile(player: requests?[indexPath.row].creator?.player)
            
        }
    }
    
}

