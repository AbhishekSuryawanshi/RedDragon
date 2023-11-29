//
//  NewsModuleVC.swift
//  RedDragon
//
//  Created by Qasr01 on 25/11/2023.
//

import UIKit
 
enum NewsHeaders: String, CaseIterable {
    case gossip = "Gossip"
    case news   = "News"
}

class NewsModuleVC: UIViewController {

    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var containerView: UIView!
    
    let sportsTypeArray: [SportsType] = [.all, .football, .basketball, .tennis, .eSports]
    var sportType: SportsType = .all
    var contentType: NewsHeaders = .gossip
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    func initialSettings() {
        nibInitialization()
        setView()
    }
    
    func setView() {
        if contentType == .gossip {
            ViewEmbedder.embed(withIdentifier: "GossipVC", storyboard: UIStoryboard(name: StoryboardName.gossip, bundle: nil)
                               , parent: self, container: containerView) { vc in
            }
        } else {
            ViewEmbedder.embed(withIdentifier: "NewsVC", storyboard: UIStoryboard(name: StoryboardName.news, bundle: nil)
                               , parent: self, container: containerView) { vc in
            }
        }
    }
    
    func nibInitialization() {
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        sportsCollectionView.register(CellIdentifier.headerTopCollectionViewCell)

    }
}

// MARK: - CollectionView Delegates
extension NewsModuleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == headerCollectionView {
            return NewsHeaders.allCases.count
        } else {
            return sportsTypeArray.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell

        
        if collectionView == headerCollectionView {
            cell.configureUnderLineCell(title: NewsHeaders.allCases[indexPath.row].rawValue, selected: NewsHeaders.allCases[indexPath.row] == contentType)
        } else {
            cell.configureUnderLineCell(title: sportsTypeArray[indexPath.row].rawValue, selected: sportsTypeArray[indexPath.row] == sportType, textColor: .black, fontSize: 15)
        }
        return cell
    }
}

extension NewsModuleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            contentType = NewsHeaders.allCases[indexPath.row]
        } else {
            sportType = sportsTypeArray[indexPath.row]
        }
        collectionView.reloadData()
        setView()
    }
}

extension NewsModuleVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == headerCollectionView {
            return CGSize(width: (screenWidth - 70) / 2, height: 60)
        } else {
            let selected = sportsTypeArray[indexPath.row] == sportType
            return CGSize(width: sportsTypeArray[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : fontMedium(15)]).width + 30, height: 40)
        }
    }
}



// MARK: - TextField Delegate
extension NewsModuleVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let searchText = text.replacingCharacters(in: textRange,with: string)
            print("searchText  \(searchText)")

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
