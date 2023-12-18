//
//  HomeVC.swift
//  RedDragon
//
//  Created by iOS Dev on 13/12/2023.
//

import UIKit

enum homeHeaderSegment: String, CaseIterable {
    case info = "Info"
    case experts = "Experts"
    case forYou = "For you"
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var viewContainer: UIView!
    
    var selectedSegment: homeHeaderSegment = .info
    var MessagingClientClass = MessagingManager.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        performInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
        highlightFirstIndex_collectionView()
        
        let MessagingManager = self.MessagingClientClass.sharedManager()
        let userID = "\(UserDefaults.standard.user?.appDataIDs.vinderUserId ?? 0)"
        MessagingManager.loginWith(identity: userID) { (sucess, error) in
            if sucess {
                // print("User get login with Twilio")
            }else {
                // print("ERROR WITH TWILIO LOGIN")
            }
        }
    }
    
    func nibInitialization() {
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
    }
}

// MARK: - CollectionView Delegates
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeHeaderSegment.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
        cell.configureUnderLineCell(title: homeHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == homeHeaderSegment.allCases[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegment = homeHeaderSegment.allCases[indexPath.row]
        
        switch indexPath.item {
        case 0:
            embedInfoVC()
        case 1:
            embedExpertsVC()
        default:
            embedForYouVC()
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selected = selectedSegment == homeHeaderSegment.allCases[indexPath.row]
        return CGSize(width: homeHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 26, height: 50)
    }
}

// MARK: - Functions to add Child controllers in Parent View
extension HomeVC {
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView(headerCollectionView, didSelectItemAt: indexPath)
    }
    
    func embedInfoVC() {
        ViewEmbedder.embed(withIdentifier: "InfoVC", storyboard: UIStoryboard(name: StoryboardName.info, bundle: nil), parent: self, container: viewContainer) { vc in
            let vc = vc as! InfoVC
            vc.configureUI()
        }
    }
    
    func embedExpertsVC() {
        ViewEmbedder.embed(withIdentifier: "ExpertsVC", storyboard: UIStoryboard(name: StoryboardName.expert, bundle: nil), parent: self, container: viewContainer)
    }
    
    func embedForYouVC() {
        ViewEmbedder.embed(withIdentifier: "ForYouVC", storyboard: UIStoryboard(name: StoryboardName.forYou, bundle: nil), parent: self, container: viewContainer)
    }
}
