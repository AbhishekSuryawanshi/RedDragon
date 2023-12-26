//
//  ExpertUserDetailVC.swift
//  RedDragon
//
//  Created by iOS Dev on 23/12/2023.
//

import UIKit
import Combine

class ExpertUserDetailVC: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var allCountLabel: UILabel!
    @IBOutlet weak var successCountLabel: UILabel!
    @IBOutlet weak var unsuccessCountLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var cancellable = Set<AnyCancellable>()
    var userId = Int()
    private var expertPredictUserVM = ExpertPredictionUserDetailViewModel()
    var matchArray = [ExpertPredictionMatch]()
    var userData: ExpertUser?
    var tagData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
        expertPredictUserVM.fetchExpertUserDetailAsyncCall(slug: Slug.predict.rawValue, userId: userId)
        fetchPredictUserDetailViewModelResponse()
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.userDetailPredictMatchesTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func setUpUIData() {
        userImageView.setImage(imageStr: userData?.profileImg ?? "", placeholder: .placeholderUser)
        nameLabel.text = userData?.name
        aboutLabel.text = userData?.about
        winRateLabel.text = "\(userData?.appdata?.predict?.predictStats?.successRate ?? 0)%"
        allCountLabel.text = "Total: \(userData?.appdata?.predict?.predictStats?.allCount ?? 0)"
        successCountLabel.text = "Success: \(userData?.appdata?.predict?.predictStats?.successCount ?? 0)"
        unsuccessCountLabel.text = "Failed: \(userData?.appdata?.predict?.predictStats?.unsuccessCount ?? 0)"
        coinLabel.text = "Coin: \(userData?.appdata?.predict?.predictStats?.coins ?? 0)"
        if userData?.following ?? true {
            followButton.isHidden = true
        }else {
            followingButton.isHidden = true
        }
        
        matchArray = userData?.appdata?.predict?.prediction ?? []
        tagData = userData?.tags ?? []
        collectionView.reloadData()
        tableView.reloadData()
    }
}

// MARK: - TableView Data source and Delegates
extension ExpertUserDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ExpertUserDetailVC {
    func fetchPredictUserDetailViewModelResponse() {
        expertPredictUserVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        expertPredictUserVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        expertPredictUserVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] result in
                self?.userData = result?.response?.data
                self?.setUpUIData()
            })
            .store(in: &cancellable)
    }
    
    private func tableCell(indexPath:IndexPath) -> UserDetailPredictMatchesTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userDetailPredictMatchesTableViewCell, for: indexPath) as! UserDetailPredictMatchesTableViewCell
        cell.leagueNameLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.leagueName
        cell.homeNameLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.homeTeamName
        cell.awayNameLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.awayTeamName
        cell.homeScoreLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.homeScore
        cell.awayScoreLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.awayScore
        cell.homeImageView.setImage(imageStr: userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.homeTeamImage ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.awayImageView.setImage(imageStr: userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.awayTeamImage ?? "", placeholder: UIImage(named: "placeholderLeague"))
        
        if userData?.appdata?.predict?.prediction[indexPath.row].isSuccess ?? false {
            cell.predictionStatusLabel.text = "Correct Prediction"
        }else {
            cell.predictionStatusLabel.text = "Prediction Failed"
        }
        return cell
    }
    
    private func collectionCell(indexPath:IndexPath) -> UserTagsCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.userTagsCollectionViewCell, for: indexPath) as! UserTagsCollectionViewCell
        cell.tagLabel.text = tagData[indexPath.row]
        return cell
    }
}

extension ExpertUserDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionCell(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2)-10, height: 30)
    }
}
