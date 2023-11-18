//
//  LoginVC.swift
//  RedDragon
//
//  Created by Qasr01 on 14/11/2023.
//

import UIKit
import Combine

class LoginVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomTextView: UITextView!
    
    var cancellable = Set<AnyCancellable>()
    var countryCode = "0"
    
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
        fetchLoginViewModel()
        
        ///set deafult value for country code
        countryCode = "+971"
        countryCodeButton.setTitle(countryCode, for: .normal)
        countryCodeButton.setImage(UIImage(named: "AE") ?? .placeholder1, for: .normal)
        
        let topFormatedText = NSMutableAttributedString()
        topTextLabel.attributedText = topFormatedText.regular("Please ", size: 15).medium("Login", size: 15).regular(" to continue", size: 15)
        phoneTextField.placeholder = "Phone Number".localized
        passwordTextField.placeholder = "Password".localized
        let bottomFormatedText = NSMutableAttributedString()
        bottomFormatedText.regular("Don't Have an Account? Tap here to", size: 15).bold(" Register", size: 15)
        bottomFormatedText.addUnderLine(textToFind: "Register")
        bottomFormatedText.addLink(textToFind: " Register", linkURL: "register")
        bottomTextView.attributedText = bottomFormatedText
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func validate() -> Bool {
        if phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.phoneEmptyAlert)
            return false
        } else if !isValidPhone(validate: countryCode + phoneTextField.text!) {
            self.view.makeToast(ErrorMessage.invalidPhone)
            return false
        } else if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.passwordEmptyAlert)
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
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        if validate() {
            let param: [String: Any] = [
                "phone_number": countryCode + phoneTextField.text!,
                "password": passwordTextField.text!
            ]
            LoginVM.shared.loginAsyncCall(parameters: param)
        }
    }
}

// MARK: - API Services
extension LoginVC {
   
    func fetchLoginViewModel() {
        
        LoginVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        LoginVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        LoginVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                print(response)
            })
            .store(in: &cancellable)
        
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
    func countrySelected(country: CountryModel) {
        countryCode = country.phoneCode
        countryCodeButton.setTitle("\(country.phoneCode)", for: .normal)
        countryCodeButton.setImage(UIImage(named: country.code) ?? .placeholder1, for: .normal)
    }
}
