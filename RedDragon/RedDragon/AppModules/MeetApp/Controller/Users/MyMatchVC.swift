//
//  MyMatchVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit
import SDWebImage

class MyMatchVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var users = [MeetUser]()
    var filteredUserArray = [MeetUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }

    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
    }
    
    func nibInitialization() {
        collectionView.register(CellIdentifier.matchesCollectionViewCell)
    }
    
    func configureUsers(users: [MeetUser]) {
        self.users = users
        self.filteredUserArray = users
    }
}

extension MyMatchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUserArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionCell(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.width/3)-10, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToViewController(MeetUserDetailVC.self, storyboardName: StoryboardName.meet, animationType: .autoReverse(presenting: .zoom)) {
            vc in
            vc.isMyMatchUser = true
            vc.selectedUserId = self.filteredUserArray[indexPath.row].id ?? 0
        }
    }
}

extension MyMatchVC {
    private func collectionCell(indexPath:IndexPath) -> MatchesCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.matchesCollectionViewCell, for: indexPath) as! MatchesCollectionViewCell
       
        let dict = self.filteredUserArray[indexPath.row]
        cell.usernameLbl.text = dict.name ?? ""
        cell.userImgView.sd_setImage(with: URL(string: dict.profileImg ?? ""), placeholderImage: UIImage(named: "placeholderUser"))
        let location = dict.location ?? ""
        cell.userLocationLbl.text = location

//        if location.isEmpty {
//            cell.locationIcon.isHidden = true
//        }else {
//            cell.locationIcon.isHidden = false
//        }
        return cell
    }
}

extension MyMatchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredUserArray = self.users
            self.collectionView.reloadData()
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
            return
            
        }else if searchText.count >= 1 {
            filteredUserArray = users.filter({ (chatUser) -> Bool in
                let tmp: NSString = NSString.init(string: chatUser.name ?? "")
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            
            
            if filteredUserArray.isEmpty {
                // print("No result")
                // showSnackbar(showMessage: ManageLocalization.getLocalizedString(key: "no_result"))
            }
            self.collectionView.reloadData()
            
        }
    }
}
