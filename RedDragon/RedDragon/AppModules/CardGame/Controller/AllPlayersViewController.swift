//
//  AllPlayersViewController.swift
//  RedDragon
//
//  Created by QASR02 on 20/11/2023.
//

import UIKit
import Hero
import Combine

class AllPlayersViewController: UIViewController {
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var playersListLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var search = ""
    var cancellable = Set<AnyCancellable>()
    var allPlayersVM: AllFootballPlayersViewModel?
    var fetchCurrentLanguageCode = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    func loadFunctionality() {
        setNavigation()
        addActivityIndicator()
        checkLocalisation()
        fetchAllPlayersViewModel()
        nibInitialization()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.allPlayersTableCell)
    }
    
    func makeAPICall() {
        guard Reachability.isConnectedToNetwork() else {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.networkAlert.localized, image: ImageConstants.alertImage)
            return
        }
        allPlayersVM?.performInitialAPICallIfNeeded()
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        allPlayersVM?.setSearchText(searchTextField.text ?? "")
        tableView.reloadData()
    }
}

/// __fetch Players View model 
extension AllPlayersViewController {
    
    func fetchAllPlayersViewModel() {
        allPlayersVM = AllFootballPlayersViewModel.shared ///Singleton shared instance
        allPlayersVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        allPlayersVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        allPlayersVM?.$allPlayers
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] player in
                self?.tableView.reloadData()
            })
            .store(in: &cancellable)
        
        makeAPICall()
    }
}

/// __Supportive function calls
extension AllPlayersViewController {
    
    func setNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    func checkLocalisation() {
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang == "en-US") ? "en" : lang
        fetchCurrentLanguageCode = lang
    }
}

/// __Tableview data implementation
extension AllPlayersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlayersVM?.filteredPlayers.count ?? allPlayersVM?.allPlayers?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let players = allPlayersVM?.filteredPlayers ?? allPlayersVM?.allPlayers?.data
        guard let player = players?[indexPath.row] else {
            return UITableViewCell()
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifier.allPlayersTableCell, for: indexPath) as! AllPlayersTableViewCell
        cell.configure(data: player)
        let marketValue = Int(player.marketValue)
        cell.priceLabel.text = formatNumber(Double(marketValue ?? 0))
        //cell.buyButton.tag = indexPath.row
        //cell.buyButton.addTarget(self, action: #selector(buyButtonFunction(sender:)), for: .touchUpInside)
        cell.heroID = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animateTabelCell(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? AllPlayersTableViewCell
        cell?.playerImageView.heroID = nil
        cell?.playerNameLabel.heroID = nil
        
        if let player = allPlayersVM?.filteredPlayers[indexPath.row] ?? allPlayersVM?.allPlayers?.data[indexPath.row] {
            
            navigateToViewController(CardGamePlayerDetailVC.self, storyboardName: StoryboardName.cardGame) { vc in
                vc.slug = player.slug
//                vc.defaultImage = player.photo
//                vc.playerName = player.name
//                vc.position = player.positionName
//                vc.value = player.marketValue
//                //hero transmission
//                cell?.playerImageView.heroID = player.photo
//                cell?.playerNameLabel.heroID = player.name
            }
        }
    }
    
}
