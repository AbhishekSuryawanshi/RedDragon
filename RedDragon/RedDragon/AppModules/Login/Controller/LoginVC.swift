//
//  LoginVC.swift
//  RedDragon
//
//  Created by Qasr01 on 14/11/2023.
//

import UIKit
import Combine

protocol LoginVCDelegate:AnyObject {
    func viewControllerDismissed()
}

class LoginVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    weak var delegate:LoginVCDelegate?
    var cancellable = Set<AnyCancellable>()
    var phoneCode = "+971"
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.viewControllerDismissed()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initialSettings() {
        fetchLoginViewModel()
        flagImageView.setImage(imageStr: "http://157.245.159.136:5072/flags/flagspng/ae.png", placeholder: .placeholderFlag)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissLoginVC), name: .dismissLoginVC, object: nil)
    }
    
    func refreshPage() {
        headerLabel.text = "Welcome to Rampage Sports App".localized
        let topFormatedText = NSMutableAttributedString()
        topTextLabel.attributedText = topFormatedText.regular("Please ", size: 15).semiBold("Login", size: 15).regular(" to continue", size: 15)
        phoneTitleLabel.text = "Phone Number".localized
        passwordTitleLabel.text = "Password".localized
        phoneTextField.placeholder = "Phone Number".localized
        passwordTextField.placeholder = "Password".localized
        let bottomFormatedText = NSMutableAttributedString()
        bottomFormatedText.regular("Don't Have an Account? Tap here to", size: 15).semiBold(" Register", size: 15)
        bottomFormatedText.addUnderLine(textToFind: "Register")
        bottomFormatedText.addLink(textToFind: " Register", linkURL: "register")
        bottomTextView.attributedText = bottomFormatedText
        forgotPassButton.setTitle("Forgot Password".localized, for: .normal)
        loginButton.setTitle("Login".localized, for: .normal)
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
        }
        return true
    }
    
    @objc func dismissLoginVC() {
        self.dismiss(animated: true)
        self.dismiss(animated: true)
    }
    
    // MARK: - Button Actions
    @IBAction func countryCodeButtonTapped(_ sender: UIButton) {
        let countryVC = CountryListVC()
        countryVC.delegate = self
        self.present(countryVC, animated: true)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        if validate() {
            let param: [String: Any] = [
                "phone_number": phoneCode + phoneTextField.text!,
                "password": passwordTextField.text!
            ]
            LoginVM.shared.loginAsyncCall(parameters: param)
        }
    }
    
    @IBAction func forgotButtonTapped(_ sender: UIButton) {
        self.presentOverViewController(ForgotPasswordVC.self, storyboardName: StoryboardName.login)
    }
}

// MARK: - API Services
extension LoginVC {
    
    func fetchLoginViewModel() {
        
        LoginVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        LoginVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        LoginVM.shared.$responseData
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
                
                if user.otpVerified == 0 {
                    UserDefaults.standard.token = user.token //required for resend api
                    UserDefaults.standard.budget = Int(user.affAppData?.sportCard?.budget ?? "200000000")
                    UserDefaults.standard.score = Int(user.affAppData?.sportCard?.score ?? "0")
                    self.presentOverViewController(VerificationVC.self, storyboardName: StoryboardName.login) { vc in
                        vc.email = user.email
                        vc.phoneNumber = user.phoneNumber
                        vc.password = self.passwordTextField.text ?? ""
                        vc.pushFrom = .login
                    }
                } else {
                    UserDefaults.standard.user = user
                    UserDefaults.standard.token = user.token
                    UserDefaults.standard.budget = Int(user.affAppData?.sportCard?.budget ?? "200000000")
                    UserDefaults.standard.score = Int(user.affAppData?.sportCard?.score ?? "0")
                    self.dismiss(animated: true)
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
extension LoginVC: UITextFieldDelegate {
    
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
extension LoginVC: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "register":
            presentOverViewController(RegisterVC.self, storyboardName: StoryboardName.login)
        default:
            print("")
        }
        return false
    }
}

// MARK: - Custom Delegate
extension LoginVC: CountryDelegate {
    func countrySelected(country: Country) {
        phoneCode = country.phoneCode
        countryCodeButton.setTitle("\(country.phoneCode)", for: .normal)
        flagImageView.setImage(imageStr: country.flag, placeholder: .placeholderFlag)
    }
}
