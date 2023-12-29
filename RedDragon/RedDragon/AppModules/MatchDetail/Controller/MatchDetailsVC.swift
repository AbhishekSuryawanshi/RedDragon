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
    private var tennisDetailViewModel: TennisDetailsViewModel?
    private var fetchCurrentLanguageCode = String()
    private var matchTabsArray = [String]()
    var matchSlug: String?
    var leagueName: String?
    var sports: String?
    var isFromPrediction = false
    

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
        configureLanguage()
        fetchMatchDetailsViewModel()
        fetchTennisDetailsViewModel()
        makeNetworkCall()
    }
    
    func matchTabsData() {
        matchTabsArray = [StringConstants.highlight.localized,
                          StringConstants.stat.localized,
                          StringConstants.lineup.localized,
                          StringConstants.analysis.localized]
    }
    
    func nibInitialization() {
        matchTabsCollectionView.register(CellIdentifier.matchTabsCollectionViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func makeNetworkCall() {
        /// __parateters__
        ///slug: "2023-02-21-liverpool-real-madrid" //matchSlug ?? ""
        ///sports: sports ?? ""
       // matchSlug = "2023-10-31-cleveland-cavaliers-new-york-knicks"
        if sports == Sports.football.title.lowercased() {
            matchDetailViewModel?.fetchMatchDetailAsyncCall(lang: fetchCurrentLanguageCode == "en" ? "en" : "zh",
                                                            slug: matchSlug ?? "",
                                                            sports: sports ?? "")
        } else{
            tennisDetailViewModel?.fetchMatchDetailAsyncCall(lang: fetchCurrentLanguageCode == "en" ? "en" : "zh",
                                                            slug: matchSlug ?? "",
                                                            sports: sports ?? "")
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    ///fetch viewModel for Match details
    func fetchTennisDetailsViewModel() {
        tennisDetailViewModel = TennisDetailsViewModel()
        tennisDetailViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        tennisDetailViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        tennisDetailViewModel?.$responseData
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
            if isFromPrediction{
                highlightAnalysis_collectionView()
            }
            else{
                highlightFirstIndex_collectionView()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func renderResponseData(data: TennisMatchDetail) {
        let data = data.data
        UIView.animate(withDuration: 1.0) { [self] in
            leagueNameLabel.text = leagueName
            homeTeamImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            awayTeamImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            homeTeamImageView.sd_setImage(with: URL(string: data.homeTeamImage ?? ImageConstants.placeHolderTeam))
            awayTeamImageView.sd_setImage(with: URL(string: data.awayTeamImage ?? ImageConstants.placeHolderTeam))
            homeTeamNameLabel.text = data.homeTeamName
            awayTeamNameLabel.text = data.awayTeamName
            scoreLabel.text = "\(data.homeScore ?? "0") - \(data.awayScore ?? "0")"
          //  firstHalfScoreLabel.text = "\(StringConstants.firstHalf)(\(data.home1StHalf)-\(data.away1StHalf))"
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
        switch indexPath.item {
        case 0:
            embedHighlightVC()
        case 1:
            embedStatisticVC()
        case 2:
            embedLineupVC()
        case 3:
            embedAnalysisVC()
            
        default:
            break
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
    
    func configureLanguage() {
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang == "en-US") ? "en" : lang
        fetchCurrentLanguageCode = lang
    }
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        matchTabsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(matchTabsCollectionView, didSelectItemAt: indexPath)
    }
    
    func highlightAnalysis_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 3, section: 0)
        matchTabsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(matchTabsCollectionView, didSelectItemAt: indexPath)
    }
    
    func embedHighlightVC() {
        ViewEmbedder.embed(withIdentifier: "HighlightViewController", storyboard: UIStoryboard(name: StoryboardName.matchDetail, bundle: nil), parent: self, container: viewContainer) { [self] vc in
            let vc = vc as! HighlightViewController
            vc.configureView(progressData: matchDetailViewModel?.responseData?.data.progress)
        }
    }
    
    func embedStatisticVC() {
        ViewEmbedder.embed(withIdentifier: "StatisticsViewController", storyboard: UIStoryboard(name: StoryboardName.matchDetail, bundle: nil), parent: self, container: viewContainer) { [weak self] vc in
            let vc = vc as! StatisticsViewController
            vc.configureStatisticView(statisticData: self?.matchDetailViewModel?.responseData?.data.statistics)
            vc.configureMediaData(mediaData: self?.matchDetailViewModel?.responseData?.data.medias)
            vc.configureEventsData(recentMatches: self?.matchDetailViewModel?.responseData?.data.homeEvents)
        }
    }
    
    func embedLineupVC() {
        ViewEmbedder.embed(withIdentifier: "LineupViewController", storyboard: UIStoryboard(name: StoryboardName.matchDetail, bundle: nil), parent: self, container: viewContainer) { [weak self] vc in
            let vc = vc as! LineupViewController
            vc.configureHomeLineupView(homeLineup: self?.matchDetailViewModel?.responseData?.data.homeLineup)
            vc.configureAwayLineupView(awayLineup: self?.matchDetailViewModel?.responseData?.data.awayLineup)
            vc.configureSubstitutePlayer(homeSubstituteData: self?.matchDetailViewModel?.responseData?.data.homeLineup, awaySubstituteData: self?.matchDetailViewModel?.responseData?.data.awayLineup)
        }
    }
    
    func embedAnalysisVC() {
        ViewEmbedder.embed(withIdentifier: "AnalysisViewController", storyboard: UIStoryboard(name: StoryboardName.matchDetail, bundle: nil), parent: self, container: viewContainer) { [weak self] vc in
            let vc = vc as! AnalysisViewController
            vc.matchSlug =  self?.matchSlug ?? ""
            vc.data = self?.matchDetailViewModel?.responseData?.data
           // vc.configureView()
        }
    }
    
}
