//
//  PlayerStatsTableViewCell.swift
//  RedDragon
//
//  Created by Ali on 11/16/23.
//

import UIKit

class PlayerStatsTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionCollectionView: UICollectionView!
    
    var playerDetailStatsDataArr: PlayerDetailStatisticData?
    var isFour = false
    
    
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

extension PlayerStatsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerDetailStatsDataArr?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.playerStatsCollectionViewCell, for: indexPath) as! PlayerStatsCollectionViewCell
        cell.valueLbl.text = playerDetailStatsDataArr?.data?[indexPath.row].value
        cell.keyLbl.text = playerDetailStatsDataArr?.data?[indexPath.row].key
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isFour{
            let width = ((collectionView.frame.width) / 4) - 20
            let height = width
            
            return CGSize(width: width, height: height)
        }
        else{
            let width = ((collectionView.frame.width) / 3) - 20
            let height = width * (9/16)
            
            return CGSize(width: width, height: height)
        }
        
    }
    
    
    
}
