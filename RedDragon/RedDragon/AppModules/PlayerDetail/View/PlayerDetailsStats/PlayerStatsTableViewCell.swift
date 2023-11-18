//
//  PlayerStatsTableViewCell.swift
//  RedDragon
//
//  Created by Ali on 11/16/23.
//

import UIKit

class PlayerStatsTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionCollectionView: UICollectionView!
    
    var playerDetailStats: PlayerDetailStatistic?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadFunctionality()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadFunctionality() {
        nibInitialization()
       
    }
    
    func nibInitialization() {
        sectionCollectionView.register(CellIdentifier.playerStatsCollectionViewCell)
        
       
    }
    
}

extension PlayerStatsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerDetailStats?.data?[section].data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.playerStatsCollectionViewCell, for: indexPath) as! PlayerStatsCollectionViewCell
        cell.valueLbl.text = playerDetailStats?.data?[indexPath.section].data?[indexPath.row].value
        cell.keyLbl.text = playerDetailStats?.data?[indexPath.section].data?[indexPath.row].key
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50)
        
    }
    
    
    
}
