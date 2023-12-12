//
//  MatchesDashboardVC.swift
//  RedDragon
//
//  Created by iOS Dev on 08/12/2023.
//

import UIKit
import Combine

enum sportCategorySegment: String, CaseIterable {
    case hottest = "Hottest"
    case football = "Football"
    case basketball = "Basketball"
    case tennis = "Tennis"
}

class MatchesDashboardVC: UIViewController {
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var topSpaceHeightForTable: NSLayoutConstraint!
    
    var cancellable = Set<AnyCancellable>()
    var selectedSegment: sportCategorySegment = .hottest
    var sectionTitle = ["Live Matches", "Upcoming Matches", "Past Matches"]
    var leagueArray: [HotLeagues] = []
    var liveMatchArray: [GlobalMatchList] = []
    var finishedMatchArray: [GlobalMatchList] = []
    var upcomingMatchArray: [GlobalMatchList] = []
    var leagueMatchArray: [GlobalMatchList] = []
    private var footballLiveMatchesVM: FootballLiveMatchesViewModel?
    private var footballFinishedMatchesVM: FootballFinishedMatchesViewModel?
    private var footballUpcomingMatchesVM: FootballUpcomingMatchesViewModel?
    private var footballLeagueMatchesVM = FootballLeagueMatchesViewModel()
    private var basketballLiveMatchesVM: BasketballLiveMatchesViewModel?
    private var basketballFinishedMatchesVM: BasketballFinishedMatchesViewModel?
    private var basketballUpcomingMatchesVM: BasketballUpcomingMatchesViewModel?
    private var basketballLeaguesVM: BasketballLeaguesViewModel?
    private var basketballLeagueMatchesVM = BasketballLeagueMatchesViewModel()
    
    var isFootball: Bool? = true
    var isLeagueMatches: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        nibInitialization()
        makeNetworkCall()
        segmentControl.selectedSegmentIndex = 0
        segmentControlValueChanged(segmentControl)
        topSpaceHeightForTable.constant = 49.0
    }
    
    func nibInitialization() {
        leagueCollectionView.register(CellIdentifier.leagueNamesCollectionCell)
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        tableView.register(CellIdentifier.globalMatchesTableViewCell)
    }
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        leagueCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(leagueCollectionView, didSelectItemAt: indexPath)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func makeNetworkCall() {
        footballLiveMatchesVM = FootballLiveMatchesViewModel()
        footballFinishedMatchesVM = FootballFinishedMatchesViewModel()
        footballUpcomingMatchesVM = FootballUpcomingMatchesViewModel()
        
        basketballLeaguesVM = BasketballLeaguesViewModel()
        basketballLiveMatchesVM = BasketballLiveMatchesViewModel()
        basketballFinishedMatchesVM = BasketballFinishedMatchesViewModel()
        basketballUpcomingMatchesVM = BasketballUpcomingMatchesViewModel()
        
        fetchFBViewModelResponse()
        fetchBBViewModelResponse()
    }
    
    // MARK: - Segment Control Actions
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        DispatchQueue.main.async { [self] in
            if self.segmentControl.selectedSegmentIndex == 0 {
                isFootball = true
                footballLiveMatchesVM?.fetchFootballLiveMatches()
                footballFinishedMatchesVM?.fetchFootballFinishedMatches()
                footballUpcomingMatchesVM?.fetchFootballUpcomingMatches()
            }else {
                isFootball = false
                basketballLeaguesVM?.fetchBasketballLeagueMatches()
                basketballLiveMatchesVM?.fetchBasketballLiveMatches()
                basketballFinishedMatchesVM?.fetchBasketballFinishedMatches()
                basketballUpcomingMatchesVM?.fetchBasketballUpcomingMatches()
            }
        }
    }
}

// MARK: - Network Related Response
extension MatchesDashboardVC {
    
    // Football Related Response
    func fetchFBLeagueMatchesViewModelResponse() {
        footballLeagueMatchesVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        footballLeagueMatchesVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        footballLeagueMatchesVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onFBLeagueMatchesResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    ///fetch view model for live, finished, upcoming match list
    func fetchFBViewModelResponse() {
        footballLiveMatchesVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        footballLiveMatchesVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        footballLiveMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onFBLiveMatchesResponse(response!)
            })
            .store(in: &cancellable)
        
        footballFinishedMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onFBFinishedMatchesResponse(response!)
            })
            .store(in: &cancellable)
        
        footballUpcomingMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onFBUpcomingMatchesResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onFBLiveMatchesResponse(_ response: GlobalEventsModel) {
        liveMatchArray = response.matchList ?? []
        leagueArray = response.hotLeagues ?? []
        leagueCollectionView.reloadData()
        highlightFirstIndex_collectionView()
        isLeagueMatches = false
        tableView.reloadData()
    }
    
    func execute_onFBFinishedMatchesResponse(_ response: GlobalEventsModel) {
        finishedMatchArray = response.matchList ?? []
        tableView.reloadData()
    }
    
    func execute_onFBUpcomingMatchesResponse(_ response: GlobalEventsModel) {
        upcomingMatchArray = response.matchList ?? []
        tableView.reloadData()
    }
    
    func execute_onFBLeagueMatchesResponse(_ response: GlobalEventsModel) {
        leagueMatchArray = response.matchList ?? []
        tableView.reloadData()
    }
    
    // Basketball Related Response
    func fetchBBLeagueMatchesViewModelResponse() {
        basketballLeagueMatchesVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        basketballLeagueMatchesVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        basketballLeagueMatchesVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onBBLeagueMatchesResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    func fetchBBViewModelResponse() {
        basketballLeaguesVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        basketballLeaguesVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        
        basketballLeaguesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onBBLeagueResponse(response!)
            })
            .store(in: &cancellable)
        
        basketballLiveMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onBBLiveMatchesResponse(response!)
            })
            .store(in: &cancellable)
        
        basketballFinishedMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onBBFinishedMatchesResponse(response!)
            })
            .store(in: &cancellable)
        
        basketballUpcomingMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onBBUpcomingMatchesResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onBBLeagueMatchesResponse(_ response: GlobalEventsModel) {
        leagueMatchArray = response.matchList ?? []
        tableView.reloadData()
    }

    func execute_onBBLeagueResponse(_ response: GlobalEventsModel) {
        leagueArray = response.hotLeagues ?? []
        leagueCollectionView.reloadData()
        highlightFirstIndex_collectionView()
        tableView.reloadData()
    }
    
    func execute_onBBLiveMatchesResponse(_ response: GlobalEventsModel) {
        liveMatchArray = response.matchList ?? []
        tableView.reloadData()
    }
    
    func execute_onBBFinishedMatchesResponse(_ response: GlobalEventsModel) {
        finishedMatchArray = response.matchList ?? []
        tableView.reloadData()
    }
    
    func execute_onBBUpcomingMatchesResponse(_ response: GlobalEventsModel) {
        upcomingMatchArray = response.matchList ?? []
        tableView.reloadData()
    }
}

// MARK: - CollectionView Delegates
extension MatchesDashboardVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return sportCategorySegment.allCases.count
        }else { // leagueCollectionView
            return (leagueArray.count) + 1 // +1 for "All"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
            cell.configureUnderLineCell(title: sportCategorySegment.allCases[indexPath.item].rawValue, selected: selectedSegment == sportCategorySegment.allCases[indexPath.item])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
            if indexPath.item == 0 {
                cell.leagueName.text = "All"
            }else {
                cell.leagueName.text = leagueArray[indexPath.item-1].nameEnShort
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegment = sportCategorySegment.allCases[indexPath.row]
        if collectionView == headerCollectionView {
            switch indexPath.item {
            case 0:
                topSpaceHeightForTable.constant = 49.0
                segmentControl.isHidden = false
                segmentControl.selectedSegmentIndex = 0
                segmentControlValueChanged(segmentControl)
            case 1:
                isFootball = true
                topSpaceHeightForTable.constant = 8.0
                segmentControl.isHidden = true
                segmentControl.selectedSegmentIndex = 0   // Football
                segmentControlValueChanged(segmentControl)
            case 2:
                isFootball = false
                segmentControl.isHidden = true
                topSpaceHeightForTable.constant = 8.0
                segmentControl.selectedSegmentIndex = 1  // Basketball
                segmentControlValueChanged(segmentControl)
            default:
                segmentControl.isHidden = true
            }
            collectionView.reloadData()
        }else {
            if segmentControl.selectedSegmentIndex == 0 { // Football league cell clicked
                if indexPath.item == 0 { // For "All" case
                    isLeagueMatches = false
                    tableView.reloadData()
                }else {
                    isLeagueMatches = true
                    footballLeagueMatchesVM.fetchFootballLeagueMatches(leagueId: leagueArray[indexPath.item-1].id ?? "")
                    fetchFBLeagueMatchesViewModelResponse()
                }
            }else { // Basketball league cell clicked
                
                if indexPath.item == 0 { // For "All" case
                    isLeagueMatches = false
                    tableView.reloadData()
                }else {
                    isLeagueMatches = true
                    basketballLeagueMatchesVM.fetchBasketballLeagueMatches(leagueId: leagueArray[indexPath.item-1].id ?? "")
                    fetchBBLeagueMatchesViewModelResponse()
                }
            }
          print("League coll")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            let selected = selectedSegment == sportCategorySegment.allCases[indexPath.item]
            return CGSize(width: sportCategorySegment.allCases[indexPath.item].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 26, height: 50)
        }else {
            if indexPath.item == 0 {
                return CGSize(width: 35, height: 35)
            }else {
                return CGSize(width: (leagueArray[indexPath.item-1].nameEnShort?.localized.size(withAttributes: [NSAttributedString.Key.font : fontBold(17)]).width)!, height: 35)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animateCollectionView(collectionView, willDisplay: cell, forItemAt: indexPath, animateDuration: 0.4)
    }
}

extension MatchesDashboardVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLeagueMatches ?? false {
            return 1
        }else {
            return sectionTitle.count
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isLeagueMatches ?? false {
            return nil
        }else {
            return sectionTitle[section]
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
            headerView.textLabel?.textColor = .base
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 15)
            headerView.textLabel?.textAlignment = .left
            headerView.textLabel?.frame.size.width = tableView.frame.width
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLeagueMatches ?? false {
            return leagueMatchArray.count
        }else {
            switch section {
            case 0:
                return liveMatchArray.count
            case 1:
                return upcomingMatchArray.count
            default:
                return finishedMatchArray.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentToViewController(GlobalMatchDetailVC.self, storyboardName: StoryboardName.matches, animationType: .autoReverse(presenting: .zoom)) { [self] vc in
            if isLeagueMatches ?? false {
                configureDidSelectTableCell(vc: vc, array: leagueMatchArray[indexPath.row])
                vc.isFootball = isFootball
            }else {
                switch indexPath.section {
                case 0:
                    configureDidSelectTableCell(vc: vc, array: liveMatchArray[indexPath.row])
                case 1:
                    configureDidSelectTableCell(vc: vc, array: upcomingMatchArray[indexPath.row])
                default:
                    configureDidSelectTableCell(vc: vc, array: finishedMatchArray[indexPath.row])
                }
                vc.isFootball = isFootball
            }
        }
    }
}

extension MatchesDashboardVC {
    private func tableCell(indexPath:IndexPath) -> GlobalMatchesTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.globalMatchesTableViewCell, for: indexPath) as! GlobalMatchesTableViewCell
        
        if isLeagueMatches ?? false {
            congifureCell(cell: cell, matches: leagueMatchArray[indexPath.row])
        }else {
            switch indexPath.section {
            case 0:
                congifureCell(cell: cell, matches: liveMatchArray[indexPath.row])
            case 1:
                congifureCell(cell: cell, matches: upcomingMatchArray[indexPath.row])
            default:
                congifureCell(cell: cell, matches: finishedMatchArray[indexPath.row])
            }
        }
        return cell
    }
    
    func congifureCell(cell: GlobalMatchesTableViewCell, matches: GlobalMatchList) {
        cell.leagueImageView.setImage(imageStr: matches.leagueInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.homeImageView.setImage(imageStr: matches.homeInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.awayImageView.setImage(imageStr: matches.awayInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.homeNameLabel.text = matches.homeInfo?.name ?? ""
        cell.awayNameLabel.text = matches.awayInfo?.name ?? ""
        
        if isFootball ?? true {
            cell.leagueNameLabel.text = "\(matches.leagueInfo?.name ?? "") | Round \(matches.round?.round ?? 0)"
            cell.cornerLabel.text = "Corners: \(matches.homeInfo?.cornerScore ?? 0)-\(matches.awayInfo?.cornerScore ?? 0)"
            cell.scoreLabel.text = "Score: \(matches.homeInfo?.homeScore ?? 0)-\(matches.awayInfo?.awayScore ?? 0)"
            cell.halftimeLabel.isHidden = false
            cell.halftimeLabel.text = "Halftime: \(matches.homeInfo?.halfTimeScore ?? 0)-\(matches.awayInfo?.halfTimeScore ?? 0)"
        }else {
            cell.leagueNameLabel.text = matches.leagueInfo?.name ?? ""
            cell.cornerLabel.text = "Position: \(matches.matchPosition?.home ?? "")-\(matches.matchPosition?.away ?? "")"
            cell.scoreLabel.text = "Overtime Score: \(matches.homeInfo?.overtimeScore ?? 0)-\(matches.awayInfo?.overtimeScore ?? 0)"
            cell.halftimeLabel.isHidden = true
        }
    }
    
    func configureDidSelectTableCell(vc: GlobalMatchDetailVC, array: GlobalMatchList) {
        vc.match = array
        vc.matchId = array.id ?? ""
        vc.leagueName = array.leagueInfo?.name ?? ""
        vc.leagueLogo = array.leagueInfo?.logo ?? ""
    }
}


