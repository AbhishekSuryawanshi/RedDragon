//
//  ForgotPasswordVC.swift
//  RedDragon
//
//  Created by Qasr01 on 18/11/2023.
//

import UIKit
import Combine

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewDidLayoutSubviews() {
        ///Add top corner for background view
        bgView.roundCornersWithBorderLayer(cornerRadii: 30, corners: [.topLeft, .topRight], bound: bgView.bounds)
        bgView.applyShadow(radius: 10, opacity: 1)
    }
    
    func initialSettings() {
        self.view.addSubview(Loader.activityIndicator)
        emailTextfield.placeholder = "Email".localized
        fetchLoginViewModel()
    }

    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func validate() -> Bool {
        if emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.emailEmptyAlert)
            return false
        } else if !isValidEmail(validate: emailTextfield.text!) {
            self.view.makeToast(ErrorMessage.invalidEmail)
            return false
        }
        return true
    }
    
    // MARK: - Button Actions
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if validate() {
            let param: [String: Any] = [
                "email": emailTextfield.text!
            ]
            ForgotPasswordVM.shared.forgotPasswordAsyncCall(parameters: param)
        }
    }
}

// MARK: - API Services
extension ForgotPasswordVC {
    
    func fetchLoginViewModel() {
        
        ForgotPasswordVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        ForgotPasswordVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        ForgotPasswordVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ response: LoginResponse?) {
        
        if let dataResponse = response?.response {
            ///Show "otp sent" message from server and collect otp from VerificationVC
            self.view.makeToast(dataResponse.messages?.first)
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
                self.presentOverViewController(VerificationVC.self, storyboardName: StoryboardName.login) { vc in
                    vc.pushFrom = .forgotPass
                }
            }
        } else {
            if let errorResponse = response?.error {
                self.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
            }
        }
    }
}
