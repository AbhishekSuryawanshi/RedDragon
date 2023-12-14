//
//  NewsVideoTableViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 11/12/2023.
//

import UIKit
import AVKit

final class NewsVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var videoCollectionView: UICollectionView!
    
    var model: NewsVideoModel! {
        didSet {
            videoCollectionView.reloadData()
        }
    }
    
    var playButtonAction: ((_ vc: AVPlayerViewController) -> Void)?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        videoCollectionView.dataSource = self
        videoCollectionView.delegate = self
        videoCollectionView.register(
            NewsVideoCollectionViewCell.nib_Name,
            forCellWithReuseIdentifier: NewsVideoCollectionViewCell.reuseIdentifier
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with model: NewsVideoModel) {
        self.model = model
    }
    
}

extension NewsVideoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = videoCollectionView.dequeueReusableCell(
            withReuseIdentifier: NewsVideoCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? NewsVideoCollectionViewCell,
              let list = model.list else { return UICollectionViewCell() }
        
        cell.configureCell(with: NewsVideoCollectionCellViewModel(model: list[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = model.list?[indexPath.row].cfHLSURL, let videoURL = URL(string: url) else { return }
        
        let player = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        playButtonAction!(playerController)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 8)/2, height: 135)
    }

}
