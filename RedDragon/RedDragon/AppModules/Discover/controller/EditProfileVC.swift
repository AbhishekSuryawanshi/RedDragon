//
//  EditProfileVC.swift
//  RedDragon
//
//  Created by Qasr01 on 22/12/2023.
//

import UIKit
import Combine

class EditProfileVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var basicTextFieldView: UIView!
    @IBOutlet weak var basicTextField: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    var cancellable = Set<AnyCancellable>()
    var settingType: SettingType?
    var selectedLanguage: LanguageType = .en
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialSettings()
    }

    func initialSettings() {
        selectedLanguage = UserDefaults.standard.language == "en" ? .en : .zh
        basicTextFieldView.isHidden = settingType == .language
        phoneView.isHidden = settingType != .phone
        phoneTextField.placeholder = settingType?.rawValue.localized
        basicTextField.placeholder = settingType?.rawValue.localized
        headerLabel.text = "\("Edit".localized) \(settingType?.rawValue.localized ?? "")"
        saveButton.setTitle("Save".localized, for: .normal)
    }
    
    func nibInitialization() {
        listTableView.register(CellIdentifier.nameRightIconTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    // MARK: - Button Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        if settingType == .language {
            UserDefaults.standard.language = selectedLanguage == .en ? "en" : "zh"
            NotificationCenter.default.post(name: .languageUpdated, object: nil)
            initialSettings()
        }
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - API Services
extension EditProfileVC {
    func fetchProfileViewModel() {
        
        EditProfileVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        EditProfileVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        EditProfileVM.shared.$responseData
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
                
            }
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
    }
}

// MARK: - TableView Delegates
extension EditProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeightConstraint.constant = CGFloat(settingType == .language ? ((LanguageType.allCases.count * 60) + 50) : 0)
        return LanguageType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.nameRightIconTableViewCell, for: indexPath) as! NameRightIconTableViewCell
        cell.configureLanguageCell(type: LanguageType.allCases[indexPath.row], selected: LanguageType.allCases[indexPath.row] == selectedLanguage)
        return cell
    }
}
extension EditProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = LanguageType.allCases[indexPath.row]
        tableView.reloadData()
    }
}


// MARK: - Textfield Delegates
extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      
        return true
    }
}
// MARK: - PickerView Delegate
extension EditProfileVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if settingType == .language {
            return LanguageType.allCases.count
        } else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if settingType == .language {
            basicTextField.text = LanguageType.allCases[row].rawValue
            selectedLanguage = LanguageType.allCases[row]
        } else {
           
        }
    }
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = fontRegular(17)
        label.textAlignment = .center
        label.textColor = .black
        if settingType == .language {
            label.text = LanguageType.allCases[row].rawValue
        } else {
            
        }
        return label
    }
}
