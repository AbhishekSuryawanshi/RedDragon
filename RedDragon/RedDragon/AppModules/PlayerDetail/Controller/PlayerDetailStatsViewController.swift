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
    var playerDetailViewModel: PlayerDetailViewModel?
    var playerDetailStats: PlayerDetailStatistic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
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
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        leaguesCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)

    }
    
}

extension PlayerDetailStatsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return playerDetailStats?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.playerStatsTableViewCell, for: indexPath) as! PlayerStatsTableViewCell
        cell.playerDetailStatsDataArr = playerDetailStats?.data?[indexPath.section]
        switch(indexPath.section){
        case 0:
            cell.contentView.backgroundColor = UIColor.init(hex: "FFDAD5")
            cell.colorLbl = "BB1910"
           
        case 1:
            cell.contentView.backgroundColor = UIColor.init(hex: "FFE08A")
            cell.colorLbl = "745B00"
            
        case 2:
            cell.contentView.backgroundColor = UIColor.init(hex: "C6E7FF")
            cell.colorLbl = "00658C"
        case 3:
            cell.contentView.backgroundColor = UIColor.init(hex: "FFDAD5")
            cell.colorLbl = "BB1910"
        case 4:
            cell.contentView.backgroundColor = UIColor.init(hex: "FFE08A")
            cell.colorLbl = "745B00"
        case 5:
            cell.contentView.backgroundColor = UIColor.init(hex: "C6E7FF")
            cell.colorLbl = "00658C"
        default:
            cell.contentView.backgroundColor = UIColor.init(hex: "FFDAD5")
            cell.colorLbl = "BB1910"
        }
        cell.isFour = indexPath.section != 0
        cell.sectionCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = playerDetailStats?.data?[indexPath.section].data?.count
        var col = 4
        var rows = 0
        if indexPath.section == 0{
           col = 3
           
        }
        rows = Int((Double(count ?? 0) / Double(col)).rounded(.up))
        let width = ((tableView.frame.width) - 20) / CGFloat(col)
        var height = width * (9/16)
        if indexPath.section == 0{
            return CGFloat(height * CGFloat(rows))
        }
        else{
            height = width
            return CGFloat(height * CGFloat(rows))
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = PlayerStatsTableViewHeader()
        header.headerLbl.text = " \(playerDetailStats?.data?[section].section ?? "") "
         switch(section){
         case 0:
             header.backgroundColor = UIColor.init(hex: "FFDAD5")
             header.headerLbl.backgroundColor = UIColor.init(hex: "BB1910")
         case 1:
             header.backgroundColor = UIColor.init(hex: "FFE08A")
             header.headerLbl.backgroundColor = UIColor.init(hex: "745B00")
         case 2:
             header.backgroundColor = UIColor.init(hex: "C6E7FF")
             header.headerLbl.backgroundColor = UIColor.init(hex: "00658C")
         case 3:
             header.backgroundColor = UIColor.init(hex: "FFDAD5")
             header.headerLbl.backgroundColor = UIColor.init(hex: "BB1910")
         case 4:
             header.backgroundColor = UIColor.init(hex: "FFE08A")
             header.headerLbl.backgroundColor = UIColor.init(hex: "745B00")
         case 5:
             header.backgroundColor = UIColor.init(hex: "C6E7FF")
             header.headerLbl.backgroundColor = UIColor.init(hex: "00658C")
         default:
             header.backgroundColor = UIColor.init(hex: "FFDAD5")
             header.headerLbl.backgroundColor = .red
             header.headerLbl.textColor = .white
         }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27
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

