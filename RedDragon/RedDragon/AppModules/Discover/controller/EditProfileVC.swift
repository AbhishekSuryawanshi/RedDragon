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
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    var cancellable = Set<AnyCancellable>()
    var settingType: SettingType?
    var selectedLanguage: LanguageType = .en
    var selectedGender: GenderType = .male
    var selectedCountry = Country()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshView()
    }
    
    func initialSettings() {
        nibInitialization()
        fetchProfileViewModel()
        
        //Configure date picker
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    
    func refreshView() {
        headerLabel.text = "\("Edit".localized) \(settingType?.rawValue.localized ?? "")"
        basicTextFieldView.isHidden = !(settingType != .language && settingType != .gender && settingType != .phone)
        basicTextField.placeholder = settingType?.rawValue.localized
        locationButton.isHidden = settingType != .location
        saveButton.setTitle("Save".localized, for: .normal)
        
        //set value
        basicTextField.text = ProfileVM.shared.getProfileValue(type: settingType!)
        selectedLanguage = UserDefaults.standard.language == "en" ? .en : .zh
        selectedGender = UserDefaults.standard.user?.gender == "male" ? .male : (UserDefaults.standard.user?.gender == "female" ? .female : .other)
    }
    
    func nibInitialization() {
        listTableView.register(CellIdentifier.nameRightIconTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func validate() -> Bool {
        if settingType != .gender && settingType != .language {
            if basicTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                self.view.makeToast("Please enter your \(settingType?.rawValue.lowercased() ?? "")".localized)
                return false
            }
            return true
        }
        return true
    }
    
    func updateProfile() {
        if validate() {
            var param: [String: Any] = [:]
            
            switch settingType {
            case .name:
                param.updateValue(basicTextField.text!, forKey: "full_name")
            case .userName:
                param.updateValue(basicTextField.text!, forKey: "username")
            case .email:
                param.updateValue(basicTextField.text!, forKey: "email")
            case .location:
                param.updateValue(selectedCountry.id, forKey: "location_id")
            case .gender :
                param.updateValue(selectedGender.rawValue, forKey: "gender")
            case .dob :
                param.updateValue(basicTextField.text!.formatDate(inputFormat: dateFormat.ddMMyyyy2, outputFormat: dateFormat.yyyyMMdd), forKey: "dob")
            case .language:
                param.updateValue(selectedLanguage == .en ? "en" : "zh", forKey: "preffered_language")
            default:
                return
            }
            EditProfileVM.shared.updateProfileAsyncCall(parameter: param)
        }
    }
    
    // MARK: - UIDatePicker
    @objc func handleDatePicker(_ datePicker: UIDatePicker) {
        basicTextField.text = datePicker.date.formatDate(outputFormat: dateFormat.ddMMyyyy2)
    }
    
    // MARK: - Button Actions
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        let countryVC = CountryListVC()
        countryVC.delegate = self
        self.present(countryVC, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            updateProfile()
        } else {
            if settingType == .language {
                UserDefaults.standard.language = selectedLanguage == .en ? "en" : "zh"
                initialSettings()
                NotificationCenter.default.post(name: .languageUpdated, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
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
                UserDefaults.standard.user = user
                UserDefaults.standard.token = user.token
                UserDefaults.standard.budget = Int(user.affAppData?.sportCard?.budget ?? "200000000")
                UserDefaults.standard.score = Int(user.affAppData?.sportCard?.score ?? "0")
                
                if settingType == .language {
                    initialSettings()
                    NotificationCenter.default.post(name: .languageUpdated, object: nil)
                }
                
                self.navigationController?.popViewController(animated: true)
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
        if settingType == .language {
            tableViewHeightConstraint.constant =  CGFloat(LanguageType.allCases.count * 57) + 50
            return LanguageType.allCases.count
        } else if settingType == .gender {
            tableViewHeightConstraint.constant = CGFloat(GenderType.allCases.count * 57) + 50
            return GenderType.allCases.count
        } else {
            tableViewHeightConstraint.constant = 0
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.nameRightIconTableViewCell, for: indexPath) as! NameRightIconTableViewCell
        
        if settingType == .language {
            cell.configureCell(name: LanguageType.allCases[indexPath.row].rawValue, selected: LanguageType.allCases[indexPath.row] == selectedLanguage)
        } else {
            cell.configureCell(name: GenderType.allCases[indexPath.row].rawValue.capitalized, selected: GenderType.allCases[indexPath.row] == selectedGender)
        }
        return cell
    }
}

extension EditProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settingType == .language {
            selectedLanguage = LanguageType.allCases[indexPath.row]
        } else {
            selectedGender = GenderType.allCases[indexPath.row]
        }
        tableView.reloadData()
    }
}


// MARK: - Textfield Delegates
extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if settingType == .dob {
            textField.inputView = self.datePicker
        }
        return true
    }
}

// MARK: - Custom Delegate
extension EditProfileVC: CountryDelegate {
    func countrySelected(country: Country) {
        selectedCountry = country
        basicTextField.text = selectedCountry.name
    }
}
