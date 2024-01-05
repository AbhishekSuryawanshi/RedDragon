//
//  CountryListVC.swift
//  RedDragon
//
//  Created by Qasr01 on 04/01/2024.
//

import UIKit
import Combine

protocol CountryDelegate:AnyObject {
    func countrySelected(country: Country)
}

class CountryListVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    weak var delegate:CountryDelegate?
    var cancellable = Set<AnyCancellable>()
    var countryArray: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerLabel.text = "Countries".localized
        searchTextField.placeholder = "Search".localized
    }
    
    // MARK: - Methods
    func initialSettings() {
        nibInitialization()
        fetchCountryViewModel()
        CountryListVM.shared.getCountryListAsyncCall()
    }
    
    func nibInitialization() {
        contentTableView.register(CellIdentifier.countryTableViewCell)
    }
}

// MARK: - API Services
extension CountryListVC {
    func fetchCountryViewModel() {
        CountryListVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        CountryListVM.shared.displayLoader = { [weak self] value in
            value ? self?.startLoader() : stopLoader()
        }
        CountryListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    CountryListVM.shared.countryArray = dataResponse.data ?? []
                    self?.countryArray = CountryListVM.shared.countryArray
                    self?.contentTableView.reloadData()
                } else {
                    if let errorResponse = response?.error {
                        self?.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
                    }
                }
            })
            .store(in: &cancellable)
    }
}

// MARK: - TableView Delegate
extension CountryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.countryTableViewCell, for: indexPath) as! CountryTableViewCell
        cell.configureCellValues(model: countryArray[indexPath.row])
        return cell
    }
}
extension CountryListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.countrySelected(country: countryArray[indexPath.row])
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - TextField Delegate
extension CountryListVC: UITextFieldDelegate {
    func  textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var allowedCharacterSet = CharacterSet.alphanumerics.union(.whitespaces).union(.whitespaces)
        allowedCharacterSet.insert(charactersIn: "+")
        
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        if alphabet {
            if let text = textField.text,
               let textRange = Range(range, in: text) {
                let searchText = text.replacingCharacters(in: textRange,with: string)
                if searchText.count > 0 {
                    countryArray = CountryListVM.shared.countryArray
                    countryArray = countryArray.filter({(item: Country) -> Bool in
                        if item.name.lowercased().range(of: searchText.lowercased()) != nil {
                            return true
                        } else if item.CountryCode.lowercased().range(of: searchText.lowercased()) != nil {
                            return true
                        } else if item.phoneCode.lowercased().range(of: searchText.lowercased()) != nil {
                            return true
                        }
                        return false
                    })
                } else {
                    countryArray = CountryListVM.shared.countryArray
                }
                contentTableView.reloadData()
            }
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        countryArray = CountryListVM.shared.countryArray
        contentTableView.reloadData()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text!.count > 0 {
            countryArray = CountryListVM.shared.countryArray
            countryArray = countryArray.filter({(item: Country) -> Bool in
                if item.name.lowercased().range(of: textField.text!.lowercased()) != nil {
                    return true
                } else if item.CountryCode.lowercased().range(of: textField.text!.lowercased()) != nil {
                    return true
                } else if item.phoneCode.lowercased().range(of: textField.text!.lowercased()) != nil {
                    return true
                }
                return false
            })
        } else {
            countryArray = CountryListVM.shared.countryArray
        }
        contentTableView.reloadData()
        return true
    }
}


