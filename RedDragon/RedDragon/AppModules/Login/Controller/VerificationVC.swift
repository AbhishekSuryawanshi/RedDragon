//
//  VerificationVC.swift
//  RedDragon
//
//  Created by Qasr01 on 14/11/2023.
//

import UIKit
import Combine

enum verifyPushType {
    case login
    case register
    case forgotPass
}

class VerificationVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet weak var bottomTextView: UITextView!
    
    var cancellable = Set<AnyCancellable>()
    var otpEntered = false
    var email = ""
    var phoneNumber = ""
    var password = ""
    var otpValue = ""
    var pushFrom: verifyPushType = .login //push from which page
    
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
        fetchLoginViewModel()
        
        topTextLabel.text = "A verification code has been sent \nto your mobile number"
        ///For forgot password, resent api will not work, It require authentication
        if pushFrom != .forgotPass {
            let bottomFormatedText = NSMutableAttributedString()
            bottomFormatedText.regular("Didn’t receive the code? ", size: 15).bold("Resend", size: 15)
            bottomFormatedText.addUnderLine(textToFind: "Resend")
            bottomFormatedText.addLink(textToFind: "Resend", linkURL: "resend")
            bottomTextView.attributedText = bottomFormatedText
        }
        otpTextFieldView.fieldSize = (screenWidth - 100) / 6
        otpTextFieldView.delegate = self
        otpTextFieldView.initializeUI()
        
        ///non - verified user tried to login, resend otp for verification
        if pushFrom == .login {
            ResendOtpVM.shared.resendOtpAsyncCall()
        }
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    // MARK: - Button Actions
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        if otpEntered {
            
            if pushFrom == .forgotPass {
                /// Api call handled ResetPasswordVC
                self.presentOverViewController(ResetPasswordVC.self, storyboardName: StoryboardName.login) { vc in
                    vc.verificationCode = self.otpValue
                }
            } else {
                
                let param: [String: Any] = [
                    "phone": phoneNumber,
                    "email": email,
                    "code": otpValue
                ]
                UserVerifyVM.shared.verificationAsyncCall(parameters: param)
            }
        } else {
            self.view.makeToast(ErrorMessage.otpEmptyAlert)
        }
    }
}

// MARK: - API Services
extension VerificationVC {
    func fetchLoginViewModel() {
        //response of otp verification
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
                self?.execute_onVerifyResponseData(response)
            })
            .store(in: &cancellable)
        
        //response of resend otp
        ResendOtpVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        ResendOtpVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        ResendOtpVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onResendResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onVerifyResponseData(_ response: LoginResponse?) {
        
        if let dataResponse = response?.response {
            if let user = dataResponse.data {
                if user.otpVerified == 1 {
                    ///User verified
                    UserDefaults.standard.user = user
                    UserDefaults.standard.token = user.token
                    UserDefaults.standard.budget = Int(user.affAppData?.sportCard?.budget ?? "200000000")
                    UserDefaults.standard.score = Int(user.affAppData?.sportCard?.score ?? "0")
                    //go back to tabbar
                    NotificationCenter.default.post(name: NSNotification.dismissLoginVC, object: nil)
                } else {
                    self.view.makeToast(ErrorMessage.incorrectOTP)
                }
            }
        } else {
            if let errorResponse = response?.error {
                self.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
            }
        }
    }
    
    func execute_onResendResponseData(_ response: LoginResponse?) {
        
        if let dataResponse = response?.response {
            self.view.makeToast(dataResponse.messages?.first)
        } else {
            if let errorResponse = response?.error {
                self.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
            }
        }
    }
}

//MARK: UITextView Delegates
extension VerificationVC: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "resend":
            ResendOtpVM.shared.resendOtpAsyncCall()
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
