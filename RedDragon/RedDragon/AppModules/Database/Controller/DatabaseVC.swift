//
//  DatabaseVC.swift
//  RedDragon
//
//  Created by QASR02 on 25/10/2023.
//

import UIKit
import Combine

struct StaticLeague {
    let name: String
    let slug: String
}

class DatabaseVC: UIViewController {
    
    @IBOutlet weak var seasonButton: UIButton!
    @IBOutlet weak var standingsButton: UIButton!
    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    @IBOutlet weak var leaguesCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seasonPerformanceTabelView: UITableView!
    @IBOutlet weak var mainTableViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var mainTableViewLeftConstraint: NSLayoutConstraint!
    
    private var databaseVM: DatabaseViewModel?
    private var cancellable = Set<AnyCancellable>()
    private var fetchCurrentLanguageCode = String()
    private var tableData: [[String]]?
    private var seasonPerformanceNameData: [String]?
    private var selectedIndexPath: IndexPath?
    private var leagues: [StaticLeague] = []
    private var setFlagFor_seasonPerformanceFilters: Bool = false
    private var setFlagFor_standing_events: Bool = false
    private var selectedLeagueSlug: String?
    private let deselectedColor: UIColor = UIColor(red: 255/255, green: 224/255, blue: 138/255, alpha: 1)
    private let selectedColor: UIColor = UIColor(red: 183/255, green: 25/255, blue: 16/255, alpha: 1)
    private let buttonColor_red: UIColor = UIColor(red: 187/255, green: 25/255, blue: 16/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLeagues()
        loadFunctionality()
        makeNetworkCall()
        nibInitialization()
    }
    
    private func setupLeagues() {
        leagues = [
            StaticLeague(name: "Premier League", slug: "england-premier-league"),
            StaticLeague(name: "Bundesliga", slug: "germany-bundesliga"),
            StaticLeague(name: "La Liga", slug: "spain-laliga"),
            StaticLeague(name: "Serie A", slug: "italy-serie-a"),
            StaticLeague(name: "Ligue 1", slug: "france-ligue-1"),
            StaticLeague(name: "UEFA Champions League", slug: "europe-uefa-champions-league"),
            StaticLeague(name: "UEFA Europa League", slug: "europe-uefa-europa-league"),
            StaticLeague(name: "AFC Champions League", slug: "asia-afc-champions-league"),
            StaticLeague(name: "CAF Champions League", slug: "africa-caf-champions-league"),
            StaticLeague(name: "Copa CONMEBOL Libertadores", slug: "south-america-conmebol-libertadores")
        ]
    }
    
    func loadFunctionality() {
        addActivityIndicator()
        configureLanguage()
        configureUI()
        fetchLeagueDetailViewModel()
        switchToStandings()
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.standingTableCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.eventsTableCell)
        defineTableViewNibCell(tableView: seasonPerformanceTabelView, cellName: CellIdentifier.seasonPerfoemanceTableCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func makeNetworkCall() {
        guard Reachability.isConnectedToNetwork() else {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.networkAlert.localized, image: ImageConstants.alertImage)
            return
        }
        databaseVM?.fetchLeagueDetailAsyncCall(lang: fetchCurrentLanguageCode == "en" ? "en" : "zh", 
                                               slug: "england-premier-league",
                                               season: "")
    }
    
    @IBAction func standingsEventsButton(_ sender: UIButton) {
        if sender.tag == 1 {
            switchToStandings()
        } else if sender.tag == 2 {
            switchToEvents()
        }
    }
    
    @IBAction func seasonButton(_ sender: Any) {
    }
}

extension DatabaseVC {
    
    ///fetch view model for league detail
    func fetchLeagueDetailViewModel() {
        databaseVM = DatabaseViewModel()
        databaseVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        databaseVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        databaseVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] leagueData in
                self?.execute_onResponseData(leagueData!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ leagueData: LeagueDetailModel) {
        tableData = (leagueData.data.standings.flatMap { $0.tableData })
        tableView.reloadData()
        seasonButton.setTitle(leagueData.data.season, for: .normal)
        seasonPerformanceNameData = (leagueData.data.seasonPerformance).compactMap { $0.name }
        seasonPerformanceTabelView.reloadData()
    }
}

extension DatabaseVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
        cell.leagueName.text = leagues[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removeData()
        selectedLeagueSlug = leagues[indexPath.item].slug
        databaseVM?.fetchLeagueDetailAsyncCall(lang: fetchCurrentLanguageCode == "en" ? "en" : "zh", slug: leagues[indexPath.item].slug, season: "")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animateCollectionView(collectionView, willDisplay: cell, forItemAt: indexPath, animateDuration: 0.4)
    }
}

extension DatabaseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == seasonPerformanceTabelView {
            return seasonPerformanceNameData?.count ?? 0
        }
        if setFlagFor_standing_events == false {
            return tableData?.count ?? 0
        }
        return databaseVM?.responseData?.data.events.first?.matches.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case seasonPerformanceTabelView:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.seasonPerfoemanceTableCell, for: indexPath) as! SeasonPerformanceTableViewCell
            cell.nameLabel.text = seasonPerformanceNameData?[indexPath.row]
            configureSeasonPerformanceCell(cell, at: indexPath)
            return cell
            
        default:
            if setFlagFor_standing_events == false {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.standingTableCell, for: indexPath) as! StandingsTableViewCell
                guard let _ = databaseVM?.responseData?.data.standings[indexPath.section] else {
                    return UITableViewCell()
                }
                if let data = tableData?[indexPath.row] {
                    if setFlagFor_seasonPerformanceFilters {
                        cell.numberLabel.text = "\(indexPath.row + 1)"
                        cell.configurationForFilters(data)
                    } else {
                        cell.configuration(data)
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.eventsTableCell, for: indexPath) as! EventsTableViewCell
                guard let data = databaseVM?.responseData?.data.events[0].matches[indexPath.row] else {
                    return UITableViewCell()
                }
                cell.configureCell(data)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == seasonPerformanceTabelView {
            
            setFlagFor_seasonPerformanceFilters = true
            updateTableData(with: indexPath)
            updateHeaderLabels(at: indexPath)
            
            if let previouslySelectedIndexPath = selectedIndexPath {
                let previouslySelectedCell = tableView.cellForRow(at: previouslySelectedIndexPath) as? SeasonPerformanceTableViewCell
                previouslySelectedCell?.nameLabel.textColor = .black
                previouslySelectedCell?.backgroundColor = deselectedColor
            }
            selectedIndexPath = indexPath
            let selectedCell = tableView.cellForRow(at: indexPath) as? SeasonPerformanceTableViewCell
            selectedCell?.nameLabel.textColor = .white
            selectedCell?.backgroundColor = selectedColor
        }
        else {
            if setFlagFor_standing_events == true {
                navigateToViewController(MatchDetailsVC.self, storyboardName: StoryboardName.matchDetail) { vc in
                    vc.matchSlug = self.databaseVM?.responseData?.data.events[0].matches[indexPath.row].slug
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == seasonPerformanceTabelView {
            let deselectedCell = tableView.cellForRow(at: indexPath) as? SeasonPerformanceTableViewCell
            deselectedCell?.nameLabel.textColor = .black
            deselectedCell?.backgroundColor = deselectedColor
        }
    }
}

/// __Supportive function calls

extension DatabaseVC {
    
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }

    func configureLanguage() {
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang == "en-US") ? "en" : lang
        fetchCurrentLanguageCode = lang
    }

    func configureUI() {
        standingsButton.setTitleColor(buttonColor_red, for: .normal)
        highlightFirstIndex_collectionView()
        mainTableViewTopConstraints.constant = 50
        mainTableViewLeftConstraint.constant = 100
        self.view.layoutIfNeeded()
    }
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        leaguesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(leaguesCollectionView, didSelectItemAt: indexPath)
    }
    
    ///on standing button click
    func switchToStandings() {
        standingsButton.setTitleColor(buttonColor_red, for: .normal)
        eventsButton.setTitleColor(UIColor.black, for: .normal)
        setFlagFor_seasonPerformanceFilters = false
        databaseVM?.fetchLeagueDetailAsyncCall(
            lang: fetchCurrentLanguageCode == "en" ? "en" : "zh",
            slug: selectedLeagueSlug ?? "england-premier-league",
            season: ""
        )
        removeData()
        mainTableViewTopConstraints.constant = 50
        mainTableViewLeftConstraint.constant = 100
        setFlagFor_standing_events = false
        tableView.setContentOffset(.zero, animated: true)
        self.view.layoutIfNeeded()
    }

    ///on switch button click
    func switchToEvents() {
        tableView.reloadData()
        eventsButton.setTitleColor(buttonColor_red, for: .normal)
        standingsButton.setTitleColor(UIColor.black, for: .normal)
        mainTableViewTopConstraints.constant = 2
        mainTableViewLeftConstraint.constant = 10
        setFlagFor_standing_events = true
        tableView.setContentOffset(.zero, animated: true)
        self.view.layoutIfNeeded()
    }
    
    func removeData() {
        tableData?.removeAll()
        tableView.reloadData()
        selectedIndexPath = nil
        seasonPerformanceNameData?.removeAll()
        seasonPerformanceTabelView.reloadData()
        seasonButton.setTitle("--", for: .normal)
        setFlagFor_seasonPerformanceFilters = false
        
        teamLabel.text = StringConstants.team.localized
        pointsLabel.text = StringConstants.points.localized
        winLabel.text = StringConstants.win.localized
        loseLabel.text = StringConstants.lose.localized
        drawLabel.text = StringConstants.draw.localized
    }
    
    func configureSeasonPerformanceCell(_ cell: SeasonPerformanceTableViewCell, at indexPath: IndexPath) {
        let isSelected = indexPath == selectedIndexPath
        cell.nameLabel.textColor = isSelected ? .white : .black
        cell.backgroundColor = isSelected ? selectedColor : deselectedColor
    }
    
    func updateTableData(with indexPath: IndexPath) {
        let data = databaseVM?.responseData?.data.seasonPerformance[indexPath.row].data
        tableData?.removeAll()
        tableData = data
        self.tableView.reloadData()
    }
    
    func updateHeaderLabels(at indexPath: IndexPath) {
        guard let subheader = databaseVM?.responseData?.data.seasonPerformance[indexPath.row].subheader else {
            return
        }
        teamLabel.text = String(describing: subheader[2])
        pointsLabel.text = String(describing: subheader[3])
        winLabel.text = String(describing: subheader[4])
        loseLabel.text = String(describing: subheader[5])
        drawLabel.text = String(describing: subheader[6])
    }
    
}

