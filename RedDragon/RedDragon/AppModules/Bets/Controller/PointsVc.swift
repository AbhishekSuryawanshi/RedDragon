//
//  PointsVc.swift
//  RedDragon
//
//  Created by Qoo on 20/11/2023.
//

import UIKit
import Combine

class PointsVc: UIViewController {
    
    var viewModel = PointsViewModel()
    private var cancellable = Set<AnyCancellable>()
    var walletList : [Transaction]? = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var amountLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        networkCall()
        fetchWalletPoints()
        
        tableView.register(CellIdentifier.pointsItemTableVC)
    }
    
    func networkCall(){
        viewModel.fetchPointsAsyncCall()
    }
    
    
}

// tableview
extension PointsVc : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.pointsItemTableVC) as! PointsItemTableVC
        cell.configureCell(transaction: walletList?[indexPath.row])
        return cell
    }
    
}

// handle network call response
extension PointsVc {
    
    ///fetch view model for points
    func fetchWalletPoints() {
        viewModel.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        viewModel.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        viewModel.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] points in
                self?.execute_onResponseData(points!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ points: WalletBalanceModel) {
        if let list = points.response?.data?.data {
            walletList = list
            amountLable.text = points.response?.data?.wallet
            UserDefaults.standard.points = points.response?.data?.wallet
            tableView.reloadData()
        }else{
            handleError(points.error)
        }
        
    }
    
    func showLoader(_ value: Bool) {
            value ? startLoader() : stopLoader()
        }
    
    func handleError(_ error :  ErrorResponse?){
        if let error = error {
            if error.messages?.first != "Unauthorized user" {
                self.customAlertView(title: ErrorMessage.alert.localized, description: error.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
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
extension PointsVc : LoginVCDelegate {
    func viewControllerDismissed() {
      networkCall()
    }
}
