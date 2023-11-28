//
//  CardGameMyTeamVC.swift
//  RedDragon
//
//  Created by QASR02 on 27/11/2023.
//

import UIKit
import Combine

class CardGameMyTeamVC: UIViewController {
    
    @IBOutlet weak var playAgainstLabel: UILabel!
    @IBOutlet weak var computerLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var myTeaamLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cancellabel = Set<AnyCancellable>()
    var teamListVM: MyTeamViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFunctionality()
    }
    
    private func loadFunctionality() {
        nibInitialization()
        addActivityIndicator()
        fetchMyTeamViewModel()
    }
    
    private func nibInitialization() {
        collectionView.register(CellIdentifier.myTeamCell)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func playerButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func leaderboardButton(_ sender: Any) {
    }
    
}

extension CardGameMyTeamVC {
    
    private func fetchMyTeamViewModel() {
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
                print(team as Any)
                self?.collectionView.reloadData()
            })
            .store(in: &cancellabel)
        
        teamListVM?.fetchmyTeamAsyncCall()
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
        CGSize(width: collectionView.bounds.width/2 - 5, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    ///sell player API call
    @objc func sellPlayerFunction(sender: UIButton) {
//        teamListVM?.sellPlayerAsyncCall(playerID: teamListVM?.responseData?[sender.tag].playerID ?? 0)
//        playerSoldOut = true
//        userBudget_afterPlayerSold = calculateBudget(Double(teamListVM?.responseData?[sender.tag].marketValue ?? "") ?? 0)
//        DispatchQueue.main.async { [self] in
//            budgetLabel.text = "\(formatNumber(Double(userBudget_afterPlayerSold!)))"
//        }
    }
}

