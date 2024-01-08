//
//  ForgotPasswordVC.swift
//  RedDragon
//
//  Created by Qasr01 on 18/11/2023.
//

import UIKit
import Combine

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLoginViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshPage()
    }
    
    override func viewDidLayoutSubviews() {
        ///Add top corner for background view
        bgView.roundCornersWithBorderLayer(cornerRadii: 30, corners: [.topLeft, .topRight], bound: bgView.bounds)
        bgView.applyShadow(radius: 10, opacity: 1)
    }
    
    func refreshPage() {
        headerLabel.text = "Forgot Password".localized
        topLabel.text = "Enter the email address associated with your account.".localized
        emailTextfield.placeholder = "Email".localized
        emailTitleLabel.text = "Email".localized
        continueButton.setTitle("Continue".localized, for: .normal)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func validate() -> Bool {
        if emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.emailEmptyAlert.localized)
            return false
        } else if !isValidEmail(validate: emailTextfield.text!) {
            self.view.makeToast(ErrorMessage.invalidEmail.localized)
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
            self?.view.makeToast(error, duration: 2.0, position: .center)
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
                self.presentViewController(VerificationVC.self, storyboardName: StoryboardName.login) { vc in
                    vc.pushFrom = .forgotPass
                }
            }
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
    }
}
