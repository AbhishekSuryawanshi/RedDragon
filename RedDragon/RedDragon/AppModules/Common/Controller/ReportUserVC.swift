//
//  ReportUserVC.swift
//  RedDragon
//
//  Created by iOS Dev on 03/01/2024.
//

import UIKit
import Combine

enum ReportType {
    case blockUser
    case reportUser
    case reportPost
    case reportPoll
}

class ReportUserVC: UIViewController {
    
    @IBOutlet weak var controllerTitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var textView: GrowingTextView!
    
    var cancellable = Set<AnyCancellable>()
    var reportType: ReportType = .blockUser
    var blockUserVM = BlockUserViewModel()
    var reportUserVM = ReportUserViewModel()
    var userId = Int()
    var postOrPollId = 0 // post id or poll id of social module
    var pushFromSocialModule = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // Methods
    func performInitialSetup() {
        self.tabBarController?.tabBar.isHidden = true
        textView.placeholder = ErrorMessage.reasonEmptyAlert.localized
        switch reportType {
        case .blockUser:
            controllerTitleLabel.text = "Block User".localized
            doneButton.setTitle("Block".localized, for: .normal)
        case .reportUser:
            controllerTitleLabel.text = "Report User".localized
            doneButton.setTitle("Report".localized, for: .normal)
        case .reportPost, .reportPoll:
            controllerTitleLabel.text = "Report Post".localized
            doneButton.setTitle("Report".localized, for: .normal)
        }
        
        reportPostOrPollViewModelResponse()
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    // Button Action
    @IBAction func doneButtonAction(_ sender: Any) {
        textView.endEditing(true)
        guard !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.view.makeToast(ErrorMessage.reasonEmptyAlert.localized)
            return
        }
        let reason = textView.text!
        
        switch reportType {
        case .blockUser:
            // Block user API call
            let parameters = ["blocked_user_id": userId, "reason": reason, "flag": true] as [String : Any] // "flag" = true for blocking user, false for unblocking
            blockUserVM.postBlockUserAsyncCall(parameters: parameters)
            postBlockUserViewModelResponse()
        case .reportUser:
            // Report user API call
            let parameters = ["user_id": userId, "reason": reason] as [String : Any]
            reportUserVM.postReportUserAsyncCall(parameters: parameters)
            postReportUserViewModelResponse()
        case .reportPost:
            let parameters = ["post_id": postOrPollId, "reason": reason, "flag": true] as [String : Any]
            SocialPostReportVM.shared.reportPostOrPollAsyncCall(reportType: reportType, parameters: parameters)
        case .reportPoll:
            let parameters = ["poll_id": postOrPollId, "reason": reason, "flag": true] as [String : Any]
            SocialPostReportVM.shared.reportPostOrPollAsyncCall(reportType: reportType, parameters: parameters)
        }
    }
}

extension ReportUserVC {
    private func postBlockUserViewModelResponse() {
        blockUserVM.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        blockUserVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        blockUserVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                 if data?.response?.code == 200 {
                    if (self?.pushFromSocialModule ?? false) {
                        ///Push from post list of social module
                        self?.view.makeToast(SuccessMessage.successfullyBlockedUser.localized)
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                            self?.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        
                        NotificationCenter.default.post(name: Notification.Name("UserBlocked"), object: nil)
                        let viewControllers: [UIViewController] = (self?.navigationController?.viewControllers as? [UIViewController])!
                        self?.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                        self?.view.makeToast(SuccessMessage.successfullyBlockedUser.localized)
                    }
                }
            })
            .store(in: &cancellable)
    }
    
    private func postReportUserViewModelResponse() {
        reportUserVM.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
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
    
    // Report post or poll for social module
    private func reportPostOrPollViewModelResponse() {
        SocialPostReportVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        SocialPostReportVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialPostReportVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                if let dataResponse = data?.response {
                    self?.view.makeToast(SuccessMessage.successfullyReportedPost.localized)
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    if let errorResponse = data?.error {
                        self?.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
                    }
                }
            })
            .store(in: &cancellable)
    }
}
