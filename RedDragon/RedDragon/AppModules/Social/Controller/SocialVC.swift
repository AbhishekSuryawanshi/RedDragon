//
//  SocialVC.swift
//  RedDragon
//
//  Created by Qasr01 on 26/10/2023.
//

import UIKit

enum socialHeaderSegment: String, CaseIterable {
    case followed = "Followed"
    case recommend = "Recommended"
    case new = "Newest"
}

class SocialVC: UIViewController {
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    var selectedSegment: socialHeaderSegment = .followed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
    }
    
    func nibInitialization() {
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        sportsCollectionView.register(CellIdentifier.headerBottom_1CollectionViewCell)
        leagueCollectionView.register(CellIdentifier.IconNameCollectionViewCell)
        teamsCollectionView.register(CellIdentifier.IconNameCollectionViewCell)
    }
}

extension SocialVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialHeaderSegment.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
            cell.configure(title: socialHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == socialHeaderSegment.allCases[indexPath.row])
            return cell
        } else if collectionView == leagueCollectionView || collectionView == teamsCollectionView {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.IconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            cell.configure(title: "Laliga", iconName: "", style: collectionView == leagueCollectionView ? .league : .team)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerBottom_1CollectionViewCell, for: indexPath) as! HeaderBottom_1CollectionViewCell
            cell.configure(title: socialHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == socialHeaderSegment.allCases[indexPath.row])
            return cell
        }
    }
    
}

extension SocialVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == leagueCollectionView || collectionView == teamsCollectionView {
        } else {
            selectedSegment = socialHeaderSegment.allCases[indexPath.row]
            collectionView.reloadData()
        }
    }
}

extension SocialVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            let selected = selectedSegment == socialHeaderSegment.allCases[indexPath.row]
            return CGSize(width: socialHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 40, height: 50)
        } else if collectionView == leagueCollectionView {
            return CGSize(width: 80, height: 112)
        } else if collectionView == teamsCollectionView {
            return CGSize(width: 80, height: 112)
        } else {
            let selected = selectedSegment == socialHeaderSegment.allCases[indexPath.row]
            return CGSize(width: socialHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : fontMedium(15)]).width + 70, height: 40)
        }
        
    }
}
