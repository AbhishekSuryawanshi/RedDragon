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

class InfoVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var firstStaticDataView: UIView!
    
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
    
    @IBOutlet weak var tagsView: UIView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var topMatchesLabel: UILabel!
    @IBOutlet weak var topMatchesSeeMoreButton: UIButton!
    @IBOutlet weak var topMatchesTableView: UITableView!
    
    @IBOutlet weak var whatsHappeningView: UIView!
    @IBOutlet weak var whatsHappeningLabel: UILabel!
    @IBOutlet weak var whatsHappeningSeeAllButton: UIButton!
    @IBOutlet weak var whatsHappeningTableView: UITableView!
    
    @IBOutlet weak var homePredictionLabel: UILabel!
    @IBOutlet weak var predictionSeeAllButton: UIButton!
    @IBOutlet weak var predictionTabelView: UITableView!
    @IBOutlet weak var predictionViewHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var recommendedSeeAllLabel: UIButton!
    @IBOutlet weak var firstExpertImageView: UIImageView!
    @IBOutlet weak var firstExpertNameLabel: UILabel!
    @IBOutlet weak var firstExpertWinPercentLabel: UILabel!
    @IBOutlet weak var firstWinRateLabel: UILabel!
    
    @IBOutlet weak var secondExpertImageView: UIImageView!
    @IBOutlet weak var secondExpertNameLabel: UILabel!
    @IBOutlet weak var secondExpertWinPercentLabel: UILabel!
    @IBOutlet weak var secondExpertWinRateLabel: UILabel!
    
    @IBOutlet weak var thirdExpertImageView: UIImageView!
    @IBOutlet weak var thirdExpertNameLabel: UILabel!
    @IBOutlet weak var thirdtExpertWinPercentLabel: UILabel!
    @IBOutlet weak var thirdExpertWinRateLabel: UILabel!
    
    @IBOutlet weak var titleLineLabel: UILabel!
    @IBOutlet weak var onAStrakLabel: UILabel!
    @IBOutlet weak var topAccuracyLabel: UILabel!
    @IBOutlet weak var continuesWinningLabel: UILabel!
    
    @IBOutlet weak var expertTableLabel: UILabel!
    @IBOutlet weak var expertSeeAllLabel: UIButton!
    @IBOutlet weak var expertTableView: UITableView!
    @IBOutlet weak var expertTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expertViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constantViewForTags: UIView!
    @IBOutlet weak var constantTagsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constantTagsCollectionView: UICollectionView!
    
    private var cancellable = Set<AnyCancellable>()
    private var bannerVM: BannerViewModel?
    private var tagsVM: TagsViewModel?
    private var liveMatchArray: [GlobalMatchList] = []
    private var gossipVM: GossipListVM?
    private var footballLiveMatchesVM: FootballLiveMatchesViewModel?
    private var gossipsArray: [Gossip] = []
    private var predictionVM: HomePagePredictionVM?
    private var expertPredictUserVM: ExpertPredictUserViewModel?
    private var userArray = [ExpertUser]()
    private var banners_count = 0
    private var timer = Timer()
    var tableViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
        setupConstantTagView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
}

/// __Supportive functions
extension InfoVC {
    
    private func setupConstantTagView() {
        constantViewForTags.isHidden = true
        constantViewForTags.backgroundColor = UIColor(red: 255/255, green: 218/255, blue: 213/255, alpha: 1)
    }
    
    private func loadFunctionality() {
        initializeNibFiles()
    }
    
    private func initializeNibFiles() {
        servicesCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        bannerCollectionView.register(CellIdentifier.bannerCell)
        tagsCollectionView.register(CellIdentifier.leagueNamesCollectionCell)
        topMatchesTableView.register(CellIdentifier.globalMatchesTableViewCell)
        whatsHappeningTableView.register(CellIdentifier.newsTableViewCell)
        predictionTabelView.register(CellIdentifier.predictionTableCell)
        expertTableView.register(CellIdentifier.predictUserListTableViewCell)
        constantTagsCollectionView.register(CellIdentifier.leagueNamesCollectionCell)
    }
    
    func configureUI() {
        loadViewModels()
    }
    
    private func loadViewModels() {
        fetchBannerViewModel()
        fetchTagsViewModel()
        fetchLiveMatchViewModel()
        fetchGossipViewModel()
        fetchPredictionViewModel()
        fetchExpertViewModel()
        expertDataAPICall()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check if tags view is not visible on the screen
        self.constantViewForTags.isHidden = isViewVisibleOnScreen(tagsView)
    }
    
    // Helper function to check if a view is visible on the screen
    private func isViewVisibleOnScreen(_ view: UIView) -> Bool {
        let rect = view.convert(view.bounds, to: nil)
        return rect.intersects(view.window?.bounds ?? CGRect.zero)
    }
    
    private func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func highlightFirstIndex_collectionView(item: Int = 0) {
        let indexPath = IndexPath(item: item, section: 0)
        tagsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        constantTagsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
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
    
    private func tableCell(indexPath:IndexPath) -> PredictUserListTableViewCell {
        let cell = expertTableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictUserListTableViewCell, for: indexPath) as! PredictUserListTableViewCell
        
        cell.aboutLabel.text = userArray[indexPath.row].about
        cell.userImageView.setImage(imageStr: userArray[indexPath.row].profileImg ?? "", placeholder: .placeholderUser)
        cell.walletButton.setTitle("\(userArray[indexPath.row].wallet ?? 0)", for: .normal)
        cell.configureTagCollectionData(data: userArray[indexPath.row].tags ?? [])
        
        cell.betPointsStackView.isHidden = true
        cell.dateLabel.isHidden = false
        cell.followStackView.isHidden = false
        cell.heightConstraint.constant = 35.67
        cell.nameLabel.text = userArray[indexPath.row].appdata?.predict?.name?.capitalized
        cell.winRateLabel.text = "\(userArray[indexPath.row].appdata?.predict?.predictStats?.successRate ?? 0)%"
        cell.allCountLabel.text = "Total: \(userArray[indexPath.row].appdata?.predict?.predictStats?.allCount ?? 0)"
        cell.successCountLabel.text = "Success: \(userArray[indexPath.row].appdata?.predict?.predictStats?.successCount ?? 0)"
        cell.unsuccessCountLabel.text = "Failed: \(userArray[indexPath.row].appdata?.predict?.predictStats?.unsuccessCount ?? 0)"
        cell.coinLabel.text = "Coin: \(userArray[indexPath.row].appdata?.predict?.predictStats?.coins ?? 0)"
        cell.dateLabel.text = "  \(userArray[indexPath.row].appdata?.predict?.date.formatDate(inputFormat: dateFormat.ddMMyyyyWithTimeZone, outputFormat: dateFormat.ddMMMyyyyhmma) ?? "")"
        
        if userArray[indexPath.row].following ?? true {
            cell.followButton.isHidden = true
        }else {
            cell.followingButton.isHidden = true
        }
        return cell
    }
    
    private func firstThreeExpertsData() {
        guard var data = expertPredictUserVM?.responseData?.response?.data else {
            return
        }
        // Sort the data array based on successRate in descending order
        data.sort { (expert1, expert2) -> Bool in
            return (expert1.appdata?.predict?.predictStats?.successRate ?? 0) > (expert2.appdata?.predict?.predictStats?.successRate ?? 0)
        }
        // Display the sorted data
        for (index, expert) in data.prefix(3).enumerated() {
            let imageView = [firstExpertImageView, secondExpertImageView, thirdExpertImageView][index]
            let nameLabel = [firstExpertNameLabel, secondExpertNameLabel, thirdExpertNameLabel][index]
            let winPercentLabel = [firstExpertWinPercentLabel, secondExpertWinPercentLabel, thirdtExpertWinPercentLabel][index]
            
            imageView?.sd_imageIndicator = SDWebImageActivityIndicator.white
            imageView?.setImage(imageStr: expert.profileImg ?? "", placeholder: .placeholderUser)
            nameLabel?.text = expert.appdata?.predict?.name?.capitalized
            winPercentLabel?.text = "\(expert.appdata?.predict?.predictStats?.successRate ?? 0)%"
        }
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
    
    private func fetchTagsViewModel() {
        tagsVM = TagsViewModel()
        tagsVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.tagsCollectionView.reloadData()
                self?.constantTagsCollectionView.reloadData()
                self?.highlightFirstIndex_collectionView()
            })
            .store(in: &cancellable)
        
        /// API call to fetch all tags
        tagsVM?.fetchTagsAsyncCall()
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
    
    private func fetchPredictionViewModel() {
        predictionVM = HomePagePredictionVM()
        predictionVM?.showError = { [weak self] error in
            self?.predictionViewHeightConstraints.constant = 0
            self?.view.makeToast(ErrorMessage.predictionsNotFound.localized, duration: 2.0, position: .center)
        }
        predictionVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.predictionViewHeightConstraints.constant = 250
                self?.predictionTabelView.reloadData()
            })
            .store(in: &cancellable)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: currentDate)
        
        /// API call to fetch prediction data
        predictionVM?.fetchHomePagePredictionMatchesAsyncCall(lang: "en", date: formattedDate)
    }
    
    private func fetchExpertViewModel() {
        expertPredictUserVM = ExpertPredictUserViewModel()
        expertPredictUserVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        expertPredictUserVM?.showError = { [weak self] error in
            self?.view.makeToast(ErrorMessage.expertNotFound.localized, duration: 2.0, position: .center)
        }
        expertPredictUserVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.firstThreeExpertsData()
                self?.userArray = response?.response?.data ?? []
                self?.expertTableView.reloadData()
            //    self?.expertViewHeight.constant = 1000
            })
            .store(in: &cancellable)
    }
    
    private func expertDataAPICall() {
        /// API call to fetch experts data
        expertPredictUserVM?.fetchExpertUserListAsyncCall(page: 1, slug: "predict-match", tag: "betting-expert")
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
        switch collectionView {
        case servicesCollectionView:
            return ServiceType.allCases.count
            
        case bannerCollectionView:
            return bannerVM?.responseData?.data.top.count ?? 0
            
        default:
            return tagsVM?.responseData?.response.data.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            
        case servicesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            cell.configure(title: ServiceType.allCases[indexPath.row].rawValue.localized, titleTop: -4, iconImage: ServiceType.allCases[indexPath.row].iconImage, bgViewWidth: 55, imageWidth: (0.55 * 55))
            cell.bgView.borderWidth = 0
            cell.titleLabel.textColor = .base
            return cell
            
        case bannerCollectionView:
            guard let banner = bannerVM?.responseData?.data.top else {
                return UICollectionViewCell()
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.bannerCell, for: indexPath) as! BannerCollectionViewCell
            cell.bannerImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.bannerImage.sd_setImage(with: URL(string: URLConstants.bannerBaseURL + banner[indexPath.item].coverPath))
            return cell
            
        case tagsCollectionView, constantTagsCollectionView:
            guard let tags = tagsVM?.responseData?.response.data else {
                return UICollectionViewCell()
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
            cell.leagueName.text = tags[indexPath.item].tag
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == servicesCollectionView {
            switch ServiceType.allCases[indexPath.row] {
            case .predictions:
                navigateToViewController(HomePredictionViewController.self, storyboardName: StoryboardName.prediction, animationType: .autoReverse(presenting: .zoom))
            case .bets:
                navigateToViewController(BetHomeVc.self, storyboardName: StoryboardName.bets, animationType: .autoReverse(presenting: .zoom))
            case .social:
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[1]
            case .fantasy:
                print("")
            case .matches:
                navigateToViewController(MatchesDashboardVC.self, storyboardName: StoryboardName.matches, animationType: .autoReverse(presenting: .zoom))
            case .updates:
                navigateToViewController(NewsModuleVC.self, storyboardName: StoryboardName.news, identifier: "NewsModuleVC")
            case .database:
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[2]
            case .analysis:
                print("")
            case .users:
                print("")
            case .street:
                navigateToViewController(StreetMatchesDashboardVC.self, storyboardName: StoryboardName.streetMatches, animationType: .autoReverse(presenting: .zoom))
            case .meet:
                navigateToViewController(MeetDashboardVC.self, storyboardName: StoryboardName.meet, animationType: .autoReverse(presenting: .zoom))
            case .experts:
                navigateToViewController(HomeVC.self, storyboardName: StoryboardName.home, animationType: .autoReverse(presenting: .zoom))
            case .cards:
                navigateToViewController(AllPlayersViewController.self, storyboardName: StoryboardName.cardGame, identifier: "AllPlayersViewController")
            default: //wallet
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[3]
            }
        } else {
            if collectionView == bannerCollectionView {
                let bannerMesssage = bannerVM?.responseData?.data.top[indexPath.item].message ?? ""
                if bannerMesssage.contains("http") || bannerMesssage.contains("www"){
                    guard let url = URL(string: bannerMesssage) else { return }
                    UIApplication.shared.open(url)
                }
            } else {
                let tag = tagsVM?.responseData?.response.data[indexPath.item].slug
                expertPredictUserVM?.fetchExpertUserListAsyncCall(page: 1, slug: "predict-match", tag: tag)
                highlightFirstIndex_collectionView(item: indexPath.item)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        if collectionView == servicesCollectionView {
            return CGSize(width: (screenWidth - 25) / 5, height: 85)
        } else if collectionView == bannerCollectionView {
            width = collectionView.bounds.width
        } else {
            width = collectionView.bounds.width / 4
        }
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}

extension InfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case topMatchesTableView:
            return min(liveMatchArray.count, 2)
            
        case whatsHappeningTableView:
            return min(gossipsArray.count, 3)
            
        case predictionTabelView:
            return min(predictionVM?.responseData?.response.data.count ?? 0, 3)
            
        default:
            return expertPredictUserVM?.responseData?.response?.data?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case topMatchesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.globalMatchesTableViewCell, for: indexPath) as! GlobalMatchesTableViewCell
            congifureCell(cell: cell, matches: liveMatchArray[indexPath.row])
            return cell
            
        case whatsHappeningTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newsTableViewCell, for: indexPath) as! NewsTableViewCell
            cell.titleLabel.textColor = UIColor(red: 0/255, green: 76/255, blue: 107/255, alpha: 1)
            cell.configureGossipCell(model: gossipsArray[indexPath.row])
            return cell
            
        case predictionTabelView:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictionTableCell, for: indexPath) as! HomePagePredictionTableViewCell
            guard let data = predictionVM?.responseData?.response.data[indexPath.row].matches else {
                return UITableViewCell()
            }
            cell.configureCell(data: data[0])
            return cell
            
        default:
            return tableCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case topMatchesTableView, whatsHappeningTableView:
            return 90
            
        case predictionTabelView:
            return 75
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if tableView == expertTableView {
                expertTableViewHeight.constant = CGFloat(200 * (expertPredictUserVM?.responseData?.response?.data?.count ?? 0))
            }
        }
}
