//
//  StreetMatchesDashboardVC.swift
//  RedDragon
//
//  Created by Remya on 11/23/23.
//

import UIKit

enum streetMatchesHeaderSegment: String, CaseIterable {
    case home = "Home"
    case stadiums = "Stadiums"
    case feeds = "Feeds"
    case matches = "Matches"
    case teams = "Teams"
    case profile = "Profile"
    
}

class StreetMatchesDashboardVC: UIViewController {
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var viewContainer: UIView!
    var selectedSegment: streetMatchesHeaderSegment = .home
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        headerCollectionView.reloadData()
    }
    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
        highlightFirstIndex_collectionView()
    }
    
    func nibInitialization() {
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
    }
}

// MARK: - CollectionView Delegates
extension StreetMatchesDashboardVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isUserLoggedIn(){
            return streetMatchesHeaderSegment.allCases.count
        }
        else{
            return (streetMatchesHeaderSegment.allCases.count - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
        cell.configureUnderLineCell(title: streetMatchesHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == streetMatchesHeaderSegment.allCases[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegment = streetMatchesHeaderSegment.allCases[indexPath.row]
        
        switch indexPath.item {
        case 0:
            embedStreetMatchHomeVC()
        case 1:
            embedStadiumsVC()
        case 2:
            embedStreetMatchEventsVC()
        case 3:
            embedStreetMatchesVC()
        case 4:
            embedStreetTeamsVC()
        case 5:
            embedStreetProfileVC()
        default:
            embedStreetProfileVC()
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selected = selectedSegment == streetMatchesHeaderSegment.allCases[indexPath.row]
        return CGSize(width: streetMatchesHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 26, height: 50)
    }
    
}

// MARK: - Functions to add Child controllers in Parent View
extension StreetMatchesDashboardVC {
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView(headerCollectionView, didSelectItemAt: indexPath)
    }
    
    func embedStreetMatchHomeVC() {
        ViewEmbedder.embed(withIdentifier: "StreetMatchHomeVC", storyboard: UIStoryboard(name: StoryboardName.streetMatches, bundle: nil), parent: self, container: viewContainer) { vc in
            //let vc = vc as! StreetMatchHomeVC
        }
    }
    
    func embedStadiumsVC() {
        ViewEmbedder.embed(withIdentifier: "StreetMatchStadiumVC", storyboard: UIStoryboard(name: StoryboardName.streetMatches, bundle: nil), parent: self, container: viewContainer) { vc in
            //let vc = vc as! StreetMatchStadiumVC
        }
    }
    
    func embedStreetMatchEventsVC() {
        ViewEmbedder.embed(withIdentifier: "StreetMatchEventsVC", storyboard: UIStoryboard(name: StoryboardName.streetMatches, bundle: nil), parent: self, container: viewContainer) { vc in
            
        }
    }
    
    func embedStreetMatchesVC() {
        ViewEmbedder.embed(withIdentifier: "StreetMatchesVC", storyboard: UIStoryboard(name: StoryboardName.streetMatches, bundle: nil), parent: self, container: viewContainer) { vc in
           // let vc = vc as! StreetMatchesVC
        }
    }
    
    func embedStreetTeamsVC() {
        ViewEmbedder.embed(withIdentifier: "StreetTeamsViewController", storyboard: UIStoryboard(name: StoryboardName.streetMatches, bundle: nil), parent: self, container: viewContainer) { vc in
           // let vc = vc as! StreetTeamsViewController
        }
    }
    
    func embedStreetProfileVC() {
       
        if !isUserStreetProfileUpdated(){
            self.view.makeToast("Please update player profile to continue".localized)
            
            ViewEmbedder.embed(withIdentifier: "StreetEditProfileViewController", storyboard: UIStoryboard(name: StoryboardName.streetMatches, bundle: nil), parent: self, container: viewContainer) { vc in
               let vc = vc as! StreetEditProfileViewController
               vc.isFromDashboard = true
            }
            return
        }
        ViewEmbedder.embed(withIdentifier: "StreetPlayerProfileViewController", storyboard: UIStoryboard(name: StoryboardName.streetMatches, bundle: nil), parent: self, container: viewContainer) { vc in
           // let vc = vc as! StreetTeamsViewController
        }
    }
}
