//
//  EditProfileVC.swift
//  RedDragon
//
//  Created by Qasr01 on 22/12/2023.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var basicTextFieldView: UIView!
    @IBOutlet weak var basicTextField: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    var settingType: SettingType?
    var selectedLanguage: LanguageType = .en
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialSettings()
    }

    func initialSettings() {
        selectedLanguage = UserDefaults.standard.language == "zh" ? .zh : .en
        phoneView.isHidden = settingType != .phone
        phoneTextField.placeholder = settingType?.rawValue.localized
        basicTextField.placeholder = settingType?.rawValue.localized
        headerLabel.text = "\("Edit".localized) \(settingType?.rawValue.localized ?? "")"
        saveButton.setTitle("Save".localized, for: .normal)
    }
    
    // MARK: - Button Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        if settingType == .language {
            UserDefaults.standard.language = selectedLanguage == .zh ? "zh" : "en"
            initialSettings()
        }
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Textfield Delegates
extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if settingType == .language {
            basicTextField.inputView = pickerView
        }
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
