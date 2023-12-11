//
//  CardGameMyTeamVC.swift
//  RedDragon
//
//  Created by QASR02 on 27/11/2023.
//

import UIKit
import Toast
import Combine

class CardGameMyTeamVC: UIViewController {
    
    @IBOutlet weak var playAgainstLabel: UILabel!
    @IBOutlet weak var computerLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var myTeaamLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var budgetView: UIView!
    
    var cancellabel = Set<AnyCancellable>()
    var teamListVM: MyTeamViewModel?
    var budgetClass = BudgetCalculation()
    var updateInfoVM = UpdateInfoViewModel()
    var playerSoldOut: Bool? = nil
    var againstComputer: Bool?
    var userBudget_afterPlayerSold: Double? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFunctionality()
    }
    
    private func loadFunctionality() {
        budgetView.isHidden = true
        nibInitialization()
        addActivityIndicator()
        fetchMyTeamViewModel()
        fetchUserUpdatedBudget()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func playerButton(_ sender: Any) {
        navigateToViewController(AllPlayersViewController.self, storyboardName: StoryboardName.cardGame)
    }
    
    @IBAction func leaderboardButton(_ sender: Any) {
        navigateToViewController(LeaderboardViewController.self, storyboardName: StoryboardName.cardGame)
    }
    
    @IBAction func playAgainstComputer(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "gameEnd")
        againstComputer = true
        fetchPlayersID(teamListVM?.responseData)
    }
    
    func fetchPlayersID(_ team: MyTeam?) {
        if let team = team {
            let playerIDs = team.map { $0.playerID }
            if playerIDs.count < 11 {
                customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.addPlayerToPlay.localized, image: ImageConstants.alertImage)
            } else {
                presentToViewController(GameViewController.self, storyboardName: StoryboardName.cardGameMatch) { [self] vc in
                    vc.playersIDs = playerIDs
                    vc.againstComputer = againstComputer
                }
            }
        }
    }
    
    @IBAction func playAgainstFriends(_ sender: Any) {
        navigateToViewController(LeaderboardViewController.self, storyboardName: StoryboardName.cardGame)
    }
}

extension CardGameMyTeamVC {
    
    private func fetchMyTeamViewModel() {
        teamListVM = MyTeamViewModel()
        teamListVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.error.localized, description: error, image: ImageConstants.alertImage)
        }
        teamListVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        teamListVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] team in
                self?.collectionView.reloadData()
                ///API call to update user budget
                if self?.playerSoldOut == true {
                    self?.makeNetworkCall_toUpdateBudget(self?.userBudget_afterPlayerSold ?? 0)
                }
            })
            .store(in: &cancellabel)
        
        makeAyncCall()
    }
    
    private func makeAyncCall() {
        teamListVM?.fetchmyTeamAsyncCall()
    }
    
    ///user budget update model
    func fetchUserUpdatedBudget() {
        updateInfoVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] response in
                self?.budgetView.isHidden = false
                self?.playerSoldOut = nil
                let budget = UserDefaults.standard.budget!
                self?.budgetLabel.text = "\(self?.formatNumber(Double(budget)) ?? "0")"
                self?.view.makeToast(ErrorMessage.playerRemoved.localized, duration: 2.0, position: .bottom)
            }
            .store(in: &cancellabel)
    }
}

/// __Supportive  functions
extension CardGameMyTeamVC {
    
    private func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    private func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    private func nibInitialization() {
        collectionView.register(CellIdentifier.myTeamCell)
    }
}

extension CardGameMyTeamVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if teamListVM?.responseData?.count == 0 {
            customAlertView(title: ErrorMessage.dataNotFound.localized, description: ErrorMessage.addPlayer.localized, image: ImageConstants.alertImage)
        }
        return teamListVM?.responseData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let list = teamListVM?.responseData else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.myTeamCell, for: indexPath) as! MyTeamCollectionViewCell
        cell.configuration(data: list[indexPath.item])
        let marketValue = Double(list[indexPath.item].marketValue) ?? 0
        cell.priceLabel.text = "\(formatNumber(marketValue))"
        cell.sellButton.tag = indexPath.item
        cell.sellButton.addTarget(self, action: #selector(sellPlayerFunction(sender: )), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animateCollectionView(collectionView, willDisplay: cell, forItemAt: indexPath, animateDuration: 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width/3 - 5, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    ///sell player API call
    @objc func sellPlayerFunction(sender: UIButton) {
        teamListVM?.sellPlayerAsyncCall(playerID: teamListVM?.responseData?[sender.tag].playerID ?? 0)
        playerSoldOut = true
        userBudget_afterPlayerSold = calculateBudget(Double(teamListVM?.responseData?[sender.tag].marketValue ?? "") ?? 0)
        DispatchQueue.main.async { [self] in
            budgetLabel.text = "\(formatNumber(Double(userBudget_afterPlayerSold!)))"
        }
    }
}

extension CardGameMyTeamVC {
    ///calculate user budget after selling player
    func calculateBudget(_ playerValue: Double) -> Double {
        let userBudget = UserDefaults.standard.budget!
        let userFinalBudget = budgetClass.performOperation(Double(userBudget), playerValue, operation: +)
        return userFinalBudget
    }
    
    ///make network call to update user budget
    func makeNetworkCall_toUpdateBudget(_ userFinalBudget: Double) {
        updateInfoVM.updateBudgetAsyncCall(budget: Int(userFinalBudget))
        UserDefaults.standard.budget = Int(userFinalBudget)
    }
    
}


