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
    @IBOutlet weak var publishersView: UIView!
    @IBOutlet weak var publisherCollectionView: UICollectionView!
    @IBOutlet weak var leaguesView: UIView!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    @IBOutlet weak var trendingView: UIView!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var newsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var videosView: UIView!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionHeightConstraint: NSLayoutConstraint!
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initialSettings() {
        nibInitialization()
        
        /// breakng news view
        /// label text set in api response function
        topMarqueeLabel.type = .continuous
        topMarqueeLabel.speed = .rate(50)
        topMarqueeLabel.animationCurve = .linear
        // topMarqueeLabel.fadeLength = 10.0
        
        breakngNewsImage.zoomAnimation()
        
        fetchSocialViewModel()
        fetchGossipViewModel()
        
        SocialPublicLeagueVM.shared.fetchLeagueListAsyncCall()
        GossipVideoListVM.shared.fetchVideosAsyncCall()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchEnable(notification:)), name: .newsSearch, object: nil)
    }
    
    func nibInitialization() {
        publisherCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        leagueCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        trendingCollectionView.register(CellIdentifier.newsCollectionViewCell)
        newsTableView.register(CellIdentifier.newsTableViewCell)
        videosCollectionView.register(CellIdentifier.newsCollectionViewCell)
    }
    
    @objc func searchEnable(notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            let text = dict["text"] as? String ?? ""
            
            if text.count > 0 {
                leagueArray = SocialPublicLeagueVM.shared.leagueArray
                leagueArray = leagueArray.filter({(item: SocialLeague) -> Bool in
                    if item.enName.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }
                    if item.cnName.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }
                    return false
                })
                leaguesView.isHidden = leagueArray.count == 0
                gossipsArray = GossipListVM.shared.gossipsArray
                gossipsArray = gossipsArray.filter({(item: Gossip) -> Bool in
                    if item.title?.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }
                    return false
                })
                videoArray = GossipVideoListVM.shared.videoList
                videoArray = videoArray.filter({(item: GossipVideo) -> Bool in
                    if item.title.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }
                    return false
                })
                trendingArray.removeAll()
                leaguesView.isHidden = leagueArray.count == 0
                viewAllButton.isHidden = true
                trendingCollectionView.reloadData()
                newsTableView.reloadData()
            } else {
                
                leagueArray = SocialPublicLeagueVM.shared.leagueArray
                videoArray = GossipVideoListVM.shared.videoList
                loadGossipData(showEsportdata: sportType == .eSports)
            }
            publishersView.isHidden = !(sportType != .eSports && text.count == 0)
            leagueCollectionView.reloadData()
            videosCollectionView.reloadData()
            newsTableView.setContentOffset(.zero, animated: true)
        }
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
        ///If sportType == .eSports, ESports model array else Gossip model array
        ///ESports model to gossip model conversion doing in the api response function
        publishersView.isHidden = sportType == .eSports
        
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
                SocialPublicLeagueVM.shared.leagueArray = response ?? []
                self?.leagueArray = SocialPublicLeagueVM.shared.leagueArray
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
        GossipListVM.shared.displayLoader = { [weak self] value in
            value ? self?.startLoader() : stopLoader()
        }
        
        ///fetch esports news list
        ESportsListVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        ESportsListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onESportsResponseData(response?.newsList ?? [])
            })
            .store(in: &cancellable)
        ESportsListVM.shared.displayLoader = { [weak self] value in
            value ? self?.startLoader() : stopLoader()
        }
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
        ///api has pagination
        publishersArray = response?.source ?? []
        
        if self.pageNum == 1 {
            gossipsArray.removeAll()
            trendingArray.removeAll()
            GossipListVM.shared.gossipsArray.removeAll()
        }
        
        if (response?.data?.data ?? []).count > 0 {
            GossipListVM.shared.gossipsArray.append(contentsOf: response?.data?.data ?? [])
            loadGossipData(showEsportdata: false)
        } else {
            loadGossipData(showEsportdata: false)
        }
    }
    
    func execute_onESportsResponseData(_ response: [ESports]) {
        ///api has no pagination
        GossipListVM.shared.gossipsArray.removeAll()
        
        /// make Gossip model from ESports model
        /// update id, title, mediasource
        
        for eSportModel in response {
            var gossipModel = Gossip()
            gossipModel.id = eSportModel.id
            gossipModel.title = eSportModel.articalTitle
            gossipModel.mediaSource = [URLConstants.eSportsBaseURL + eSportModel.articalThumbnailImage]
            GossipListVM.shared.gossipsArray.append(gossipModel)
        }
        loadGossipData(showEsportdata: true)
    }
    
    func loadGossipData(showEsportdata: Bool) {
        gossipsArray = GossipListVM.shared.gossipsArray
        topMarqueeLabel.text = gossipsArray.reversed().map({$0.title ?? ""}).joined(separator: "   *   ")
        /// Show 5 news of gossip array in trending topic section
        trendingArray = Array(gossipsArray.prefix(5))
        /// shuffle gossip array to avoid repeat content on "trending topic" and "news category"
        GossipListVM.shared.gossipsArray = GossipListVM.shared.gossipsArray.shuffled()
        /// Show 3 news of gossip array, and show all news if "see All" button tapped
        if showEsportdata {
            gossipsArray = Array(GossipListVM.shared.gossipsArray.prefix(3))
        } else {
            if !self.isPagination {
                gossipsArray = Array(GossipListVM.shared.gossipsArray.prefix(3))
            }
            self.isPagination = false
        }
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
            videoCollectionHeightConstraint.constant = CGFloat(((videoArray.count / 2) + 1) * 160)
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
            cell.configureGossipImageCell(model: trendingArray[indexPath.row])
            return cell
        } else if collectionView == videosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.newsCollectionViewCell, for: indexPath) as! NewsCollectionViewCell
            cell.configureGossipVideoCell(model: videoArray[indexPath.row])
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
        }  else if collectionView == videosCollectionView {
            return CGSize(width: (screenWidth / 2) - 20, height: 160)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}

// MARK: - TableView Delegates
extension GossipVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// news category section's table height calculation
        /// If count = 0, height = 70 to show "No data" label
        /// maximum height of table sould be 20 * cell height, if more than 20 items are there, do pagination
        if gossipsArray.count < 20 {
            newsTableHeightConstraint.constant = (gossipsArray.count * 70) < 70 ? 300 : CGFloat(gossipsArray.count * 120)
        } else {
            newsTableHeightConstraint.constant = CGFloat(20 * 120)
        }
        
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

// MARK: - ScrollView Delegates
extension GossipVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.newsTableView && sportType != .eSports {
            if(scrollView.contentOffset.y>0 && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
                if(isPagination == false){
                    isPagination = true
                    pageNum = pageNum + 1
                    self.getNewsList()
                }
            }
        }
    }
}
