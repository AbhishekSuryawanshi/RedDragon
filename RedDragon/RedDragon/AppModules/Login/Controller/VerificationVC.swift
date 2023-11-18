//
//  VerificationVC.swift
//  RedDragon
//
//  Created by Qasr01 on 14/11/2023.
//

import UIKit
import Combine

class VerificationVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet weak var bottomTextView: UITextView!
    
    var cancellable = Set<AnyCancellable>()
    var otpEntered = false
    var email = ""
    var phoneNumber = ""
    var otpValue = ""
    
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
        
        topTextLabel.text = "A verification code has been sent \nto your mobile number"
        let bottomFormatedText = NSMutableAttributedString()
        bottomFormatedText.regular("Didn’t receive the code? ", size: 15).bold("Resend", size: 15)
        bottomFormatedText.addUnderLine(textToFind: "Resend")
        bottomFormatedText.addLink(textToFind: "Resend", linkURL: "resend")
        bottomTextView.attributedText = bottomFormatedText
        otpTextFieldView.fieldSize = (screenWidth - 100) / 6
        otpTextFieldView.delegate = self
        otpTextFieldView.initializeUI()
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    // MARK: - Button Actions
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if otpEntered {
            let param: [String: Any] = [
                "phone": phoneNumber,
                "email": email,
                "code": otpValue
            ]
            LoginVM.shared.loginAsyncCall(parameters: param)
        }
    }
}

// MARK: - API Services
extension VerificationVC {
   
    func fetchLoginViewModel() {
        
        UserVerifyVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        UserVerifyVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        UserVerifyVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                
            })
            .store(in: &cancellable)
        
    }
}

//MARK: UITextView Delegates
extension VerificationVC: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "resend":
            print("resend preeeeee")
        default:
            print("")
        }
        return false
    }
}

// MARK:- OTPFieldViewDelegate
extension VerificationVC: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool { return true }
    
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        otpEntered = hasEntered
        return false
    }
    
    func textFeildshouldChangeCharacters() {}
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        otpValue = otpString
    }
}
