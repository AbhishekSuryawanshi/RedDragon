//
//  ExpertUserListTableViewCell.swift
//  RedDragon
//
//  Created by iOS Dev on 14/12/2023.
//

import UIKit

class PredictUserListTableViewCell: UITableViewCell {
    @IBOutlet weak var winRateTitleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var allCountLabel: UILabel!
    @IBOutlet weak var successCountLabel: UILabel!
    @IBOutlet weak var unsuccessCountLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var wonPointsLabel: UILabel!
    @IBOutlet weak var lostPointsLabel: UILabel!
    @IBOutlet weak var pendingPointsLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var betPointsStackView: UIStackView!
    @IBOutlet weak var followStackView: UIStackView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var data = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagCollectionView.register(CellIdentifier.userTagsCollectionViewCell)
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureTagCollectionData(data: [String]) {
        self.data = data
        tagCollectionView.reloadData()
    }
    
    func configureUI() {
        winRateTitleLabel.text = "Win Rate".localized
        followButton.setTitle("Follow".localized, for: .normal)
        followingButton.setTitle("Following".localized, for: .normal)
    }
}

extension PredictUserListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionCell(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2)-10, height: 30)
    }
}

extension PredictUserListTableViewCell {
    private func collectionCell(indexPath:IndexPath) -> UserTagsCollectionViewCell {
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.userTagsCollectionViewCell, for: indexPath) as! UserTagsCollectionViewCell
        cell.tagLabel.text = data[indexPath.row]
        return cell
    }
}
