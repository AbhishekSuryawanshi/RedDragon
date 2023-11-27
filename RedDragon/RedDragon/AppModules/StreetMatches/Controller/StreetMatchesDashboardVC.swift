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
        return streetMatchesHeaderSegment.allCases.count
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
            embedMeetExploreVC()
        case 2:
            embedMeetEventVC()
        default:
            embedMeetChatVC()
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
            let vc = vc as! StreetMatchHomeVC
        }
    }
    
    func embedMeetExploreVC() {
        ViewEmbedder.embed(withIdentifier: "MeetExploreVC", storyboard: UIStoryboard(name: StoryboardName.meet, bundle: nil), parent: self, container: viewContainer) { vc in
            let vc = vc as! MeetExploreVC
        }
    }
    
    func embedMeetEventVC() {
        ViewEmbedder.embed(withIdentifier: "MeetEventVC", storyboard: UIStoryboard(name: StoryboardName.meet, bundle: nil), parent: self, container: viewContainer) { vc in
            let vc = vc as! MeetEventVC
        }
    }
    
    func embedMeetChatVC() {
        ViewEmbedder.embed(withIdentifier: "MeetChatVC", storyboard: UIStoryboard(name: StoryboardName.meet, bundle: nil), parent: self, container: viewContainer) { vc in
            let vc = vc as! MeetChatVC
        }
    }
}
