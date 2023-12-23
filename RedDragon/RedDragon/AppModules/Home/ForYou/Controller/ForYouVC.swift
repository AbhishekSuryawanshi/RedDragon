//
//  ForYouVC.swift
//  RedDragon
//
//  Created by iOS Dev on 13/12/2023.
//

import UIKit
import Combine
import Foundation

class ForYouVC: UIViewController {
    
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var saveUptoLabel: UILabel!
    @IBOutlet weak var packageSeeAllButton: UIButton!
    
    @IBOutlet weak var liveMatchesLabel: UILabel!
    @IBOutlet weak var liveMatchesTabelView: UITableView!
    @IBOutlet weak var liveMatchesTableView: UIButton!
    
    @IBOutlet weak var topExpertsLabel: UILabel!
    @IBOutlet weak var expertsSeeAllButton: UIButton!
    @IBOutlet weak var expertTableView: UITableView!
    
    @IBOutlet weak var upcomingMatchesLabel: UILabel!
    @IBOutlet weak var upcomingMatchesSeeAllButton: UIButton!
    @IBOutlet weak var upcomingMatchesTaleView: UITableView!
    
    @IBOutlet weak var topPredictionsLabel: UILabel!
    @IBOutlet weak var topPredictionsSeeAllButton: UIButton!
    @IBOutlet weak var topPredictionsTableView: UITableView!
    
    @IBOutlet weak var whatsHappeningLabel: UILabel!
    @IBOutlet weak var whatsHappeningSeeAllButton: UIButton!
    @IBOutlet weak var whatsHappeningTableView: UITableView!
    
    @IBOutlet weak var topLeagueLabel: UILabel!
    @IBOutlet weak var topLeagueSeeAllButton: UIButton!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    
    @IBOutlet weak var topTeamLabel: UILabel!
    @IBOutlet weak var topTeamSeeAllButton: UIButton!
    @IBOutlet weak var topTeamCollectionView: UICollectionView!
    
    @IBOutlet weak var streetMatchesFeedLabel: UILabel!
    @IBOutlet weak var streetMatchSeeAllButton: UIButton!
    @IBOutlet weak var streetMatchTableView: UITableView!
    
    
    private var cancellable = Set<AnyCancellable>()
    private var footballLiveMatchesVM: FootballLiveMatchesViewModel?
    private var liveMatchArray: [GlobalMatchList] = []
    private var expertPredictUserVM: ExpertPredictUserViewModel?
    private var userArray = [ExpertUser]()
    private var footballFinishedMatchesVM: FootballFinishedMatchesViewModel?
    private var upcomingMatchArray: [GlobalMatchList] = []
    private var footballUpcomingMatchesVM: FootballUpcomingMatchesViewModel?
    private var predictionVM: HomePagePredictionVM?
    private var gossipVM: GossipListVM?
    private var gossipsArray: [Gossip] = []
    private var topLeagueViewModel: SocialPublicLeagueVM?
    private var leagueArray: [SocialLeague] = []
    private var topTeamsViewModel: SocialPublicTeamVM?
    private var teamArray: [SocialTeam] = []
    private var streethomeVM: StreetHomeViewModel?
    private var homeData: StreetMatchHome?
    private var matches: [StreetMatch]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

}

/// __Fetch View model
extension ForYouVC {
    
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
                self?.liveMatchesTabelView.reloadData()
            })
            .store(in: &cancellable)
        
        /// API call for Live matches
        footballLiveMatchesVM?.fetchFootballLiveMatches()
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
                self?.userArray = response?.response?.data ?? []
                self?.expertTableView.reloadData()
            })
            .store(in: &cancellable)
        
        /// API call to fetch experts data
        expertPredictUserVM?.fetchExpertUserListAsyncCall(page: 1, slug: "predict-match", tag: "betting-expert")
    }
    
    private func fetchUpcomingMatchesViewModel() {
        footballUpcomingMatchesVM = FootballUpcomingMatchesViewModel()
        footballUpcomingMatchesVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        footballUpcomingMatchesVM?.showError = { [weak self] error in
            self?.view.makeToast(ErrorMessage.upcomingDataNotFound.localized, duration: 2.0, position: .center)
        }
        footballUpcomingMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.upcomingMatchArray = response?.matchList ?? []
                self?.upcomingMatchesTaleView.reloadData()
            })
            .store(in: &cancellable)
        
        /// API call to fetch Upcoming matches
        footballUpcomingMatchesVM?.fetchFootballUpcomingMatches()
    }
    
    private func fetchPredictionViewModel() {
        predictionVM = HomePagePredictionVM()
        predictionVM?.showError = { [weak self] error in
            self?.view.makeToast(ErrorMessage.predictionsNotFound.localized, duration: 2.0, position: .center)
        }
        predictionVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.topPredictionsTableView.reloadData()
            })
            .store(in: &cancellable)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: currentDate)
        
        /// API call to fetch prediction data
        predictionVM?.fetchHomePagePredictionMatchesAsyncCall(lang: "en", date: formattedDate)
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
    
    private func fetchSocialViewModel() {
        ///fetch public league list / euro 5 league
        topLeagueViewModel = SocialPublicLeagueVM()
        topLeagueViewModel?.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        topLeagueViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.leagueArray = response ?? []
                self?.leagueCollectionView.reloadData()
            })
            .store(in: &cancellable)
        
        /// API call to fetch top leagues
        topLeagueViewModel?.fetchLeagueListAsyncCall()
    }
    
    private func fetchTeamsViewModel() {
        ///fetch public league list / euro 5 league
        topTeamsViewModel = SocialPublicTeamVM()
        topTeamsViewModel?.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        topTeamsViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.teamArray = response ?? []
                self?.topTeamCollectionView.reloadData()
            })
            .store(in: &cancellable)
        
        /// API call to fetch top leagues
        topTeamsViewModel?.fetchTeamListAsyncCall()
    }
    
    private func fetchStreetHomeViewModel() {
        streethomeVM = StreetHomeViewModel()
        streethomeVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        streethomeVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        streethomeVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if response?.response?.data != nil{
                    self?.execute_onResponseData(homeData: response!.response!.data!)
                }
            })
            .store(in: &cancellable)
        
        /// API call to fetch stree matches feed
        streethomeVM?.fetchStreetHomeAsyncCall(id: nil)
    }
    
    func execute_onResponseData(homeData:StreetMatchHome) {
        self.homeData = homeData
        self.matches = homeData.matches
        self.streetMatchTableView.reloadData()
    }
}

extension ForYouVC {
    
    private func loadFunctionality() {
        initializeNibFiles()
    }
    
    private func initializeNibFiles() {
        liveMatchesTabelView.register(CellIdentifier.forYouLiveMatchTabelCell)
        expertTableView.register(CellIdentifier.predictUserListTableViewCell)
        upcomingMatchesTaleView.register(CellIdentifier.forYouLiveMatchTabelCell)
        topPredictionsTableView.register(CellIdentifier.predictionTableCell)
        whatsHappeningTableView.register(CellIdentifier.newsTableViewCell)
        leagueCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        topTeamCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        streetMatchTableView.register(CellIdentifier.feedsTableViewCell)
    }
    
    private func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func configureUI() {
        loadViewModels()
    }
    
    private func loadViewModels() {
        fetchLiveMatchViewModel()
        fetchExpertViewModel()
        fetchUpcomingMatchesViewModel()
        fetchPredictionViewModel()
        fetchGossipViewModel()
        fetchSocialViewModel()
        fetchTeamsViewModel()
        fetchStreetHomeViewModel()
    }
    
    private func configureCommonCell(cell: ForYouLiveMatchTableViewCell, matches: GlobalMatchList) {
        cell.leagueImageView.setImage(imageStr: matches.leagueInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.homeImageView.setImage(imageStr: matches.homeInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.awayImageView.setImage(imageStr: matches.awayInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.homeNameLabel.text = matches.homeInfo?.name ?? ""
        cell.awayNameLabel.text = matches.awayInfo?.name ?? ""
        
        cell.leagueNameLabel.text = "\(matches.leagueInfo?.name ?? "") | Round \(matches.round?.round ?? 0)"
        cell.cornerLabel.text = "Corners: \(matches.homeInfo?.cornerScore ?? 0)-\(matches.awayInfo?.cornerScore ?? 0)"
        cell.scoreLabel.text = "\(matches.homeInfo?.homeScore ?? 0):\(matches.awayInfo?.awayScore ?? 0)"
        cell.halfTimeLabel.isHidden = false
        cell.halfTimeLabel.text = "Halftime: \(matches.homeInfo?.halfTimeScore ?? 0)-\(matches.awayInfo?.halfTimeScore ?? 0)"
        cell.homeYellowCountLabel.text = "\(matches.homeInfo?.yellowCards ?? 0)"
        cell.awayYellowCountLabel.text = "\(matches.awayInfo?.yellowCards ?? 0)"
        cell.oddsLabel.text = "Win \(matches.odds?.header?.euro?.home ?? 0) Draw \(matches.odds?.header?.euro?.handicap ?? 0) Lose \(matches.odds?.header?.euro?.away ?? 0)"
    }

    private func configureCell(cell: ForYouLiveMatchTableViewCell, matches: GlobalMatchList) {
        configureCommonCell(cell: cell, matches: matches)
        cell.dateLabel.text = ""
        cell.scoreLabel.text = "\(matches.homeInfo?.homeScore ?? 0):\(matches.awayInfo?.awayScore ?? 0)"
        cell.dateTimeViewWeight.constant = 50
    }

    private func configureCellForUpcomingMatches(cell: ForYouLiveMatchTableViewCell, matches: GlobalMatchList) {
        configureCommonCell(cell: cell, matches: matches)

        if let dateString = matches.matchTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            if let date = dateFormatter.date(from: dateString) {
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "E dd MMM"
                
                let outputTimeFormatter = DateFormatter()
                outputTimeFormatter.dateFormat = "hh:mm a"

                let formattedDate = outputDateFormatter.string(from: date)
                let formattedTime = outputTimeFormatter.string(from: date)

                cell.dateLabel.text = formattedDate
                cell.scoreLabel.text = formattedTime
            } else {
                print("Invalid date format")
            }
        }
        cell.dateTimeViewWeight.constant = 80
        cell.cornerLabel.text = ""
        cell.halfTimeLabel.text = ""
        cell.homeYellowCountLabel.isHidden = true
        cell.awayYellowCountLabel.isHidden = true
        cell.awayYellowCard.isHidden = true
        cell.homeYellowCard.isHidden = true
    }
    
    private func tableCell(indexPath:IndexPath) -> PredictUserListTableViewCell {
        let cell = expertTableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictUserListTableViewCell, for: indexPath) as! PredictUserListTableViewCell
        
        cell.aboutLabel.text = "Description for this expert is not availabel at the moment." //userArray[indexPath.row].about
        cell.userImageView.setImage(imageStr: userArray[indexPath.row].profileImg ?? "", placeholder: .placeholderUser)
        cell.walletButton.setTitle("\(userArray[indexPath.row].wallet ?? 0)", for: .normal)
        cell.configureTagCollectionData(data: userArray[indexPath.row].tags ?? [])
        
        cell.betPointsStackView.isHidden = true
        cell.dateLabel.isHidden = false
        cell.followStackView.isHidden = false
        cell.heightConstraint.constant = 35.67
        cell.nameLabel.text = userArray[indexPath.row].appdata?.predict?.name?.capitalized
        //    let roundedValue = (userArray[indexPath.row].appdata?.predict?.predictStats?.successRate ?? 0.0).rounded(toPlaces: 2)
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
    
}

extension ForYouVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case liveMatchesTabelView:
            return min(liveMatchArray.count, 2)
            
        case expertTableView:
            return min(expertPredictUserVM?.responseData?.response?.data?.count ?? 0, 2)
            
        case upcomingMatchesTaleView:
            return min(upcomingMatchArray.count, 2)
            
        case topPredictionsTableView:
            return min(predictionVM?.responseData?.response.data.count ?? 0, 3)
            
        case whatsHappeningTableView:
            return min(gossipsArray.count, 3)
            
        default:
            return min(homeData?.events?.count ?? 0, 2)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case liveMatchesTabelView:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.forYouLiveMatchTabelCell, for: indexPath) as! ForYouLiveMatchTableViewCell
            configureCell(cell: cell, matches: liveMatchArray[indexPath.row])
            return cell
            
        case expertTableView:
            return tableCell(indexPath: indexPath)
            
        case upcomingMatchesTaleView:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.forYouLiveMatchTabelCell, for: indexPath) as! ForYouLiveMatchTableViewCell
            configureCellForUpcomingMatches(cell: cell, matches: upcomingMatchArray[indexPath.row])
            return cell
            
        case topPredictionsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictionTableCell, for: indexPath) as! HomePagePredictionTableViewCell
            guard let data = predictionVM?.responseData?.response.data[indexPath.row].matches else {
                return UITableViewCell()
            }
            cell.configureCell(data: data[0])
            return cell
            
        case whatsHappeningTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newsTableViewCell, for: indexPath) as! NewsTableViewCell
            cell.titleLabel.textColor = UIColor(red: 0/255, green: 76/255, blue: 107/255, alpha: 1)
            cell.configureGossipCell(model: gossipsArray[indexPath.row])
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.feedsTableViewCell, for: indexPath) as! FeedsTableViewCell
            cell.configureCell(obj: homeData?.events?[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case liveMatchesTabelView:
            return 100
            
        case expertTableView:
            return UITableView.automaticDimension
            
        case upcomingMatchesTaleView:
            return 100
            
        case topPredictionsTableView:
            return 75
            
        case whatsHappeningTableView:
            return 90
            
        default:
            return 150
        }
    }
}

extension ForYouVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == leagueCollectionView ? leagueArray.count : teamArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
        if collectionView == leagueCollectionView {
            let model = leagueArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, imageWidth: (0.7 * 60), bgViewCornerRadius: 30, iconCornerRadius: 30, placeHolderImage: .placeholderLeague)
        }
        else if collectionView == topTeamCollectionView {
            let model = teamArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, imageWidth: (0.7 * 60), bgViewCornerRadius: 30, iconCornerRadius: 30, placeHolderImage: .placeholderLeague)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
}
