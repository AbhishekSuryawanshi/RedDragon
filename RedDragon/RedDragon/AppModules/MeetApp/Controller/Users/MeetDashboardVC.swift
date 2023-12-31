//
//  MeetDashboardVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit

enum meetHeaderSegment: String, CaseIterable {
    case home = "Home"
    case explore = "Explore"
    case event = "Event"
    case chat = "Chat"
}

class MeetDashboardVC: UIViewController {
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var viewContainer: UIView!
    var selectedSegment: meetHeaderSegment = .home
    var MessagingClientClass = MessagingManager.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        performInitialSetup()
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
extension MeetDashboardVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meetHeaderSegment.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
        cell.configureUnderLineCell(title: meetHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == meetHeaderSegment.allCases[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegment = meetHeaderSegment.allCases[indexPath.row]
        
        switch indexPath.item {
        case 0:
            embedMeetHomeVC()
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
        let selected = selectedSegment == meetHeaderSegment.allCases[indexPath.row]
        return CGSize(width: meetHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 26, height: 50)
    }
}

// MARK: - Functions to add Child controllers in Parent View
extension MeetDashboardVC {
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView(headerCollectionView, didSelectItemAt: indexPath)
    }
    
    func embedMeetHomeVC() {
        ViewEmbedder.embed(withIdentifier: "MeetHomeVC", storyboard: UIStoryboard(name: StoryboardName.meet, bundle: nil), parent: self, container: viewContainer)
    }
    
    func embedMeetExploreVC() {
        ViewEmbedder.embed(withIdentifier: "MeetExploreVC", storyboard: UIStoryboard(name: StoryboardName.meet, bundle: nil), parent: self, container: viewContainer)
    }
    
    func embedMeetEventVC() {
        ViewEmbedder.embed(withIdentifier: "MeetEventVC", storyboard: UIStoryboard(name: StoryboardName.meet, bundle: nil), parent: self, container: viewContainer)
    }
    
    func embedMeetChatVC() {
        ViewEmbedder.embed(withIdentifier: "MeetChatVC", storyboard: UIStoryboard(name: StoryboardName.meet, bundle: nil), parent: self, container: viewContainer)
    }
}
