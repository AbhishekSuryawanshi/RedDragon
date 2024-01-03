//
//  ResetPasswordVC.swift
//  RedDragon
//
//  Created by Qasr01 on 18/11/2023.
//

import UIKit
import Combine

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var confirmPassTitleLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var cancellable = Set<AnyCancellable>()
    var phoneCode = "0"
    var verificationCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshPage()
    }
    
    override func viewDidLayoutSubviews() {
        ///Add top corner for background view
        bgView.roundCornersWithBorderLayer(cornerRadii: 30, corners: [.topLeft, .topRight], bound: bgView.bounds)
        bgView.applyShadow(radius: 10, opacity: 1)
    }
    
    func initialSettings() {
        fetchLoginViewModel()
        
        ///set deafult value for country code
        phoneCode = "+971"
        countryCodeButton.setTitle(phoneCode, for: .normal)
        countryCodeButton.setImage(UIImage(named: "AE") ?? .placeholder1, for: .normal)
    }
    
    func refreshPage() {
        headerLabel.text = "Reset Password".localized
        topLabel.text = "Enter the details below to reset Password".localized
        phoneTitleLabel.text = "Phone Number".localized
        passwordTitleLabel.text = "Password".localized
        confirmPassTitleLabel.text = "Confirm Password".localized
        phoneTextField.placeholder = "Phone Number".localized
        passwordTextField.placeholder = "Password".localized
        confirmPasswordTextfield.placeholder = "Confirm Password".localized
        continueButton.setTitle("Continue".localized, for: .normal)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func validate() -> Bool {
        if phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.phoneEmptyAlert.localized)
            return false
        } else if !isValidPhone(validate: phoneCode + phoneTextField.text!) {
            self.view.makeToast(ErrorMessage.invalidPhone.localized)
            return false
        } else if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.passwordEmptyAlert.localized)
            return false
        } else if !isValidPassword(validate: passwordTextField.text!) {
            self.view.makeToast(ErrorMessage.passwordCondition.localized, duration: 5)
            return false
        } else if confirmPasswordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.confirmPasswordEmptyAlert.localized)
            return false
        } else if passwordTextField.text! != confirmPasswordTextfield.text! {
            self.view.makeToast(ErrorMessage.passwordNotmatchedAlert.localized)
            return false
        }
        return true
    }
    
    // MARK: - Button Actions
    
    @IBAction func countryCodeButtonTapped(_ sender: UIButton) {
        let countryVC = CountryCodeListVC()
        countryVC.delegate = self
        self.present(countryVC, animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if validate() {
            let param: [String: Any] = [
                "code": verificationCode,
                "phone": phoneCode + phoneTextField.text!,
                "password": passwordTextField.text!
            ]
            ResetPasswordVM.shared.resetPasswordAsyncCall(parameters: param)
        }
    }
}

// MARK: - API Services
extension ResetPasswordVC {
    
    func fetchLoginViewModel() {
        
        ResetPasswordVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        ResetPasswordVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        ResetPasswordVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ response: LoginResponse?) {
        
        if let dataResponse = response?.response {
            self.view.makeToast(dataResponse.messages?.first)
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                NotificationCenter.default.post(name: .dismissLoginVC, object: nil)
            }
        } else {
            if let errorResponse = response?.error {
                let okAction = PMAlertAction(title: "OK", style: .default) {
                    /// Wrong otp, go back to verification vc
                    if (errorResponse.messages?.first ?? "").lowercased().contains("verification code") {
                        self.dismiss(animated: true)
                    }
                }
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
    }
}

// MARK: - TextField Delegate
extension ResetPasswordVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let maxLength = 11
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            let lengthStatus = newString.length <= maxLength
            
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            let numberStatus =  allowedCharacters.isSuperset(of: characterSet)
            
            if lengthStatus && numberStatus {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
}

// MARK: - Custom Delegate
extension ResetPasswordVC: CountryDelegate {
    func countrySelected(country: CountryModel) {
        phoneCode = country.phoneCode
        countryCodeButton.setTitle("\(country.phoneCode)", for: .normal)
        countryCodeButton.setImage(UIImage(named: country.code) ?? .placeholder1, for: .normal)
    }
}
