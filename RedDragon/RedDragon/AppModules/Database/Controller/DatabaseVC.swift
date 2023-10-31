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
    
    var databaseVM: DatabaseViewModel?
    var cancellable = Set<AnyCancellable>()
    var fetchCurrentLanguageCode = String()
    var tableData: [[String]]?
    var seasonPerformanceNameData: [String]?
    var selectedIndexPath: IndexPath?
    private var leagues: [StaticLeague] = []

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
        self.view.addSubview(Loader.activityIndicator)
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language)  ?? "en"
        lang = (lang == "en-US") ? "en" : lang
        fetchCurrentLanguageCode = lang
        standingsButton.setTitleColor(UIColor(red: 187/255, green: 25/255, blue: 16/255, alpha: 1), for: .normal)
        fetchLeagueDetailViewModel()
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        leaguesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(leaguesCollectionView, didSelectItemAt: indexPath)
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.standingTableCell)
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
        databaseVM?.fetchLeagueDetailAsyncCall(lang: fetchCurrentLanguageCode == "en" ? "en" : "zh", slug: "england-premier-league", season: "")
    }
    
    @IBAction func standingsEventsButton(_ sender: UIButton) {
        if sender.tag == 1 {
            standingsButton.setTitleColor(UIColor(red: 187/255, green: 25/255, blue: 16/255, alpha: 1), for: .normal)
            eventsButton.setTitleColor(UIColor.black, for: .normal)
        } else if sender.tag == 2 {
            eventsButton.setTitleColor(UIColor(red: 187/255, green: 25/255, blue: 16/255, alpha: 1), for: .normal)
            standingsButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func seasonButton(_ sender: Any) {
    }
    
    func removeData() {
        tableData?.removeAll()
        tableView.reloadData()
        selectedIndexPath = nil
        seasonPerformanceNameData?.removeAll()
        seasonPerformanceTabelView.reloadData()
        seasonButton.setTitle("--", for: .normal)
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
                self?.tableData = (leagueData?.data.standings.flatMap { $0.tableData })!
                self?.tableView.reloadData()
                self?.seasonButton.setTitle(leagueData?.data.season, for: .normal)
                self?.seasonPerformanceNameData = (leagueData?.data.seasonPerformance ?? []).compactMap { $0.name }
                self?.seasonPerformanceTabelView.reloadData()
            })
            .store(in: &cancellable)
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
        } else {
            return tableData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == seasonPerformanceTabelView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.seasonPerfoemanceTableCell, for: indexPath) as! SeasonPerformanceTableViewCell
            cell.nameLabel.text = seasonPerformanceNameData?[indexPath.row]
            configureSeasonPerformanceCell(cell, at: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.standingTableCell, for: indexPath) as! StandingsTableViewCell
            guard let _ = databaseVM?.responseData?.data.standings[indexPath.section] else {
                return UITableViewCell()
            }
            if let data = tableData?[indexPath.row] {
                cell.configuration(data)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == seasonPerformanceTabelView {
            if let previouslySelectedIndexPath = selectedIndexPath {
                let previouslySelectedCell = tableView.cellForRow(at: previouslySelectedIndexPath) as? SeasonPerformanceTableViewCell
                previouslySelectedCell?.nameLabel.textColor = .black
                previouslySelectedCell?.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 138/255, alpha: 1)
            }
            selectedIndexPath = indexPath
            let selectedCell = tableView.cellForRow(at: indexPath) as? SeasonPerformanceTableViewCell
            selectedCell?.nameLabel.textColor = .white
            selectedCell?.backgroundColor = UIColor(red: 183/255, green: 25/255, blue: 16/255, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == seasonPerformanceTabelView {
            let deselectedCell = tableView.cellForRow(at: indexPath) as? SeasonPerformanceTableViewCell
            deselectedCell?.nameLabel.textColor = .black
            deselectedCell?.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 138/255, alpha: 1)
        }
    }
    
    func configureSeasonPerformanceCell(_ cell: SeasonPerformanceTableViewCell, at indexPath: IndexPath) {
        let isSelected = indexPath == selectedIndexPath
        cell.nameLabel.textColor = isSelected ? .white : .black
        cell.backgroundColor = isSelected ? UIColor(red: 183/255, green: 25/255, blue: 16/255, alpha: 1) : UIColor(red: 255/255, green: 224/255, blue: 138/255, alpha: 1)
    }
}


