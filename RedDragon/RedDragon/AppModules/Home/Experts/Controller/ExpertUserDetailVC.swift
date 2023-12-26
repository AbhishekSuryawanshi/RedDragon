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
    var commentsArray: [Comment] = []
    var sectionHeading = ["Previous Results", "Comments"]
    var tagData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        expertPredictUserVM.fetchExpertUserDetailAsyncCall(slug: Slug.predict.rawValue, userId: userId)
        CommentListVM.shared.getCommentsAsyncCall(sectionId: "\(userId)predict-match")
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
        fetchPredictUserDetailViewModelResponse()
        fetchCommentsViewModel()
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.userDetailPredictMatchesTableViewCell)
        tableView.register(CommentTableViewCell.nibName)
        tableView.register(NoDataTableViewCell.nibName)
        collectionView.register(CellIdentifier.userTagsCollectionViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func setUpUIData() {
        userImageView.setImage(imageStr: userData?.profileImg ?? "", placeholder: .placeholderUser)
        nameLabel.text = userData?.appdata?.predict?.name?.capitalized ?? ""
        aboutLabel.text = userData?.about
        winRateLabel.text = "\(userData?.appdata?.predict?.predictStats?.successRate ?? 0)%"
        allCountLabel.text = "Total: \(userData?.appdata?.predict?.predictStats?.allCount ?? 0)"
        successCountLabel.text = "Success: \(userData?.appdata?.predict?.predictStats?.successCount ?? 0)"
        unsuccessCountLabel.text = "Failed: \(userData?.appdata?.predict?.predictStats?.unsuccessCount ?? 0)"
        coinLabel.text = "Coin: \(userData?.appdata?.predict?.predictStats?.coins ?? 0)"
        if userData?.following ?? false {
            followButton.isHidden = true
            followingButton.isHidden = false
        }else {
            followButton.isHidden = false
            followingButton.isHidden = true
        }
        
        matchArray = userData?.appdata?.predict?.prediction ?? []
//        if matchArray.isEmpty {
//            self.customAlertView(title: ErrorMessage.matchEmptyAlert.localized, description: "", image: "empty")
//        }
        tagData = userData?.tags ?? []
        collectionView.reloadData()
        tableView.reloadData()
    }
}

// MARK: - TableView Data source and Delegates
extension ExpertUserDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeading.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeading[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            if let headerView = view as? UITableViewHeaderFooterView {
                headerView.contentView.backgroundColor = .opaqueSeparator
                headerView.textLabel?.textColor = .base
                headerView.textLabel?.font = UIFont.systemFont(ofSize: 16)
                headerView.textLabel?.textAlignment = .left
                headerView.textLabel?.sizeToFit()
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return matchArray.count > 0 ? matchArray.count : 1
        default:
            return commentsArray.count > 0 ? commentsArray.count : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return matchArray.count > 0 ? tableCell(indexPath: indexPath) : noDataTableCell(indexPath: indexPath)
        default:
            return commentsArray.count > 0 ? commentCell(indexPath: indexPath) : noDataTableCell(indexPath: indexPath)
        }
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
    
    func fetchCommentsViewModel() {
        ///fetch comment list
        CommentListVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        
        CommentListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    self?.commentsArray = dataResponse.data ?? []
                } else {
                    if let errorResponse = response?.error {
                        self?.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
                    }
                }
                self?.tableView.reloadData()
            })
            .store(in: &cancellable)
    }
    
    private func tableCell(indexPath:IndexPath) -> UserDetailPredictMatchesTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userDetailPredictMatchesTableViewCell, for: indexPath) as! UserDetailPredictMatchesTableViewCell
        tableView.separatorStyle = .singleLine
        cell.leagueNameLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.leagueName
        cell.homeNameLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.homeTeamName
        cell.awayNameLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.awayTeamName
        cell.homeScoreLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.homeScore
        cell.awayScoreLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.awayScore
        cell.dateLabel.text = userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.matchDatetime
        
        cell.homeImageView.setImage(imageStr: userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.homeTeamImage ?? "", placeholder: UIImage(named: "placeholderLeague"))
        cell.awayImageView.setImage(imageStr: userData?.appdata?.predict?.prediction[indexPath.row].match?.detail?.awayTeamImage ?? "", placeholder: UIImage(named: "placeholderLeague"))
        
        let predStatus = userData?.appdata?.predict?.prediction[indexPath.row].isSuccess
        
        switch predStatus {
        case 0:
            cell.predictionStatusLabel.text = "Prediction Failed"
            cell.predictionStatusLabel.backgroundColor = .gray1
            cell.predictionStatusLabel.textColor = .white
            
        case 1:
            cell.predictionStatusLabel.text = "Correct Prediction"
            cell.predictionStatusLabel.backgroundColor = .green1
            cell.predictionStatusLabel.textColor = .black1
        default:
            cell.predictionStatusLabel.text = "Prediction Pending"
            cell.predictionStatusLabel.backgroundColor = .base
            cell.predictionStatusLabel.textColor = .white
        }
        
//        if userData?.appdata?.predict?.prediction[indexPath.row].isSuccess ?? 0 {
//            cell.predictionStatusLabel.text = "Correct Prediction"
//        }else {
//            cell.predictionStatusLabel.text = "Prediction Failed"
//        }
        return cell
    }
    
    private func commentCell(indexPath:IndexPath) -> CommentTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.commentTableViewCell, for: indexPath) as! CommentTableViewCell
        tableView.separatorStyle = .singleLine
        cell.configureComments(model: commentsArray[indexPath.row], _index: indexPath.row)
        cell.deleteButtonHeightConstaint.constant = 0
        return cell
    }
    
    private func noDataTableCell(indexPath:IndexPath) -> NoDataTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoDataTableViewCell.nibName, for: indexPath) as! NoDataTableViewCell
        tableView.separatorStyle = .none
        cell.configureCell()
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
