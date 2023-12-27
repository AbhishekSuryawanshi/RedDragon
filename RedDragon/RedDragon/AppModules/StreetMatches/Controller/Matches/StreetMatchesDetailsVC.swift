//
//  StreetMatchesDetailsVC.swift
//  RedDragon
//
//  Created by Remya on 12/6/23.
//

import UIKit
import Combine

class StreetMatchesDetailsVC: UIViewController {
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgAway: UIImageView!
    @IBOutlet weak var lblAwayScore: UILabel!
    @IBOutlet weak var lblHomeScore: UILabel!
    @IBOutlet weak var lblAway: UILabel!
    @IBOutlet weak var tableViewAwayLineup: UITableView!
    @IBOutlet weak var fixedAwayLineup: UILabel!
    @IBOutlet weak var tableViewHomeLineup: UITableView!
    @IBOutlet weak var fixedHomeLineup: UILabel!
    @IBOutlet weak var tableViewAwayHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHomeHeight: NSLayoutConstraint!
    @IBOutlet weak var lblMatchDetails: UILabel!
    
    var matchDetails:StreetMatchDetails?
    var tableViewHomeObserver: NSKeyValueObservation?
    var tableViewAwayObserver: NSKeyValueObservation?
    var matchID:Int?
    private var matchDetailsVM : StreetMatchDetailsViewModel?
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
        setupLocalisation()
        setObserver()
        fetchMatchDetailsViewModel()
        makeNetworkCall()

        // Do any additional setup after loading the view.
    }
    
    func setupLocalisation(){
        lblMatchDetails.text = "Match Details".localized
        fixedAwayLineup.text = "Away Lineup".localized
        fixedHomeLineup.text = "Home Lineup".localized
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableViewHomeLineup, cellName: CellIdentifier.streetMatchPlayerTableViewCell)
        defineTableViewNibCell(tableView: tableViewAwayLineup, cellName: CellIdentifier.streetMatchPlayerTableViewCell)
    }
    
    func setObserver(){
        tableViewHomeObserver = tableViewHomeLineup.observe(\.contentSize, options: .new) { (_, change) in
                    guard let height = change.newValue?.height else { return }
                    self.tableViewHomeHeight.constant = height
                }
        tableViewAwayObserver = tableViewAwayLineup.observe(\.contentSize, options: .new) { (_, change) in
                    guard let height = change.newValue?.height else { return }
                    self.tableViewAwayHeight.constant = height
                }
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func fetchMatchDetailsViewModel() {
        matchDetailsVM = StreetMatchDetailsViewModel()
        matchDetailsVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        matchDetailsVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        matchDetailsVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if response?.response?.data != nil{
                    self?.matchDetails = response!.response!.data
                }
                self?.fillDetails()
            })
            .store(in: &cancellable)
    }
    
    
    
    func makeNetworkCall(){
        matchDetailsVM?.fetchStreetMatchDetailsAsyncCall(id: matchID!)
    }
    

    func fillDetails(){
        lblLocation.text = matchDetails?.address
        lblHome.text = matchDetails?.homeTeam?.name
        imgHome.setImage(imageStr: matchDetails?.homeTeam?.logoImgURL ?? "")
        imgAway.setImage(imageStr: matchDetails?.awayTeam?.logoImgURL ?? "")
        lblAway.text = matchDetails?.awayTeam?.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.yyyyMMddHHmmss.rawValue
        if let dt1 = dateFormatter.date(from: matchDetails?.scheduleTime ?? "") {
            lblTime.text = dt1.formatDate(outputFormat: .ddMMMyyyyhmma)
        }
        tableViewHomeLineup.reloadData()
        tableViewAwayLineup.reloadData()
        if UserDefaults.standard.language == "zh"{
            lblHome.text = matchDetails?.homeTeam?.nameCN
            lblAway.text = matchDetails?.awayTeam?.nameCN
        }
    }
}


extension StreetMatchesDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewHomeLineup{
            return matchDetails?.homeTeam?.players?.count ?? 0
        }
        else{
            return matchDetails?.awayTeam?.players?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchPlayerTableViewCell) as! StreetMatchPlayerTableViewCell
        var obj:StreetMatchPlayer?
        if tableView == tableViewHomeLineup{
            obj = matchDetails?.homeTeam?.players?[indexPath.row]
        }
        else{
            obj = matchDetails?.awayTeam?.players?[indexPath.row]
        }
        cell.configureCell(obj: obj)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player:StreetMatchPlayer?
        if tableView == tableViewHomeLineup{
            player = matchDetails?.homeTeam?.players?[indexPath.row]
        }
        else{
            player = matchDetails?.awayTeam?.players?[indexPath.row]
        }
        navigateToViewController(StreetPlayerProfileViewController.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.isOtherPlayer = true
            vc.userID = player?.userID
            vc.playerID = player?.playerID
        }
    }
   
   
}
