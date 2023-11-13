//
//  PlayerDetailViewController.swift
//  RedDragon
//
//  Created by Ali on 11/1/23.
//

import UIKit


class PlayerDetailViewController: UIViewController {
    
    var playerDetailsArr = ["Profile", "Matches", "Stats", "Media"]

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var playerDetailCollectionView: UICollectionView!
    private var tabViewControllers: [UIViewController] = []
    
    
    @IBOutlet weak var playerProfileView: PlayerProfileTopView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }
    
    func loadFunctionality() {
        nibInitialization()
        playerTabsData()
      //  configureUI()
      //  fetchMatchDetailsViewModel()
      //  makeNetworkCall()
    }
    
    func nibInitialization() {
        playerDetailCollectionView.register(CellIdentifier.matchTabsCollectionViewCell)
       
    }
    
    func playerTabsData() {
        playerDetailsArr = [StringConstants.profile.localized,
                          StringConstants.matches.localized,
                          StringConstants.stats.localized,
                          StringConstants.media.localized]
        
        tabViewControllers = [PlayerDetailProfileViewController(),
                              PlayerDetailMatchesViewController(),
                              PlayerDetailStatsViewController(),
                              PlayerDetailMediaViewController()]
    }
    
    
    
    
}

extension PlayerDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerDetailsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.matchTabsCollectionViewCell, for: indexPath) as! MatchTabsCollectionViewCell
        cell.tabNameLabel.text = playerDetailsArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 30)
        }
    
}
