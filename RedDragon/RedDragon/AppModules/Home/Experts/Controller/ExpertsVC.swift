//
//  ExpertsVC.swift
//  RedDragon
//
//  Created by iOS Dev on 13/12/2023.
//

import UIKit
import Combine

enum Slug: String {
    case predict = "predict-match"
    case bet = "bet"
}

class ExpertsVC: UIViewController {
    @IBOutlet weak var predictDropDown : DropDown!
    @IBOutlet weak var tagsDropDown : DropDown!
    @IBOutlet weak var tableView: UITableView!
    
    private var expertPredictUserVM = ExpertPredictUserViewModel()
    private var expertBetUserVM = ExpertBetUserViewModel()
    private var tagsVM: TagsViewModel?
    var cancellable = Set<AnyCancellable>()
    var userArray = [ExpertUser]()
    var predictUserArray = [ExpertUser]()
    var betUserArray = [ExpertUser]()
    var tagsArray = [TagsData]()
    var tagSlug = String()
    var isTagSelected: Bool = false
    var isPageRefreshing:Bool = false
    var predictScrollPage: Int = 1
    var betScrollPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        fetchTagsViewModel()
        predictDropDown.optionArray = ["Prediction", "Bet"]
        predictDropDown.selectedIndex = 0
        expertPredictUserVM.fetchExpertUserListAsyncCall(page: predictScrollPage, slug: Slug.predict.rawValue)
        fetchPredictUserListViewModelResponse()
        
        predictDropDown.didSelect { [self] selectedText, index, id in
            self.isPageRefreshing = false
            isTagSelected = false
            userArray.removeAll()
            predictUserArray.removeAll()
            betUserArray.removeAll()
            tableView.reloadData()
            
            if index == 0 {
                expertPredictUserVM.fetchExpertUserListAsyncCall(page: predictScrollPage, slug: Slug.predict.rawValue)
                fetchPredictUserListViewModelResponse()
            }else {
                expertBetUserVM.fetchExpertUserListAsyncCall(page: betScrollPage, slug: Slug.bet.rawValue)
                fetchBetUserListViewModelResponse()
            }
        }
        
        tagsDropDown.didSelect { [self] selectedText, index, id in
            predictScrollPage = 1
            isTagSelected = true
            tagSlug = tagsArray[index].slug
            expertPredictUserVM.fetchExpertUserListAsyncCall(page: predictScrollPage, slug: Slug.predict.rawValue, tag: tagSlug)
            fetchPredictUserListViewModelResponse()
        }
        nibInitialization()
     //   makeNetworkCall()
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.predictUserListTableViewCell)
    }
    
    func makeNetworkCall() {
        fetchTagsViewModel()
        expertPredictUserVM.fetchExpertUserListAsyncCall(page: predictScrollPage, slug: Slug.predict.rawValue)
        expertBetUserVM.fetchExpertUserListAsyncCall(page: betScrollPage, slug: Slug.bet.rawValue)
        fetchPredictUserListViewModelResponse()
        fetchBetUserListViewModelResponse()
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
}

// MARK: - TableView Data source and Delegates
extension ExpertsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("User array count,,,,,\(userArray.count)")
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.size.height) {
            if !isPageRefreshing {
                isPageRefreshing = true
             
                if !isTagSelected {
                    if predictDropDown.selectedIndex == 0 { // Predict
                        predictScrollPage = predictScrollPage + 1
                        expertPredictUserVM.fetchExpertUserListAsyncCall(page: predictScrollPage, slug: Slug.predict.rawValue)
                        fetchPredictUserListViewModelResponse()
                    }else {
                        betScrollPage = betScrollPage + 1
                        expertBetUserVM.fetchExpertUserListAsyncCall(page: betScrollPage, slug: Slug.bet.rawValue)
                        fetchBetUserListViewModelResponse()
                    }
                    tableView.reloadData()
                }
                
            }
        }
    }
}

extension ExpertsVC {
    private func tableCell(indexPath:IndexPath) -> PredictUserListTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictUserListTableViewCell, for: indexPath) as! PredictUserListTableViewCell
        
        cell.aboutLabel.text = userArray[indexPath.row].about
        cell.userImageView.setImage(imageStr: userArray[indexPath.row].profileImg ?? "", placeholder: .placeholderUser)
        cell.walletButton.setTitle("\(userArray[indexPath.row].wallet ?? 0)", for: .normal)
        if ((userArray[indexPath.row].tags?.isEmpty) != true) {
            cell.tagCollectionView.isHidden = false
            cell.configureTagCollectionData(data: userArray[indexPath.row].tags ?? [])
        }else {
            cell.tagCollectionView.isHidden = true
        }
        
        if predictDropDown.selectedIndex == 0 { // Predict
            cell.betPointsStackView.isHidden = true
            cell.dateLabel.isHidden = false
            cell.followStackView.isHidden = false
            cell.heightConstraint.constant = 23.67
            cell.nameLabel.text = userArray[indexPath.row].appdata?.predict?.name?.capitalized
            //    let roundedValue = (userArray[indexPath.row].appdata?.predict?.predictStats?.successRate ?? 0.0).rounded(toPlaces: 2)
            cell.winRateLabel.text = "\(userArray[indexPath.row].appdata?.predict?.predictStats?.successRate ?? 0)%"
            cell.allCountLabel.text = "Total: \(userArray[indexPath.row].appdata?.predict?.predictStats?.allCount ?? 0)"
            cell.successCountLabel.text = "Success: \(userArray[indexPath.row].appdata?.predict?.predictStats?.successCount ?? 0)"
            cell.unsuccessCountLabel.text = "Failed: \(userArray[indexPath.row].appdata?.predict?.predictStats?.unsuccessCount ?? 0)"
            cell.coinLabel.text = "Coin: \(userArray[indexPath.row].appdata?.predict?.predictStats?.coins ?? 0)"
            cell.dateLabel.text = "  \(userArray[indexPath.row].appdata?.predict?.date.formatDate(inputFormat: dateFormat.ddMMyyyyWithTimeZone, outputFormat: dateFormat.ddMMMyyyyhmma) ?? "")"
            
            if userArray[indexPath.row].following ?? true {
                cell.followButton.isHidden = true
            }else {
                cell.followingButton.isHidden = true
            }
        }else { // Bet
            cell.betPointsStackView.isHidden = false
            cell.dateLabel.isHidden = true
            cell.followStackView.isHidden = true
            cell.heightConstraint.constant = 14
            cell.nameLabel.text = userArray[indexPath.row].appdata?.bet?.name?.capitalized
            cell.winRateLabel.text = "\(userArray[indexPath.row].appdata?.bet?.betDetail?.winRate ?? "")%"
            cell.allCountLabel.text = "\(userArray[indexPath.row].appdata?.bet?.betDetail?.totalBetAll ?? "") Total bets"
            cell.successCountLabel.text = "\(userArray[indexPath.row].appdata?.bet?.betDetail?.totalBetWin ?? "") Won bets"
            cell.unsuccessCountLabel.text = "\(userArray[indexPath.row].appdata?.bet?.betDetail?.totalBetLose ?? "") Lost bets"
            cell.coinLabel.text = "\(userArray[indexPath.row].appdata?.bet?.betDetail?.totalBetPending ?? "") Pending bets"
            cell.totalPointsLabel.text = "\(userArray[indexPath.row].appdata?.bet?.betDetail?.totalBetAll ?? "") Total pts"
            cell.wonPointsLabel.text = "\(userArray[indexPath.row].appdata?.bet?.betDetail?.amountBetWin ?? "") Won pts"
            cell.lostPointsLabel.text = "\(userArray[indexPath.row].appdata?.bet?.betDetail?.amountBetLose ?? "") Lost pts"
            cell.pendingPointsLabel.text = "\(userArray[indexPath.row].appdata?.bet?.betDetail?.amountBetPending ?? "") Pending pts"
        }
        return cell
    }
    
    func fetchPredictUserListViewModelResponse() {
        expertPredictUserVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        expertPredictUserVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        expertPredictUserVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onPredictUserListResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onPredictUserListResponse(_ list: ExpertUserListModel) {
        userArray.removeAll()
        if isTagSelected {
            userArray = list.response?.data ?? []
        }else {
            if list.response?.data?.count ?? 0 > 0 {
                self.isPageRefreshing = false
                predictUserArray.append(contentsOf: list.response?.data ?? [])
            }
         //   predictUserArray = list.response?.data ?? []
            userArray = predictUserArray
        }
        
        if userArray.isEmpty {
            self.customAlertView(title: ErrorMessage.matchEmptyAlert.localized, description: "", image: "empty")
        }
        tableView.reloadData()
    }
    
    func fetchBetUserListViewModelResponse() {
        expertBetUserVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        expertBetUserVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        expertBetUserVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onBetUserListResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onBetUserListResponse(_ list: ExpertUserListModel) {
        userArray.removeAll()
        if list.response?.data?.count ?? 0 > 0 {
            self.isPageRefreshing = false
            betUserArray.append(contentsOf: list.response?.data ?? [])
        }
        userArray = betUserArray
        tableView.reloadData()
    }
    
    private func fetchTagsViewModel() {
        tagsVM = TagsViewModel()
        tagsVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.tagsArray = data?.response.data ?? []
                for i in data?.response.data ?? [] {
                    self?.tagsDropDown.optionArray.append(i.tag)
                }
            })
            .store(in: &cancellable)
        /// API call to fetch all tags
        tagsVM?.fetchTagsAsyncCall()
    }
}
