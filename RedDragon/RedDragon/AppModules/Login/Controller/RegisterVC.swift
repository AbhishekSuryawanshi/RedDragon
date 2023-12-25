//
//  RegisterVC.swift
//  RedDragon
//
//  Created by Qasr01 on 14/11/2023.
//

import UIKit
import Combine

class RegisterVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var nameTiltleLabel: UILabel!
    @IBOutlet weak var emailTiltleLabel: UILabel!
    @IBOutlet weak var phoneTiltleLabel: UILabel!
    @IBOutlet weak var userNameTiltleLabel: UILabel!
    @IBOutlet weak var passwordTiltleLabel: UILabel!
    @IBOutlet weak var confirmPassTiltleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    var cancellable = Set<AnyCancellable>()
    var countryCode = "0"
    
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
        countryCode = "+971"
        countryCodeButton.setTitle(countryCode, for: .normal)
        countryCodeButton.setImage(UIImage(named: "AE") ?? .placeholder1, for: .normal)
    }
    
    func refreshPage() {
        headerLabel.text = "Welcome to Rampage Sports App".localized
        let formatedText = NSMutableAttributedString()
        topTextLabel.attributedText = formatedText.regular("Please ", size: 15).semiBold("Create an account", size: 15).regular(" to continue", size: 15)
        nameTiltleLabel.text = "Full Name".localized
        emailTiltleLabel.text = "Email".localized
        phoneTiltleLabel.text = "Phone Number".localized
        userNameTiltleLabel.text = "User Name".localized
        passwordTiltleLabel.text = "Password".localized
        confirmPassTiltleLabel.text = "Confirm Password".localized
        nameTextField.placeholder = "Full Name".localized
        emailTextfield.placeholder = "Email".localized
        phoneTextField.placeholder = "Phone Number".localized
        userNameTextfield.placeholder = "User Name".localized
        passwordTextField.placeholder = "Password".localized
        confirmPasswordTextfield.placeholder = "Confirm Password".localized
        let bottomFormatedText = NSMutableAttributedString()
        bottomFormatedText.regular("Already Have an Account? Tap here to".localized, size: 15).semiBold(" Sign In".localized, size: 15)
        bottomFormatedText.addUnderLine(textToFind: "Sign In")
        bottomFormatedText.addLink(textToFind: " Sign In", linkURL: "signIn")
        bottomTextView.attributedText = bottomFormatedText
        let termsFormatedText = NSMutableAttributedString()
        termsFormatedText.regular("Confirm your acceptance of the".localized, size: 14).semiBold(" Terms and Conditions".localized, size: 15)
        bottomFormatedText.addLink(textToFind: "Confirm your acceptance of the Terms and Conditions".localized, linkURL: URLConstants.terms)
        termsTextView.attributedText = termsFormatedText
        createAccountButton.setTitle("Create an Account".localized, for: .normal)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func validate() -> Bool {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.nameEmptyAlert)
            return false
        } else if emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.emailEmptyAlert)
            return false
        } else if !isValidEmail(validate: emailTextfield.text!) {
            self.view.makeToast(ErrorMessage.invalidEmail)
            return false
        } else if phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.phoneEmptyAlert)
            return false
        } else if !isValidPhone(validate: countryCode + phoneTextField.text!) {
            self.view.makeToast(ErrorMessage.invalidPhone)
            return false
        } else if userNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.userNameEmptyAlert)
            return false
        } else if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.passwordEmptyAlert)
            return false
        } else if !isValidPassword(validate: passwordTextField.text!) {
            self.view.makeToast(ErrorMessage.passwordCondition, duration: 5)
            return false
        } else if confirmPasswordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.confirmPasswordEmptyAlert)
            return false
        } else if passwordTextField.text! != confirmPasswordTextfield.text! {
            self.view.makeToast(ErrorMessage.passwordNotmatchedAlert)
            return false
        } else if !checkButton.isSelected {
            self.view.makeToast(ErrorMessage.termsAlert)
            return false
        }
        return true
    }
    
    // MARK: - Button Actions
    
    @IBAction func termsButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func termsTextButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: URLConstants.terms) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func countryCodeButtonTapped(_ sender: UIButton) {
        let countryVC = CountryCodeListVC()
        countryVC.delegate = self
        self.present(countryVC, animated: true)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        if validate() {
            let param: [String: Any] = [
                "full_name": nameTextField.text!,
                "email": emailTextfield.text!,
                "phone_number": countryCode + phoneTextField.text!,
                "username": userNameTextfield.text!,
                "password": passwordTextField.text!
            ]
            RegisterVM.shared.registerAsyncCall(parameters: param)
        }
    }
}

// MARK: - API Services
extension RegisterVC {
    
    func fetchLoginViewModel() {
        
        RegisterVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        RegisterVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        RegisterVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ response: LoginResponse?) {
        
        if let dataResponse = response?.response {
            if let user = dataResponse.data {
                ///User registered, now verify OTP
                UserDefaults.standard.token = user.token //required for resend api
                UserDefaults.standard.budget = Int(user.affAppData?.sportCard?.budget ?? "200000000")
                UserDefaults.standard.score = Int(user.affAppData?.sportCard?.score ?? "0")
                self.presentOverViewController(VerificationVC.self, storyboardName: StoryboardName.login) { vc in
                    vc.email = user.email
                    vc.phoneNumber = user.phoneNumber
                    vc.password = self.passwordTextField.text ?? ""
                    vc.pushFrom = .register
                }
            }
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
    }
}

// MARK: - TextField Delegate
extension RegisterVC: UITextFieldDelegate {
    
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

//MARK: UITextView Delegates
extension RegisterVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "signIn":
            self.dismiss(animated: true)
        default:
            //ToDo
            ///check terms url
            //guard let url = URL(string: URL.absoluteString) else { return }
            UIApplication.shared.open(URL)
        }
        return false
    }
}

// MARK: - Custom Delegate
extension RegisterVC: CountryDelegate {
    func countrySelected(country: CountryModel) {
        countryCode = country.phoneCode
        countryCodeButton.setTitle("\(country.phoneCode)", for: .normal)
        countryCodeButton.setImage(UIImage(named: country.code) ?? .placeholder1, for: .normal)
    }
}
