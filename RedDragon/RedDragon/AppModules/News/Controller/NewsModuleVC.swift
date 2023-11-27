//
//  NewsModuleVC.swift
//  RedDragon
//
//  Created by Qasr01 on 25/11/2023.
//

import UIKit

class NewsModuleVC: UIViewController {

    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func initialSettings() {
        
    }
    
    func nibInitialization() {
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        sportsCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
    }
}

// MARK: - CollectionView Delegates
extension NewsModuleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
        return cell
    }
}

extension NewsModuleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}

extension NewsModuleVC: UICollectionViewDelegateFlowLayout {
   
}


// MARK: - TextField Delegate
extension NewsModuleVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let searchText = text.replacingCharacters(in: textRange,with: string)
            print("searchText  \(searchText)")
            //  searchData(text: searchText)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //searchData(text: searchTextField.text!)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        //searchData(text: searchTextField.text!)
        return true
    }
    
}
