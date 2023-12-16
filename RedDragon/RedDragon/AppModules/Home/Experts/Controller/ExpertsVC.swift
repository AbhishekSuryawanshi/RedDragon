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
    @IBOutlet weak var dropDown : DropDown!
    @IBOutlet weak var tableView: UITableView!
    
    private var expertPredictUserVM = ExpertPredictUserViewModel()
    private var expertBetUserVM = ExpertBetUserViewModel()
    var cancellable = Set<AnyCancellable>()
    var userArray = [ExpertUser]()
    var predictUserArray = [ExpertUser]()
    var betUserArray = [ExpertUser]()
    var selectedDropDownIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        dropDown.optionArray = ["Prediction", "Bet"]

        dropDown.didSelect { [self] selectedText, index, id in
            self.selectedDropDownIndex = index
            
            if selectedDropDownIndex == 0 {
                userArray = predictUserArray
                tableView.reloadData()
            }else {
                userArray = betUserArray
                tableView.reloadData()
            }
        }
        nibInitialization()
        makeNetworkCall()
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.predictUserListTableViewCell)
    }

    func makeNetworkCall() {
        expertPredictUserVM.fetchExpertUserListAsyncCall(page: 1, slug: Slug.predict.rawValue)
        expertBetUserVM.fetchExpertUserListAsyncCall(page: 1, slug: Slug.bet.rawValue)
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
        userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148.0
    }
}

extension ExpertsVC {
    private func tableCell(indexPath:IndexPath) -> PredictUserListTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictUserListTableViewCell, for: indexPath) as! PredictUserListTableViewCell
        cell.nameLabel.text = userArray[indexPath.row].appdata?.predict?.name?.capitalized
        cell.aboutLabel.text = userArray[indexPath.row].about
        let roundedValue = (userArray[indexPath.row].appdata?.predict?.predictStats?.successRate ?? 0.0).rounded(toPlaces: 2)
        cell.winRateLabel.text = "\(roundedValue)%"
        cell.allCountLabel.text = "All count: \(userArray[indexPath.row].appdata?.predict?.predictStats?.allCount ?? 0)"
        cell.successCountLabel.text = "Success count: \(userArray[indexPath.row].appdata?.predict?.predictStats?.successCount ?? 0)"
        cell.unsuccessCountLabel.text = "Unsuccess count: \(userArray[indexPath.row].appdata?.predict?.predictStats?.unsuccessCount ?? 0)"
        cell.coinLabel.text = "Coin: \(userArray[indexPath.row].appdata?.predict?.predictStats?.coins ?? 0)"
        cell.userImageView.setImage(imageStr: userArray[indexPath.row].profileImg ?? "", placeholder: .placeholderUser)
        cell.dateLabel.text = "  \(userArray[indexPath.row].appdata?.predict?.date.formatDate(inputFormat: dateFormat.ddMMyyyyWithTimeZone, outputFormat: dateFormat.ddMMMyyyyhmma) ?? "")"
       
        if userArray[indexPath.row].following ?? true {
            cell.followButton.isHidden = true
        }else {
            cell.followingButton.isHidden = true
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
        predictUserArray = list.response?.data ?? []
        userArray = predictUserArray
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
        betUserArray = list.response?.data ?? []
    //    userArray = betUserArray
    //    tableView.reloadData()
    }
}
