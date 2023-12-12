//
//  GossipVC.swift
//  RedDragon
//
//  Created by Qasr01 on 27/11/2023.
//

import UIKit
import Combine
import MarqueeLabel

class GossipVC: UIViewController {
    
    @IBOutlet weak var breakngNewsImage: UIImageView!
    @IBOutlet weak var topMarqueeLabel: MarqueeLabel!
    @IBOutlet weak var publisherCollectionView: UICollectionView!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    @IBOutlet weak var trendingView: UIView!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var newsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var videosView: UIView!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    
    var cancellable = Set<AnyCancellable>()
    var isPagination = false
    var publishersArray: [String] = []
    var leagueArray: [SocialLeague] = []
    var gossipsArray: [Gossip] = []
    var trendingArray: [Gossip] = []
    var videoArray: [GossipVideo] = []
    
    var sportType: SportsType = .football
    var newsSource = "thehindu"
    var pageNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    override func viewDidAppear(_ animated: Bool) {
        /// "thehindu" default value
        getNewsList()
    }
    func initialSettings() {
        nibInitialization()
        
        /// breakng news view
        topMarqueeLabel.text = "......comng soon....."
        topMarqueeLabel.type = .continuous
        topMarqueeLabel.speed = .duration(5)
        topMarqueeLabel.animationCurve = .linear
        topMarqueeLabel.fadeLength = 10.0
        
        breakngNewsImage.zoomAnimation()
        
        fetchSocialViewModel()
        fetchGossipViewModel()
        
        SocialPublicLeagueVM.shared.fetchLeagueListAsyncCall()
       
    }
    
    func nibInitialization() {
        publisherCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        leagueCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        trendingCollectionView.register(CellIdentifier.newsCollectionViewCell)
        newsTableView.register(CellIdentifier.newsTableViewCell)
    }
    
    // MARK: - Button Actions
    
    @IBAction func viewAllButtonTapped(_ sender: UIButton) {
        viewAllButton.isHidden = true
        gossipsArray = GossipListVM.shared.gossipsArray
        newsTableView.reloadData()
    }
}

// MARK: - API Services
extension GossipVC {
    func getNewsList() {
        if sportType == .eSports {
            ESportsListVM.shared.fetchESportsListAsyncCall()
        } else {
            let param: [String: Any] = [
                "page": pageNum,
                "source": newsSource,
                "category": sportType.sourceNewsKey
            ]
            GossipListVM.shared.fetchNewsListAsyncCall(params: param)
        }
    }
        
    func fetchSocialViewModel() {
        ///fetch public league list / euro 5 league
        SocialPublicLeagueVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialPublicLeagueVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.leagueArray = response ?? []
                self?.leagueCollectionView.reloadData()
             })
            .store(in: &cancellable)
    }
    
    func fetchGossipViewModel() {
        ///fetch news list
        GossipListVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        GossipListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onGossipsResponseData(response)
            })
            .store(in: &cancellable)
        
        ///fetch esports news list
        ESportsListVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        ESportsListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                GossipVideoListVM.shared.fetchVideosAsyncCall()
            })
            .store(in: &cancellable)
        
        ///fetch videos list
        GossipVideoListVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        GossipVideoListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                GossipVideoListVM.shared.videoList = response?.data ?? []
                self?.videoArray = GossipVideoListVM.shared.videoList
                self?.videosCollectionView.reloadData()
            })
            .store(in: &cancellable)
    }
    
    func execute_onGossipsResponseData(_ response: GossipListResponse?) {
        publishersArray = response?.source ?? []
        
        if self.pageNum == 1 {
            gossipsArray.removeAll()
            GossipListVM.shared.gossipsArray.removeAll()
        }
        
        if (response?.data?.data ?? []).count > 0 {
            self.gossipsArray.append(contentsOf: response?.data?.data ?? [])
            GossipListVM.shared.gossipsArray = self.gossipsArray
            self.isPagination = false
        }
        /// Show 5 news of gossip array in trending topic section
        trendingArray = Array(gossipsArray.prefix(5))
        /// shuffle gossip array to avoid repeat content on "trending topic" and "news category"
        GossipListVM.shared.gossipsArray = GossipListVM.shared.gossipsArray.shuffled()
        /// Show 3 news of gossip array, and show all news if "see All" button tapped
        gossipsArray = Array(GossipListVM.shared.gossipsArray.prefix(3))
        viewAllButton.isHidden = gossipsArray.count == 0
        publisherCollectionView.reloadData()
        trendingCollectionView.reloadData()
        newsTableView.reloadData()
    }
}


// MARK: - CollectionView Delegates
extension GossipVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == publisherCollectionView {
            if publishersArray.count == 0 {
                collectionView.setEmptyMessage(ErrorMessage.dataNotFound)
            } else {
                collectionView.restore()
            }
            return publishersArray.count
        } else if collectionView == leagueCollectionView {
            if leagueArray.count == 0 {
                collectionView.setEmptyMessage(ErrorMessage.leaguesEmptyAlert)
            } else {
                collectionView.restore()
            }
            return leagueArray.count
        }  else if collectionView == trendingCollectionView {
            trendingView.isHidden = trendingArray.count == 0
            return trendingArray.count
        }  else if collectionView == videosCollectionView {
            videosView.isHidden = videoArray.count == 0
            return videoArray.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == publisherCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let publisher = publishersArray[indexPath.row].getNewsSource()
            cell.configure(title: publisher.0, iconImage: publisher.1)
            return cell
        } else if collectionView == leagueCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let model = leagueArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, imageWidth: (0.7 * 60), placeHolderImage: .placeholderLeague)
            return cell
        } else if collectionView == trendingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.newsCollectionViewCell, for: indexPath) as! NewsCollectionViewCell
            cell.configureGossipCell(model: trendingArray[indexPath.row])
            return cell
        } else if collectionView == videosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.newsCollectionViewCell, for: indexPath) as! NewsCollectionViewCell
            cell.configureGossipCell(model: trendingArray[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension GossipVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == publisherCollectionView {
            pageNum = 1
            newsSource = publishersArray[indexPath.row]
            getNewsList()
        }
    }
}

extension GossipVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == publisherCollectionView || collectionView == leagueCollectionView {
            return CGSize(width: 75, height: 112)
        } else if collectionView == trendingCollectionView {
            return CGSize(width: screenWidth * 0.7, height: 240)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}

// MARK: - TableView Delegates
extension GossipVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        newsTableHeightConstraint.constant = CGFloat(gossipsArray.count * 120)
        if gossipsArray.count == 0 {
            tableView.setEmptyMessage(ErrorMessage.dataNotFound)
        } else {
            tableView.restore()
        }
        return gossipsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newsTableViewCell, for: indexPath) as! NewsTableViewCell
        cell.configureGossipCell(model: gossipsArray[indexPath.row])
        return cell
    }
}
  
extension GossipVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
