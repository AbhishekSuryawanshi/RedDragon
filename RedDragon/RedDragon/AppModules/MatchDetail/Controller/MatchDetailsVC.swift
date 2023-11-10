//
//  MatchDetailsVC.swift
//  RedDragon
//
//  Created by QASR02 on 02/11/2023.
//

import UIKit
import Combine
import SDWebImage

class MatchDetailsVC: UIViewController {
    
    @IBOutlet weak var matchTabsCollectionView: UICollectionView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var firstHalfScoreLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewContainerHeight: NSLayoutConstraint!
    
    private var cancellable = Set<AnyCancellable>()
    private var matchDetailViewModel: MatchDetailsViewModel?
    private var fetchCurrentLanguageCode = String()
    private var matchTabsArray = [String]()
    private var tabViewControllers: [UIViewController] = []
    var matchSlug: String?
    var leagueName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFunctionality()
    }
    
    func loadFunctionality() {
        nibInitialization()
        matchTabsData()
        configureUI()
        fetchMatchDetailsViewModel()
        makeNetworkCall()
    }
    
    func matchTabsData() {
        matchTabsArray = [StringConstants.highlight.localized,
                          StringConstants.stat.localized,
                          StringConstants.lineup.localized,
                          StringConstants.bets.localized,
                          StringConstants.odds.localized,
                          StringConstants.analysis.localized,
                          StringConstants.expert.localized ]
        
        tabViewControllers = [HighlightViewController(),
                              StatisticsViewController(),
                              LineupViewController(),
                              BetsViewController(),
                              OddsViewController(),
                              AnalysisViewController(),
                              ExpertViewController()]
    }
    
    func nibInitialization() {
        matchTabsCollectionView.register(CellIdentifier.matchTabsCollectionViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func makeNetworkCall() {
        matchDetailViewModel?.fetchMatchDetailAsyncCall(lang: fetchCurrentLanguageCode == "en" ? "en" : "zh",
                                                        slug: "2023-02-21-liverpool-real-madrid",
                                                        sports: "football") //2023-02-21-liverpool-real-madrid //matchSlug ?? ""
    }
}

extension MatchDetailsVC {
    ///fetch viewModel for Match details
    func fetchMatchDetailsViewModel() {
        matchDetailViewModel = MatchDetailsViewModel()
        matchDetailViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        matchDetailViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        matchDetailViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.renderResponseData(data: data!)
            })
            .store(in: &cancellable)
    }
    
    func renderResponseData(data: MatchDetail) {
        let data = data.data
        UIView.animate(withDuration: 1.0) { [self] in
            leagueNameLabel.text = leagueName
            homeTeamImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            awayTeamImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            homeTeamImageView.sd_setImage(with: URL(string: data.homeTeamImage))
            awayTeamImageView.sd_setImage(with: URL(string: data.awayTeamImage))
            homeTeamNameLabel.text = data.homeTeamName
            awayTeamNameLabel.text = data.awayTeamName
            scoreLabel.text = "\(data.homeScore) - \(data.awayScore)"
            firstHalfScoreLabel.text = "\(StringConstants.firstHalf)(\(data.home1StHalf)-\(data.away1StHalf))"
            highlightFirstIndex_collectionView()
            self.view.layoutIfNeeded()
        }
    }
}

extension MatchDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchTabsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.matchTabsCollectionViewCell, for: indexPath) as! MatchTabsCollectionViewCell
        cell.tabNameLabel.text = matchTabsArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        guard indexPath.item < tabViewControllers.count else {
        //            return
        //        }
        //        let viewControllers = tabViewControllers[indexPath.item]
        //        embedViewController(viewControllers)
        if indexPath.item == 0 {
            embedHighlighVC()
        }
    }
}

/// __Supportive function calls

extension MatchDetailsVC {
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    func configureUI() {
        addActivityIndicator()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        matchTabsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(matchTabsCollectionView, didSelectItemAt: indexPath)
    }
    
//    ///function to load view controllers on click of match tabs
//    func embedViewController(_ viewController: UIViewController) {
//        ViewEmbedder.embed(withIdentifier: String(describing: type(of: viewController)), storyboard: UIStoryboard(name: StoryboardName.matchDetail, bundle: nil), parent: self, container: viewContainer)
//        viewContainerHeight.constant = viewController.view.frame.size.height
//    }
    
    func embedHighlighVC() {
            ViewEmbedder.embed(withIdentifier: "HighlightViewController", storyboard: UIStoryboard(name: StoryboardName.matchDetail, bundle: nil), parent: self, container: viewContainer) { [self] vc in
                let vc = vc as! HighlightViewController
                vc.configureView(progressData: matchDetailViewModel?.responseData?.data.progress)
                viewContainerHeight.constant = vc.view.frame.size.height
            }
        }
    
}
