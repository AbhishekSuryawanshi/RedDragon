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
    
    private var expertUserVM = ExpertPredictUserViewModel()
    var cancellable = Set<AnyCancellable>()
    var userArray = [ExpertUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
        makeNetworkCall()
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.predictUserListTableViewCell)
    }

    func makeNetworkCall() {
        expertUserVM.fetchExpertUserListAsyncCall(page: 1, slug: Slug.predict.rawValue)
        fetchUserListViewModelResponse()
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
        cell.winRateLabel.text = "\(userArray[indexPath.row].appdata?.predict?.predictStats?.successRate ?? 0.0)%"
        cell.allCountLabel.text = "\(userArray[indexPath.row].appdata?.predict?.predictStats?.allCount ?? 0)"
        cell.successCountLabel.text = "\(userArray[indexPath.row].appdata?.predict?.predictStats?.successCount ?? 0)"
        cell.unsuccessCountLabel.text = "\(userArray[indexPath.row].appdata?.predict?.predictStats?.unsuccessCount ?? 0)"
        cell.coinLabel.text = "\(userArray[indexPath.row].appdata?.predict?.predictStats?.coins ?? 0)"
        cell.userImageView.setImage(imageStr: userArray[indexPath.row].profileImg ?? "", placeholder: .placeholderUser)
        cell.dateLabel.text = userArray[indexPath.row].appdata?.predict?.date.formatDate(inputFormat: dateFormat.ddMMyyyyWithTimeZone, outputFormat: dateFormat.ddMMMyyyyhmma) ?? ""
       
        if userArray[indexPath.row].following ?? true {
            cell.followButton.isHidden = true
        }else {
            cell.followingButton.isHidden = true
        }
        
        return cell
    }
    
    func fetchUserListViewModelResponse() {
        expertUserVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        expertUserVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        expertUserVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onUserListResponse(response!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onUserListResponse(_ list: ExpertUserListModel) {
        userArray = list.response?.data ?? []
        tableView.reloadData()
    }
}
