//
//  GlobalMatchDetailVC.swift
//  RedDragon
//
//  Created by iOS Dev on 11/12/2023.
//

import UIKit
import Combine

class GlobalMatchDetailVC: UIViewController {
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var awayImageView: UIImageView!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayNameLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    var headerTitleArray = ["Overview".localized, "Match info".localized, "Odds".localized, "H2H".localized]
    var homeInfoKeyArr = ["half_time_score", "red_cards", "corner_score", "overtime_score", "penalty_score"]
    var awayInfoKeyArr = ["half_time_score", "red_card", "yellow_cards", "corner_score", "overtime_score", "penalty_score"]
    var basketballSectionKeyArr = ["section_1","section_2","section_3","section_4","overtime_score"]
    var oddsHeaderTitleArr = ["Asia".localized, "Euro".localized, "BigSmall".localized]
    var basketballSectionHomeValueArr = [Int]()
    var basketballSectionAwayValueArr = [Int]()
    var homeInfoValueArr = [Int]()
    var awayInfoValueArr = [Int]()
    var coverageKeyArr = [String]()
    var coverageValueArr = [String]()
    var roundKeyArr = [String]()
    var roundValueArr = [String]()
    var environmentKeyArr = [String]()
    var environmentValueArr = [String]()
    var selectedIndex = 0
    var positionKeyArr = ["home_position", "away_position"]
    var positionValueArr = [String]()
    var infoKeyArr = [String]()
    var infoValueArr = [String]()
    var matchId = String()
    var leagueName = String()
    var leagueLogo = String()
    var match = GlobalMatchList()
    var isFootball: Bool? = true
    var cancellable = Set<AnyCancellable>()
    var footballH2HMatchesViewModel = FootballH2HMatchesViewModel()
    var basketballH2HMatchesViewModel = BasketballH2HMatchesViewModel()
    var matchForH2HArr = [MatchInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func performInitialSetup() {
        nibInitialization()
        highlightFirstIndex_collectionView()
        fetchFBH2HViewModelResponse()
        fetchBBH2HViewModelResponse()
       
        let homeDict = match.homeInfo?.dictionary ?? [:]
        if isFootball ?? true {
            for i in homeInfoKeyArr {
                homeInfoValueArr.append(homeDict[i] as? Int ?? 0)
            }
            homeInfoValueArr.insert(0, at: 2)
        }else {
            for i in basketballSectionKeyArr {
                basketballSectionHomeValueArr.append(homeDict[i]as? Int ?? 0)
            }
        }
        
        let awayDict = match.awayInfo?.dictionary ?? [:]
        if isFootball ?? true {
            for i in awayInfoKeyArr {
                awayInfoValueArr.append(awayDict[i] as? Int ?? 0)
            }
        }else {
            for i in basketballSectionKeyArr {
                basketballSectionAwayValueArr.append(homeDict[i]as? Int ?? 0)
            }
        }
        
        if isFootball ?? true {
            positionValueArr.append(match.homePosition ?? "--")
            positionValueArr.append(match.awayPosition ?? "--")
        }else {
            let positionDict = match.matchPosition?.dictionary ?? [:]
            if positionDict.isEmpty {
                positionValueArr.append("__")
                positionValueArr.append("__")
            }else {
                for i in positionDict {
                    positionValueArr.append(i.value as? String ?? "")
                }
            }
        }
        
        if ((match.coverage?.dictionary.isEmpty) == false) {
            for (key,value) in match.coverage?.dictionary ?? [:] {
                coverageKeyArr.append(key)
                coverageValueArr.append("\(value)")
            }
        }
        
        if ((match.round?.dictionary.isEmpty) == false) {
            for (key,value) in match.round?.dictionary ?? [:] {
                roundKeyArr.append(key)
                roundValueArr.append("\(value)")
            }
        }
        
        if ((match.environment?.dictionary.isEmpty) == false) {
            for (key,value) in match.environment?.dictionary ?? [:] {
                environmentKeyArr.append(key)
                environmentValueArr.append("\(value)")
            }
        }
        
        infoKeyArr = coverageKeyArr + roundKeyArr + environmentKeyArr + positionKeyArr
        infoValueArr = coverageValueArr + roundValueArr + environmentValueArr + positionValueArr
        
        let homeImage = match.homeInfo?.logo ?? ""
        let awayImage = match.awayInfo?.logo ?? ""
        
        homeImageView.setImage(imageStr: homeImage, placeholder: .placeholderLeague)
        awayImageView.setImage(imageStr: awayImage, placeholder: .placeholderLeague)
        homeNameLabel.text = match.homeInfo?.name ?? ""
        awayNameLabel.text = match.awayInfo?.name ?? ""
        homeScoreLabel.text = "\(match.homeInfo?.homeScore ?? 0)"
        awayScoreLabel.text = "\(match.awayInfo?.awayScore ?? 0)"
    }
    
    func nibInitialization() {
        headerCollectionView.register(HeaderTopCollectionViewCell.nibName)
        tableView.register(CellIdentifier.globalMatchInfoTableViewCell)
        tableView.register(CellIdentifier.globalMatchOddsTableViewCell)
        tableView.register(CellIdentifier.globalMatchHeadToHeadTableViewCell)
    }
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        headerCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(headerCollectionView, didSelectItemAt: indexPath)
    }
}

// MARK: - CollectionView Delegates
extension GlobalMatchDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderTopCollectionViewCell.reuseIdentifier, for: indexPath) as! HeaderTopCollectionViewCell
        cell.configureUnderLineCell(title: headerTitleArray[indexPath.item], selected: selectedIndex == indexPath.item, textColor: .base)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        
        if selectedIndex == 3 {
            if isFootball ?? true {
                footballH2HMatchesViewModel.fetchFootballH2HMatches(matchId: matchId)
             //   fetchFBH2HViewModelResponse()
            }else {
                basketballH2HMatchesViewModel.fetchBasketballH2HMatches(matchId: matchId)
             //   fetchBBH2HViewModelResponse()
            }
        }
        collectionView.reloadData()
        tableView.separatorStyle = .singleLine
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selected = selectedIndex == indexPath.item
        return CGSize(width: headerTitleArray[indexPath.item].localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 15, height: 50)
    }
}

// MARK: - TableView Data source and Delegates
extension GlobalMatchDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedIndex {
        case 0:
            if isFootball ?? true {
                return awayInfoKeyArr.count
            }else {
                return basketballSectionKeyArr.count
            }
            
        case 1:
            return infoKeyArr.count
            
        case 2:
            return oddsHeaderTitleArr.count
            
        default:
            return matchForH2HArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedIndex {
        case 0:
            return tableCell(indexPath: indexPath)
        case 1:
            return tableCell(indexPath: indexPath)
        case 2:
            return tableOddsCell(indexPath: indexPath)
        default:
            return tableH2HCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedIndex {
        case 0:
            return 40.0
        case 1:
            return 40.0
        case 2:
            return 100.0
        default:
            return 88.0
        }
    }
}

// MARK: - TableView Data handling
extension GlobalMatchDetailVC {
    private func tableCell(indexPath:IndexPath) -> GlobalMatchInfoTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.globalMatchInfoTableViewCell, for: indexPath) as! GlobalMatchInfoTableViewCell
        
        switch selectedIndex {
        case 0:
            cell.indicatorHeadingLabel.isHidden = false
            
            if isFootball ?? true {
                cell.indicatorHeadingLabel.text = awayInfoKeyArr[indexPath.row].replacingOccurrences(of: "_", with: " ", options: .regularExpression, range: nil).capitalized.localized
                cell.homeLabel.text = "\(homeInfoValueArr[indexPath.row])"
                cell.awayLabel.text = "\(awayInfoValueArr[indexPath.row])"
            }else {
                cell.indicatorHeadingLabel.text = basketballSectionKeyArr[indexPath.row].replacingOccurrences(of: "_", with: " ", options: .regularExpression, range: nil).capitalized.localized
                cell.homeLabel.text = "\(basketballSectionHomeValueArr[indexPath.row])"
                cell.awayLabel.text = "\(basketballSectionAwayValueArr[indexPath.row])"
            }
            
        case 1:
            cell.indicatorHeadingLabel.isHidden = true
            cell.homeLabel.text = infoKeyArr[indexPath.row].replacingOccurrences(of: "_", with: " ", options: .regularExpression, range: nil).capitalized.localized
            cell.awayLabel.text = infoValueArr[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    private func tableOddsCell(indexPath:IndexPath) -> GlobalMatchOddsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.globalMatchOddsTableViewCell, for: indexPath) as! GlobalMatchOddsTableViewCell
        cell.headingLabel.text = oddsHeaderTitleArr[indexPath.row]
        switch indexPath.row {
        case 0:
            configOddsTableCell(cell, score: match.odds?.header?.asia)
        case 1:
            configOddsTableCell(cell, score: match.odds?.header?.euro)
        default:
            configOddsTableCell(cell, score: match.odds?.header?.bigSmall)
        }
        return cell
    }
    
    func configOddsTableCell(_ cell: GlobalMatchOddsTableViewCell, score: Score?) {
        cell.homeLabel.text = "\(score?.home ?? 0.0)"
        cell.awayLabel.text = "\(score?.away ?? 0.0)"
        cell.handicapLabel.text = "\(score?.handicap ?? 0.0)"
    }
    
    private func tableH2HCell(indexPath:IndexPath) -> GlobalMatchHeadToHeadTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.globalMatchHeadToHeadTableViewCell, for: indexPath) as! GlobalMatchHeadToHeadTableViewCell
        cell.leagueNameLabel.text = leagueName
        cell.leagueImageView.setImage(imageStr: leagueLogo, placeholder: UIImage(named: "placeholderLeague"))
        cell.homeNameLabel.text = matchForH2HArr[indexPath.row].homeName
        cell.awayNameLabel.text = matchForH2HArr[indexPath.row].awayName
        cell.overtimeLabel.text = "Overtime".localized + ":" + "\(matchForH2HArr[indexPath.row].homeOvertimeScore ?? 0)-\(matchForH2HArr[indexPath.row].awayOvertimeScore ?? 0)"
        cell.halftimeLabel.text = "Ranking".localized + ":" + "\(matchForH2HArr[indexPath.row].homeRanking ?? "" )-\(matchForH2HArr[indexPath.row].awayRanking ?? "")"
    
        return cell
    }
}

// MARK: - Network Related Response
extension GlobalMatchDetailVC {
    func fetchFBH2HViewModelResponse() {
        footballH2HMatchesViewModel.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        footballH2HMatchesViewModel.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        
        footballH2HMatchesViewModel.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onFBH2HMatchResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    func fetchBBH2HViewModelResponse() {
        basketballH2HMatchesViewModel.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        basketballH2HMatchesViewModel.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        
        basketballH2HMatchesViewModel.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onBBH2HMatchResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onFBH2HMatchResponse(_ response: H2HMatchListModel) {
        matchForH2HArr = (response.history?.homeMatchInfo ?? []) + (response.history?.awayMatchInfo ?? [])
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    func execute_onBBH2HMatchResponse(_ response: H2HMatchListModel) {
        matchForH2HArr = (response.history?.homeMatchInfo ?? []) + (response.history?.awayMatchInfo ?? [])
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
}
