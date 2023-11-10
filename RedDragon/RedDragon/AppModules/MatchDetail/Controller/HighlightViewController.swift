//
//  HighlightViewController.swift
//  RedDragon
//
//  Created by QASR02 on 07/11/2023.
//

import UIKit

class HighlightViewController: UIViewController {
    
    @IBOutlet weak var highlightTableView: UITableView!
    @IBOutlet weak var symbolCollectionView: UICollectionView!
    
    private var highlightProgress: [Progress]?
    let symbolIconsArray: [UIImage] = [#imageLiteral(resourceName: "goal"), #imageLiteral(resourceName: "disallowedGoal"), #imageLiteral(resourceName: "substitution"), #imageLiteral(resourceName: "yellowCard"), #imageLiteral(resourceName: "redCard"), #imageLiteral(resourceName: "var"), #imageLiteral(resourceName: "penalty"), #imageLiteral(resourceName: "minutes")]
    let symbolNameArray: [String] = [StringConstants.goal.localized,
                                     StringConstants.disallowed.localized,
                                     StringConstants.substitution.localized,
                                     StringConstants.yellowCard.localized,
                                     StringConstants.redCard.localized,
                                     StringConstants.VAR.localized,
                                     StringConstants.penalty.localized,
                                     StringConstants.minutesAdded.localized]
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        symbolCollectionView.reloadData()
    }
    
    func configureView(progressData: [Progress]?) {
        highlightProgress = progressData
        symbolCollectionView.reloadData()
    }

}

extension HighlightViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.symbolCollectionViewCell, for: indexPath) as! SymbolsCollectionViewCell
        cell.symbolImageView.image = symbolIconsArray[indexPath.item]
        cell.symbolNameLabel.text = symbolNameArray[indexPath.item]
        return cell
    }
}

extension HighlightViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlightProgress?[section].data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let progressData = highlightProgress?[indexPath.section] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.highlightTableViewCell, for: indexPath) as! HighlightTableViewCell
        cell.homeTeamView.isHidden = true
        cell.awayTeamView.isHidden = true
        if progressData.data[indexPath.row].isHome == true {
            cell.homeTeamTimeLabel.text = progressData.data[indexPath.row].time
            cell.homeTeam_mainPlayerNameLabel.text = progressData.data[indexPath.row].mainPlayerName
            cell.homeTeam_subPlayerNameLabel.text = progressData.data[indexPath.row].subPlayerName
        } else if progressData.data[indexPath.row].isHome == false {
            cell.awayTeamTimeLabel.text = progressData.data[indexPath.row].time
            cell.awayTeam_mainPlayerNameLabel.text = progressData.data[indexPath.row].mainPlayerName
            cell.awayTeam_subPlayerNameLabel.text = progressData.data[indexPath.row].subPlayerName
        }
        return cell
    }
}

