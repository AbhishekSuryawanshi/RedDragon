//
//  PlayerDetailStatsViewController.swift
//  RedDragon
//
//  Created by Ali on 11/8/23.
//

import UIKit

class PlayerDetailStatsViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var leaguesCollectionView: UICollectionView!
//    @IBOutlet weak var sixthViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var sixthCollectionViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var sixthLbl: UILabel!
//    @IBOutlet weak var sixthCollectionView: UICollectionView!
//    @IBOutlet weak var sixthView: UIView!
//    @IBOutlet weak var fifthCollectionViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var fifthViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var fifthLbl: UILabel!
//    @IBOutlet weak var fifthCollectionView: UICollectionView!
//    @IBOutlet weak var fifthView: UIView!
//    @IBOutlet weak var forthCollectionViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var forthViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var forthLbl: UILabel!
//    @IBOutlet weak var forthCollectionView: UICollectionView!
//    @IBOutlet weak var forthView: UIView!
//    @IBOutlet weak var thirdLbl: UILabel!
//    @IBOutlet weak var thirdCollectionViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var thirdCollectionView: UICollectionView!
//    @IBOutlet weak var thirdView: UIView!
//    @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var secondLbl: UILabel!
//    @IBOutlet weak var secondCollectionViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var secondCollectionView: UICollectionView!
//    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var secondView: UIView!
//    @IBOutlet weak var firstLbl: UILabel!
//    @IBOutlet weak var firstCollectionView: UICollectionView!
//    @IBOutlet weak var firstCollectionViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var firstView: UIView!
//    
    var playerDetailViewModel: PlayerDetailViewModel?
    var playerDetailStats: PlayerDetailStatistic?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configureView() {
        playerDetailStats = playerDetailViewModel?.responseData?.data?.statistics?[0]
        loadFunctionality()
       
    }

    func loadFunctionality() {
        nibInitialization()
    }
    
    func nibInitialization() {
        leaguesCollectionView.register(CellIdentifier.playerLeagueCollectionViewCell)
        mainTableView.register(CellIdentifier.playerStatsTableViewCell)
        
    }
    
}

extension PlayerDetailStatsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return playerDetailStats?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerDetailViewModel?.responseData?.data?.statistics?[section].data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.playerStatsTableViewCell, for: indexPath) as! PlayerStatsTableViewCell
        cell.playerDetailStats = playerDetailStats
        cell.sectionCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = PlayerStatsTableViewHeader()
        header.headerLbl.text = playerDetailStats?.data?[section].section
        header.headerLbl.backgroundColor = .red
        header.headerLbl.textColor = .white
        return header
    }
    
        
}

extension PlayerDetailStatsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerDetailViewModel?.responseData?.data?.statistics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.playerLeagueCollectionViewCell, for: indexPath) as! PlayerLeaguesCollectionViewCell
        cell.leagueNameLbl.text = playerDetailViewModel?.responseData?.data?.statistics?[indexPath.row].league
            
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playerDetailStats = playerDetailViewModel?.responseData?.data?.statistics?[indexPath.row]
        mainTableView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50)
        
    }
    
}
