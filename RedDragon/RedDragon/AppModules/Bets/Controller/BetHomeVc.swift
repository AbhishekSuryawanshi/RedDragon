//
//  BetHomeVc.swift
//  RedDragon
//
//  Created by Qoo on 13/11/2023.
//

import UIKit
import SideMenu
import Combine


class BetHomeVc: UIViewController {
    
    @IBOutlet var pointsLable: UILabel!
    var viewModelBet = BetsHomeViewModel()
    var viewModel = BetMatchesHomeViewModel()
    var selectedType : BetsTitleCollectionView = .All
    var matchesList : [MatchesList]?
    var liveMatchesList : [MatchesList]?
    var winBets: [BetItem]? = []
    var loseBets: [BetItem]? = []
    private var fetchCurrentLanguageCode = String()
    private var cancellable = Set<AnyCancellable>()

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initial()
        configureLanguage()
        networkCall()
        fetchBetMetches()
        fetchBets()
        
        // notification
        NotificationCenter.default.addObserver(self, selector: #selector(selectedSport), name: NSNotification.selectedSport, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set points from user defaults
        pointsLable.text = UserDefaults.standard.points ?? "00"
    }

    func initial(){
        tableView.register(CellIdentifier.betMatchTableVC)
        tableView.register(CellIdentifier.betWinTableVC)
        tableView.register(CellIdentifier.betLoseTableVC)
        collectionView.register(CellIdentifier.homeTitleCollectionVc)
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)

    }
    
    func networkCall(){
        switch (selectedType){
            
        case .All:
            if matchesList?.count ?? 0 > 0 {
                tableView.reloadData()
            }else{
                viewModel.fetchAllMatchesAsyncCall(sport: UserDefaults.standard.sport ?? Sports.football.title.lowercased(), lang: fetchCurrentLanguageCode == "en" ? "en" : "zh", day: "tommorow")
            }
        case .Live:
            if liveMatchesList?.count ?? 0 > 0 {
                tableView.reloadData()
            }else{
                viewModel.fetchAllMatchesAsyncCall(sport: UserDefaults.standard.sport ?? Sports.football.title.lowercased(), lang: fetchCurrentLanguageCode == "en" ? "en" : "zh", day: "today")
            }
        case .Win:
            if winBets?.count ?? 0 > 0 {
                tableView.reloadData()
            }else{
                viewModelBet.fetchAllBetsAsyncCall()
            }
        case .Lose:
            if loseBets?.count ?? 0 > 0 {
                tableView.reloadData()
            }else{
                viewModelBet.fetchAllBetsAsyncCall()
            }
        }
    }
    
    @objc func selectedSport(){
        // when user update sport type from side menu
        matchesList?.removeAll()
        liveMatchesList?.removeAll()
        if selectedType == .All || selectedType == .Live {
            networkCall()
        }
    }

    // MARK: - Navigation

     @IBAction func btnMenu(_ sender: Any) {
         presentOverViewController(SideMenuNavigationController.self, storyboardName: StoryboardName.bets, identifier: "SideNav")
     }
     
    
    @IBAction func goToPoints(_ sender: Any) {
        navigateToViewController(PointsVc.self, storyboardName: StoryboardName.bets, animationType: .autoReverse(presenting: .zoom))
    }
}

// collection view for titles
extension BetHomeVc : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.homeTitles.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.homeTitleCollectionVc, for: indexPath) as! HomeTitleCollectionVc
        cell.titleLable.text = viewModel.homeTitles[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedType = viewModel.homeTitles[indexPath.row]
        networkCall()
    }
    
}

// tableview
extension BetHomeVc : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (selectedType){
            
        case .All:
            return matchesList?.count ?? 0
        case .Live:
            return liveMatchesList?.count ?? 0
        case.Win:
            return winBets?.count ?? 0
        case.Lose:
            return loseBets?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(selectedType){
        case .All:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betMatchTableVC) as! BetMatchTableVC
            cell.configurCell(match: matchesList![indexPath.row], isLive: false)
            return cell
            
        case .Live:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betMatchTableVC) as! BetMatchTableVC
            cell.configurCell(match: liveMatchesList![indexPath.row], isLive: true)
            return cell
            
        case .Win:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betWinTableVC) as! BetWinTableVC
            cell.configureCell(item: winBets?[indexPath.row])
            return cell
            
        case .Lose:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betLoseTableVC) as! BetLoseTableVC
            cell.configureCell(item: loseBets?[indexPath.row])
            return cell
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(selectedType){
        case .All:
            navigateToViewController(MatchesListViewController.self, storyboardName: StoryboardName.bets,  animationType: .autoReverse(presenting: .zoom), configure: { vc in
                vc.isLive = false
                vc.matches = self.matchesList![indexPath.row].matches
                vc.matchesList = self.matchesList![indexPath.row]
            })
        case .Live:
            navigateToViewController(MatchesListViewController.self, storyboardName: StoryboardName.bets,  animationType: .autoReverse(presenting: .zoom), configure: { vc in
                vc.isLive = true
                vc.matches = self.liveMatchesList![indexPath.row].matches
                vc.matchesList = self.liveMatchesList![indexPath.row]
            })
            
        default:
            print("N/A")
            
        }
    }
    
}


extension BetHomeVc {
        
        ///fetch view model for bet matches
        func fetchBetMetches() {
            viewModel.showError = { [weak self] error in
                self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
            }
            viewModel.displayLoader = { [weak self] value in
                self?.showLoader(value)
            }
            viewModel.$responseData
                .receive(on: DispatchQueue.main)
                .dropFirst()
                .sink(receiveValue: { [weak self] matches in
                    self?.execute_onResponseData(matches!)
                })
                .store(in: &cancellable)
        }
        
        ///fetch view model for bets
        func fetchBets() {
            viewModelBet.showError = { [weak self] error in
                self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
            }
            viewModelBet.displayLoader = { [weak self] value in
                self?.showLoader(value)
            }
            viewModelBet.$responseData
                .receive(on: DispatchQueue.main)
                .dropFirst()
                .sink(receiveValue: { [weak self] bets in
                    self?.loopWithCompletion(bets!, closure: {
                        self?.tableView.reloadData()
                    })
                })
                .store(in: &cancellable)
        }
        
        func execute_onResponseData(_ matches: MatchListModel) {
          
            if let matchList = matches.response?.data{
            if selectedType == .All{
                matchesList = matches.response?.data
            }else{
                liveMatchesList = matches.response?.data
            }
           tableView.reloadData()
            }else{
                handleError(matches.error)
            }
       
        }
    
    func loopWithCompletion(_ bets: BetListModel, closure: @escaping () -> ()) {
        if let betsList = bets.response?.data?.bets {
            for bet in betsList {
                if bet.betStatus == "1"{
                    self.winBets?.append(bet)
                }else{
                    self.loseBets?.append(bet)
                }
            }
            closure()
        }else{
            handleError(bets.error)
        }
    }
    
    func configureLanguage() {
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang == "en-US") ? "en" : lang
        fetchCurrentLanguageCode = lang
    }
    
    func showLoader(_ value: Bool) {
            value ? startLoader() : stopLoader()
        }
    
    func handleError(_ error :  ErrorResponse?){
        if let error = error {
            if error.messages.first != "Unauthorized user" {
                self.customAlertView(title: ErrorMessage.alert.localized, description: error.messages.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
            }
            else{
                self.customAlertView_2Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                    /// Show login page to login/register new user
                    self.presentOverViewController(LoginVC.self, storyboardName: StoryboardName.login) { vc in
                        vc.delegate = self
                    }
                }
            }
        }
    }

}



/// LoginVCDelegate to refresh data with login user
extension BetHomeVc: LoginVCDelegate {
    func viewControllerDismissed() {
      networkCall()
    }
}
