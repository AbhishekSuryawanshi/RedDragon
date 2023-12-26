//
//  PlayerDetailMediaViewController.swift
//  RedDragon
//
//  Created by Ali on 11/8/23.
//

import UIKit
import SDWebImage
import YouTubePlayerKit

class PlayerDetailMediaViewController: UIViewController {

    @IBOutlet weak var mediaViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaTopView: PlayerDetailsTopView!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    var playerDetailViewModel: PlayerDetailViewModel?
    var isFromSeeAll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFromSeeAll{
            backBtnHeightConstraint.constant = 0
            mediaViewTopConstraint.constant = 0
            
        }
        else{
            backBtnHeightConstraint.constant = 30
            mediaViewTopConstraint.constant = 120
           
        }
        configureView()
    }
    
    @objc func playVideo(sender: UIButton){
        let video = playerDetailViewModel?.responseData?.data?.medias?[sender.tag].video ?? ""
        let configuration = YouTubePlayer.Configuration(
            // Define which fullscreen mode should be used (system or web)
            fullscreenMode: .system,
            // Custom action to perform when a URL gets opened
           
            // Enable auto play
            autoPlay: true,
            // Hide controls
            showControls: true,
            // Enable loop
            loopEnabled: true
        )
        let youTubePlayer = YouTubePlayer(
            source: .url(video),
            configuration: configuration
        )
        
        let youTubePlayerViewController = YouTubePlayerViewController(
            player: youTubePlayer
        )
        self.present(youTubePlayerViewController, animated: true)
        
    }
    
    
    func configureView() {
        loadFunctionality()
        
        self.mediaCollectionView.reloadData()
        
    }
    
    func loadFunctionality() {
        nibInitialization()
        configureTopView()
    }
    
    func nibInitialization() {
        mediaCollectionView.register(CellIdentifier.playerMediaCollectionViewCell)
       
    }
    func configureTopView(){
        if playerDetailViewModel?.responseData?.data?.medias?.count ?? 0 > 0{
            mediaTopView.dateLbl.text = playerDetailViewModel?.responseData?.data?.medias?[0].date
            mediaTopView.mediaImg.sd_imageIndicator = SDWebImageActivityIndicator.white
            mediaTopView.mediaImg.sd_setImage(with: URL(string: playerDetailViewModel?.responseData?.data?.medias?[0].preview ?? ""))
            mediaTopView.mediaDetailTxtView.text = playerDetailViewModel?.responseData?.data?.medias?[0].subtitle
            mediaTopView.mediaTitleLbl.text = playerDetailViewModel?.responseData?.data?.medias?[0].title
            mediaTopView.playBtn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PlayerDetailMediaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerDetailViewModel?.responseData?.data?.medias?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.playerMediaCollectionViewCell, for: indexPath) as! PlayerDetailsMediaCollectionViewCell
        cell.dateLbl.text = playerDetailViewModel?.responseData?.data?.medias?[indexPath.row].date
        cell.mediaDetailTxtView.text = playerDetailViewModel?.responseData?.data?.medias?[indexPath.row].subtitle
        cell.mediaImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.mediaImgView.sd_setImage(with: URL(string: playerDetailViewModel?.responseData?.data?.medias?[indexPath.row].preview ?? ""))
        cell.mediaDetailTitle.text = playerDetailViewModel?.responseData?.data?.medias?[indexPath.row].title
        cell.playBtn.tag = indexPath.row
        cell.playBtn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
        
    }
    
}
