//
//  InfoVC.swift
//  RedDragon
//
//  Created by iOS Dev on 13/12/2023.
//

import UIKit
import Hero
import Toast
import Combine
import SDWebImage

class InfoVC: UIViewController {
    
    @IBOutlet weak var firstStaticDataView: UIView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var socialLabel: UILabel!
    @IBOutlet weak var fantasyLabel: UILabel!
    @IBOutlet weak var quizLabel: UILabel!
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var updatesLabel: UILabel!
    @IBOutlet weak var databaseLabel: UILabel!
    @IBOutlet weak var analysisLabel: UILabel!
    @IBOutlet weak var usersLabel: UILabel!
    @IBOutlet weak var meetAppLabel: UILabel!
    @IBOutlet weak var streetMatchLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var expertLabel: UILabel!
    @IBOutlet weak var cardsLabel: UILabel!
    
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var saveUptoLabel: UILabel!
    @IBOutlet weak var packageSeeAllButton: UIButton!
    @IBOutlet weak var firstPointsLabel: UILabel!
    @IBOutlet weak var firstPriceLabel: UILabel!
    @IBOutlet weak var secondPonitsLabel: UILabel!
    @IBOutlet weak var secondPriceLabel: UILabel!
    @IBOutlet weak var thirdPointsLabel: UILabel!
    @IBOutlet weak var thirdPriceLabel: UILabel!
    @IBOutlet weak var fourthPointsLabel: UILabel!
    @IBOutlet weak var fourthPriceLabel: UILabel!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var topMatchesLabel: UILabel!
    @IBOutlet weak var topMatchesSeeMoreButton: UIButton!
    @IBOutlet weak var topMatchesTableView: UITableView!
    
    @IBOutlet weak var whatsHappeningView: UIView!
    @IBOutlet weak var whatsHappeningLabel: UILabel!
    @IBOutlet weak var whatsHappeningSeeAllButton: UIButton!
    @IBOutlet weak var whatsHappeningTableView: UITableView!
    
    private var cancellable = Set<AnyCancellable>()
    private var bannerVM: BannerViewModel?
    private var liveMatchArray: [GlobalMatchList] = []
    private var gossipVM: GossipListVM?
    private var footballLiveMatchesVM: FootballLiveMatchesViewModel?
    private var gossipsArray: [Gossip] = []
    private var banners_count = 0
    private var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    private func loadFunctionality() {
        topMatchesTableView.register(CellIdentifier.globalMatchesTableViewCell)
        whatsHappeningTableView.register(CellIdentifier.newsTableViewCell)
    }

    @IBAction func appModulesButton(_ sender: UIButton) {
        switch sender.tag {
        case 8:
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[2]
        case 15:
            self.tabBarController?.tabBar.isHidden = true
            navigateToViewController(AllPlayersViewController.self, storyboardName: StoryboardName.cardGame, identifier: "AllPlayersViewController")
        default:
            print("default")
        }
    }
    
    @IBAction func seeAllButton(_ sender: UIButton) {
    }
    
    func configureUI() {
        fetchBannerViewModel()
        fetchLiveMatchViewModel()
        fetchGossipViewModel()
    }
    
}

/// __Fetch View Model
extension InfoVC {
    
    private func fetchBannerViewModel() {
        bannerVM = BannerViewModel()
        bannerVM?.showError = { [weak self] error in
            self?.view.makeToast(ErrorMessage.bannerNotFound.localized, duration: 2.0, position: .center)
        }
        bannerVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        bannerVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.bannerCollectionView.reloadData()
                if self?.banners_count == 0 {
                    self?.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self!, selector: #selector(self?.pageControllerForBanners), userInfo: nil, repeats: true)
                }
            })
            .store(in: &cancellable)
        /// API call for banners
        bannerVM?.fetchBannerDataAsyncCall()
    }
    
    private func fetchLiveMatchViewModel() {
        footballLiveMatchesVM = FootballLiveMatchesViewModel()
        footballLiveMatchesVM?.showError = { [weak self] error in
            self?.view.makeToast(ErrorMessage.liveMatchNotFound.localized, duration: 2.0, position: .center)
        }
        footballLiveMatchesVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        footballLiveMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.liveMatchArray = response?.matchList ?? []
                self?.topMatchesTableView.reloadData()
            })
            .store(in: &cancellable)
        /// API call for Live matches
        footballLiveMatchesVM?.fetchFootballLiveMatches()
    }
    
    private func fetchGossipViewModel() {
        ///fetch news list
        gossipVM = GossipListVM()
        gossipVM?.showError = { [weak self] error in
            self?.view.makeToast(ErrorMessage.whatsHappeningNotFound.localized, duration: 2.0, position: .center)
        }
        gossipVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                //self?.execute_onGossipsResponseData(response)
                self?.gossipsArray = response?.data?.data ?? []
                self?.whatsHappeningTableView.reloadData()
            })
            .store(in: &cancellable)
        /// API call to fetch What's Happing data
        whatsHappingAPICall()
    }
    
    private func whatsHappingAPICall() {
        let param: [String: Any] = [
            "page": 1,
            "source": "thehindu",
            "category": "football"
        ]
        gossipVM?.fetchNewsListAsyncCall(params: param)
    }
    
}

/// __Supportive functions
extension InfoVC {
    
    private func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
}

extension InfoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @objc func pageControllerForBanners() {
        guard let dataCount = bannerVM?.responseData?.data.top.count else { return }
        
        let count = min(dataCount, 3)
        if banners_count < count {
            let index = IndexPath.init(row: banners_count, section: 0)
            bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        } else {
            banners_count = 0
            let index = IndexPath.init(row: banners_count, section: 0)
            bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        }
        banners_count = (banners_count + 1) % dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerVM?.responseData?.data.top.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let banner = bannerVM?.responseData?.data.top else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.bannerCell, for: indexPath) as! BannerCollectionViewCell
        cell.bannerImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.bannerImage.sd_setImage(with: URL(string: URLConstants.bannerBaseURL + banner[indexPath.item].coverPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bannerMesssage = bannerVM?.responseData?.data.top[indexPath.item].message ?? ""
        if bannerMesssage.contains("http") || bannerMesssage.contains("www"){
            guard let url = URL(string: bannerMesssage) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/1 - 0, height: collectionView.bounds.height)
    }
    
}

extension InfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topMatchesTableView {
            if liveMatchArray.count >= 2 {
                return 2
            } else {
                return liveMatchArray.count
            }
        }
        if gossipsArray.count >= 3 {
            return 3
        } else {
            return gossipsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == topMatchesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.globalMatchesTableViewCell, for: indexPath) as! GlobalMatchesTableViewCell
            congifureCell(cell: cell, matches: liveMatchArray[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newsTableViewCell, for: indexPath) as! NewsTableViewCell
        cell.titleLabel.textColor = UIColor(red: 0/255, green: 76/255, blue: 107/255, alpha: 1)
        cell.configureGossipCell(model: gossipsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == whatsHappeningView {
            return 100
        }
        return 90
    }
    
    func congifureCell(cell: GlobalMatchesTableViewCell, matches: GlobalMatchList) {
        cell.leagueImageView.setImage(imageStr: matches.leagueInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.homeImageView.setImage(imageStr: matches.homeInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.awayImageView.setImage(imageStr: matches.awayInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.homeNameLabel.text = matches.homeInfo?.name ?? ""
        cell.awayNameLabel.text = matches.awayInfo?.name ?? ""
        
        cell.leagueNameLabel.text = "\(matches.leagueInfo?.name ?? "") | Round \(matches.round?.round ?? 0)"
        cell.cornerLabel.text = "Corners: \(matches.homeInfo?.cornerScore ?? 0)-\(matches.awayInfo?.cornerScore ?? 0)"
        cell.scoreLabel.text = "Score: \(matches.homeInfo?.homeScore ?? 0)-\(matches.awayInfo?.awayScore ?? 0)"
        cell.halftimeLabel.isHidden = false
        cell.halftimeLabel.text = "Halftime: \(matches.homeInfo?.halfTimeScore ?? 0)-\(matches.awayInfo?.halfTimeScore ?? 0)"
    }
}