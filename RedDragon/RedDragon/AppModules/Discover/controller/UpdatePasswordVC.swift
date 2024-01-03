//
//  UpdatePasswordVC.swift
//  RedDragon
//
//  Created by Qasr01 on 03/01/2024.
//

import UIKit
import Combine

class UpdatePasswordVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var newPasswordTitleLabel: UILabel!
    @IBOutlet weak var confirmPassTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfileViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshPage()
    }
    
    func refreshPage() {
        headerLabel.text = "Reset Password".localized
        passwordTitleLabel.text = "Password".localized
        newPasswordTitleLabel.text = "New Password".localized
        confirmPassTitleLabel.text = "Confirm Password".localized
        newPasswordTextField.placeholder = "New Password".localized
        passwordTextField.placeholder = "Password".localized
        confirmPasswordTextfield.placeholder = "Confirm Password".localized
        saveButton.setTitle("Save".localized, for: .normal)
    }
    
    func validate() -> Bool {
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.passwordEmptyAlert.localized)
            return false
        } else if newPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.newPasswordEmptyAlert.localized)
            return false
        } else if !isValidPassword(validate: newPasswordTextField.text!) {
            self.view.makeToast(ErrorMessage.passwordCondition.localized)
            return false
        } else if confirmPasswordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.confirmPasswordEmptyAlert.localized)
            return false
        } else if newPasswordTextField.text! != confirmPasswordTextfield.text! {
            self.view.makeToast(ErrorMessage.passwordNotmatchedAlert.localized)
            return false
        }
        return true
    }
    
    // MARK: - Button Actions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if validate() {
            let param: [String: Any] = [
                "old_password": passwordTextField.text!,
                "confirm_password": confirmPasswordTextfield.text!,
                "password": newPasswordTextField.text!
            ]
            UpdatePasswordVM.shared.updatePasswordAsyncCall(parameters: param)
        }
    }
}

// MARK: - API Services
extension UpdatePasswordVC {
    
    func fetchProfileViewModel() {
        UpdatePasswordVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        UpdatePasswordVM.shared.displayLoader = { [weak self] value in
            value ? self?.startLoader() : stopLoader()
        }
        UpdatePasswordVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ response: BasicAPIResponse?) {
        
        if let dataResponse = response?.response {
            self.view.makeToast(dataResponse.messages?.first)
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
    }
}
