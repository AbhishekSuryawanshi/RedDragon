//
//  PlayerDetailMatchesViewController.swift
//  RedDragon
//
//  Created by Ali on 11/7/23.
//

import UIKit
import SDWebImage

class PlayerDetailMatchesViewController: UIViewController {

    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var matchesTableView: UITableView!
    
    var playerDetailViewModel: PlayerDetailViewModel?
    var isFromSeeAll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFromSeeAll{
            backBtnHeightConstraint.constant = 0
            tableViewTopConstraint.constant = 0
        }
        else{
            backBtnHeightConstraint.constant = 30
            tableViewTopConstraint.constant = 100
        }
        configureView()
    }
    
    func configureView() {
        loadFunctionality()
        self.matchesTableView.reloadData()
        
    }
    
    func loadFunctionality() {
        nibInitialization()
    }
    
    func nibInitialization() {
        matchesTableView.register(CellIdentifier.matchesTableViewCell)
       
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PlayerDetailMatchesViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return playerDetailViewModel?.responseData?.data?.events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerDetailViewModel?.responseData?.data?.events?[section].matches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.matchesTableViewCell, for: indexPath) as! MatchesTableViewCell
        cell.roundLbl.text = playerDetailViewModel?.responseData?.data?.events?[indexPath.section].matches?[indexPath.row].round
        cell.dateLbl.text = playerDetailViewModel?.responseData?.data?.events?[indexPath.section].matches?[indexPath.row].date
        cell.team1TeamLbl.text = playerDetailViewModel?.responseData?.data?.events?[indexPath.section].matches?[indexPath.row].homeName
        cell.team2Lbl.text = playerDetailViewModel?.responseData?.data?.events?[indexPath.section].matches?[indexPath.row].awayName
        cell.team1ScoreLbl.text = playerDetailViewModel?.responseData?.data?.events?[indexPath.section].matches?[indexPath.row].homeScore
        cell.team2ScoreLbl.text = playerDetailViewModel?.responseData?.data?.events?[indexPath.section].matches?[indexPath.row].awayScore
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MatchesHeaderView()
        headerView.headerImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        headerView.headerImgView.sd_setImage(with: URL(string: playerDetailViewModel?.responseData?.data?.events?[section].leagueLogo ?? ""))
        headerView.headerLbl.text = playerDetailViewModel?.responseData?.data?.events?[section].leagueName
        
        return headerView
    }
    
    
}
