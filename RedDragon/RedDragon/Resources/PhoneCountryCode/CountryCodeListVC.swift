//
//  CountryCodeListVC.swift
//  RedDragon
//
//  Created by Qasr01 on 15/11/2023.
//

import UIKit

protocol CountryDelegate:AnyObject {
    func countrySelected(country: CountryModel)
}

class CountryCodeListVC: UIViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    weak var delegate:CountryDelegate?
    var countryListArray: [CountryModel] = []
    var countryArray: [CountryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    // MARK: - Methods
    func initialSettings() {
        nibInitialization()
        getCountries()
    }
    func nibInitialization() {
        contentTableView.register("CountryListTableViewCell")
    }
    func getCountries() {
        countryArray.removeAll()
        let resource: String = "countryCodes"
        if let jsonPath = Bundle.main.url(forResource: resource, withExtension: "json") {
            if let jsonData = try? Data(contentsOf: jsonPath) {
                do {
                    if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:String]] {
                        
                        for jsonObject in jsonObjects {
                            countryArray.append(CountryModel().createModel(data: jsonObject))
                        }
                        self.countryArray = countryArray.sorted(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
                        countryListArray = countryArray
                        self.contentTableView.reloadData()
                    }
                } catch let error {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - TableView Delegate
extension CountryCodeListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableViewCell", for: indexPath) as! CountryListTableViewCell
        let country = countryArray[indexPath.row]
        cell.flagIV.image = UIImage(named: country.code) ?? .placeholderPost
        cell.nameLBL.text = country.name
        cell.codeLBL.text = country.phoneCode
        return cell
    }
}
extension CountryCodeListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.countrySelected(country: countryArray[indexPath.row])
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
// MARK: - TextField Delegate

extension CountryCodeListVC: UITextFieldDelegate {
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
                    countryArray = countryListArray
                    countryArray = countryArray.filter({(item: CountryModel) -> Bool in
                        if item.name.lowercased().range(of: searchText.lowercased()) != nil {
                            return true
                        } else if item.code.lowercased().range(of: searchText.lowercased()) != nil {
                            return true
                        } else if item.phoneCode.lowercased().range(of: searchText.lowercased()) != nil {
                            return true
                        }
                        return false
                    })
                } else {
                    countryArray = countryListArray
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
        countryArray = countryListArray
        contentTableView.reloadData()
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text!.count > 0 {
            countryArray = countryListArray
            countryArray = countryArray.filter({(item: CountryModel) -> Bool in
                if item.name.lowercased().range(of: textField.text!.lowercased()) != nil {
                    return true
                } else if item.code.lowercased().range(of: textField.text!.lowercased()) != nil {
                    return true
                } else if item.phoneCode.lowercased().range(of: textField.text!.lowercased()) != nil {
                    return true
                }
                return false
            })
        } else {
            countryArray = countryListArray
        }
        contentTableView.reloadData()
        return true
    }
}

class CountryModel:NSObject {
    
    var name = ""
    var code = ""
    var phoneCode = ""
    
    func createModel(data:[String:Any]) -> CountryModel {
        name = data["name"] as? String ?? ""
        code = data["code"] as? String ?? ""
        phoneCode = data["dial_code"] as? String ?? ""
        return self
    }
}
