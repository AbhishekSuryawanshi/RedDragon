//
//  ReportUserVC.swift
//  RedDragon
//
//  Created by iOS Dev on 03/01/2024.
//

import UIKit
import Combine

class ReportUserVC: UIViewController {
    @IBOutlet weak var controllerTitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var cancellable = Set<AnyCancellable>()
    var isFromBlockUser = false
    var blockUserVM = BlockUserViewModel()
    var reportUserVM = ReportUserViewModel()
    var userId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // Methods
    func performInitialSetup() {
        self.tabBarController?.tabBar.isHidden = true
        if isFromBlockUser {
            controllerTitleLabel.text = "Block User".localized
            doneButton.setTitle("Block".localized, for: .normal)
        }else {
            controllerTitleLabel.text = "Report User".localized
            doneButton.setTitle("Report".localized, for: .normal)
        }
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    // Button Action
    @IBAction func doneButtonAction(_ sender: Any) {
        let reason = textView.text ?? ""
        if isFromBlockUser { // Block user API call
            let parameters = ["blocked_user_id": userId, "reason": reason, "flag": true] as [String : Any] // "flag" = true for blocking user, false for unblocking
            blockUserVM.postBlockUserAsyncCall(parameters: parameters)
            postBlockUserViewModelResponse()
        }else { // Report user API call
            let parameters = ["user_id": userId, "reason": reason] as [String : Any]
            reportUserVM.postReportUserAsyncCall(parameters: parameters)
            postReportUserViewModelResponse()
        }
    }
}

extension ReportUserVC {
    private func postBlockUserViewModelResponse() {
        blockUserVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        blockUserVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        blockUserVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                if data?.response?.code == 200 {
                    NotificationCenter.default.post(name: Notification.Name("UserBlocked"), object: nil)
                    let viewControllers: [UIViewController] = (self?.navigationController?.viewControllers as? [UIViewController])!
                    self?.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    self?.view.makeToast(SuccessMessage.successfullyBlockedUser.localized)
                }
            })
            .store(in: &cancellable)
    }
    
    private func postReportUserViewModelResponse() {
        reportUserVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        reportUserVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        reportUserVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                if data?.response?.code == 200 {
                    let viewControllers: [UIViewController] = (self?.navigationController?.viewControllers as? [UIViewController])!
                    self?.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    self?.view.makeToast(SuccessMessage.successfullyBlockedUser.localized)
                }
            })
            .store(in: &cancellable)
    }
}
