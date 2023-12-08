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
    
    var cancellable = Set<AnyCancellable>()
    var selectedSegment: sportCategorySegment = .hottest
    var sectionTitle = ["Live Matches", "Upcoming Matches", "Past Matches"]
    var leagueArray: [HotLeagues] = []
    var liveMatchArray: [GlobalMatchList] = []
    var finishedMatchArray: [GlobalMatchList] = []
    var upcomingMatchArray: [GlobalMatchList] = []
    private var liveMatchesVM: FootballLiveMatchesViewModel?
    private var finishedMatchesVM: FootballFinishedMatchesViewModel?
    private var upcomingMatchesVM: FootballUpcomingMatchesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        nibInitialization()
        makeNetworkCall()
        highlightFirstIndex_collectionView()
    }
    
    func nibInitialization() {
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
        liveMatchesVM = FootballLiveMatchesViewModel()
        finishedMatchesVM = FootballFinishedMatchesViewModel()
        upcomingMatchesVM = FootballUpcomingMatchesViewModel()
        
        liveMatchesVM?.fetchFootballLiveMatches()
        finishedMatchesVM?.fetchFootballFinishedMatches()
        upcomingMatchesVM?.fetchFootballUpcomingMatches()
        fetchViewModelResponse()
    }
}

// MARK: - Network Related Response
extension MatchesDashboardVC {
    ///fetch view model for user list
    func fetchViewModelResponse() {
        liveMatchesVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        liveMatchesVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        liveMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onLiveMatchesResponse(response!)
            })
            .store(in: &cancellable)
        
        finishedMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onFinishedMatchesResponse(response!)
            })
            .store(in: &cancellable)
        
        upcomingMatchesVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onUpcomingMatchesResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onLiveMatchesResponse(_ response: GlobalEventsModel) {
        liveMatchArray = response.matchList ?? []
        leagueArray = response.hotLeagues ?? []
    }
    
    func execute_onFinishedMatchesResponse(_ response: GlobalEventsModel) {
        finishedMatchArray = response.matchList ?? []
    }
    
    func execute_onUpcomingMatchesResponse(_ response: GlobalEventsModel) {
        upcomingMatchArray = response.matchList ?? []
    }
}

// MARK: - CollectionView Delegates
extension MatchesDashboardVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return meetHeaderSegment.allCases.count
        }else { // leagueCollectionView
            return (leagueArray.count) + 1 // +1 for "All"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
            cell.configureUnderLineCell(title: meetHeaderSegment.allCases[indexPath.item].rawValue, selected: selectedSegment == sportCategorySegment.allCases[indexPath.item])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
            if indexPath.item == 0{
                cell.leagueName.text = "All"
            }else {
                cell.leagueName.text = leagueArray[indexPath.item - 1].nameEnShort
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegment = sportCategorySegment.allCases[indexPath.row]
        if collectionView == headerCollectionView {
            switch indexPath.item {
            case 0:
                segmentControl.isHidden = false
                
            case 1:
                segmentControl.isHidden = true
            case 2:
                segmentControl.isHidden = true
            default:
                segmentControl.isHidden = true
            }
            collectionView.reloadData()
        }else {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            let selected = selectedSegment == sportCategorySegment.allCases[indexPath.item]
            return CGSize(width: sportCategorySegment.allCases[indexPath.item].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 26, height: 50)
        }else {
            return CGSize(width: (leagueArray[indexPath.item-1].nameEnShort?.localized.size(withAttributes: [NSAttributedString.Key.font : fontBold(17)]).width)!, height: 45)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animateCollectionView(collectionView, willDisplay: cell, forItemAt: indexPath, animateDuration: 0.4)
    }
}

extension MatchesDashboardVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitle.count
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
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
        switch section {
        case 0:
            return liveMatchArray.count
        case 1:
            return upcomingMatchArray.count
        default:
            return finishedMatchArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
}

extension MatchesDashboardVC {
    private func tableCell(indexPath:IndexPath) -> GlobalMatchesTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.globalMatchesTableViewCell, for: indexPath) as! GlobalMatchesTableViewCell
        
        switch indexPath.section {
        case 0:
            congifureCell(cell: cell, matches: liveMatchArray[indexPath.row])
        case 1:
            congifureCell(cell: cell, matches: upcomingMatchArray[indexPath.row])
        default:
            congifureCell(cell: cell, matches: finishedMatchArray[indexPath.row])
        }
        return cell
    }
    
    func congifureCell(cell: GlobalMatchesTableViewCell, matches: GlobalMatchList) {
        cell.leagueImageView.setImage(imageStr: matches.leagueInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.homeImageView.setImage(imageStr: matches.homeInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.awayImageView.setImage(imageStr: matches.awayInfo?.logo ?? "", placeholder: UIImage(named: "placeholderLeague"))
        
        cell.leagueNameLabel.text = matches.leagueInfo?.name ?? ""
        cell.homeNameLabel.text = matches.homeInfo?.name ?? ""
        cell.awayNameLabel.text = matches.awayInfo?.name ?? ""
       
//        cell.noOfPeopleJoinedLbl.text = "\(event.peopleJoinedCount ?? 0) People joined"
//        let date = event.date?.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.ddMMM) ?? ""
//        cell.dateTimeLbl.text = "\(date), \(event.time ?? "")"
    }
}
