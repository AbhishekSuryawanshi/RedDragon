//
//  UpComingMatchesViewController.swift
//  RedDragon
//
//  Created by Ali on 11/22/23.
//

import UIKit
import SDWebImage

class UpComingMatchesViewController: UIViewController {

    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var upcomingMatchesTableView: UITableView!
    
    var dateArr = ["Today", "Tomorrow", "Day3", "Day4", "Day5"]
    var predictionMatchesModel: PredictionMatchesModel?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFunctionality()
        upcomingMatchesTableView.reloadData()
    }
    
    func loadFunctionality() {
        nibInitialization()
      //  configureUI()
    }
    
    func nibInitialization() {
        dateCollectionView.register(CellIdentifier.homeTitleCollectionVc)
        upcomingMatchesTableView.register(CellIdentifier.predictUpcomingTableViewCell)
        dateCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
       
    }
    
}

extension UpComingMatchesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.homeTitleCollectionVc, for: indexPath) as! HomeTitleCollectionVc
        cell.titleLable.text = dateArr[indexPath.row]
        return cell
    }
    
    
}

extension UpComingMatchesViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return predictionMatchesModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionMatchesModel?.data?[section].matches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictUpcomingTableViewCell, for: indexPath) as! PredictUpcomingTableViewCell
        cell.team1Lbl.text = predictionMatchesModel?.data?[indexPath.section].matches?[indexPath.row].homeTeam
        cell.team2Lbl.text = predictionMatchesModel?.data?[indexPath.section].matches?[indexPath.row].awayTeam
        cell.dateTimeLbl.text = predictionMatchesModel?.data?[indexPath.section].matches?[indexPath.row].time
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PredictUpcomingHeaderView()
        headerView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        headerView.leagueImgView.sd_setImage(with: URL(string: predictionMatchesModel?.data?[section].logo ?? ""))
        headerView.leagueNameLbl.text = predictionMatchesModel?.data?[section].league
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    
    
}
