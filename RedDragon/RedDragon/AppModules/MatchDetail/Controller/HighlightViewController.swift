//
//  HighlightViewController.swift
//  RedDragon
//
//  Created by QASR02 on 07/11/2023.
//

import UIKit
import SDWebImage

class HighlightViewController: UIViewController {
    
    @IBOutlet weak var highlightTableView: UITableView!
    @IBOutlet weak var symbolCollectionView: UICollectionView!
    
    private var highlightProgress: [Progress]?
    private let symbolIconsArray: [UIImage] = [#imageLiteral(resourceName: "goal"), #imageLiteral(resourceName: "disallowedGoal"), #imageLiteral(resourceName: "substitution"), #imageLiteral(resourceName: "yellowCard"), #imageLiteral(resourceName: "redCard"), #imageLiteral(resourceName: "var"), #imageLiteral(resourceName: "penalty"), #imageLiteral(resourceName: "minutes")]
    private let symbolNameArray: [String] = [StringConstants.goal.localized,
                                     StringConstants.disallowed.localized,
                                     StringConstants.substitution.localized,
                                     StringConstants.yellowCard.localized,
                                     StringConstants.redCard.localized,
                                     StringConstants.VAR.localized,
                                     StringConstants.penalty.localized,
                                     StringConstants.minutesAdded.localized]
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        symbolCollectionView.reloadData()
    }
    
    func configureView(progressData: [Progress]?) {
        guard let progressData = progressData else {
            return
        }
        if progressData.isEmpty {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.dataNotFound.localized, image: ImageConstants.alertImage)
        } else {
            highlightProgress = progressData
            symbolCollectionView.reloadData()
        }
    }
}

extension HighlightViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.symbolCollectionViewCell, for: indexPath) as! SymbolsCollectionViewCell
        cell.symbolImageView.image = symbolIconsArray[indexPath.item]
        cell.symbolNameLabel.text = symbolNameArray[indexPath.item]
        return cell
    }
}

extension HighlightViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlightProgress?[section].data.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return highlightProgress?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let progressData = highlightProgress?[indexPath.section] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.highlightTableViewCell, for: indexPath) as! HighlightTableViewCell
        cell.configureCell(progressData: progressData, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionData = highlightProgress?[section] else {
            return nil
        }
        return UIHostingController(rootView: MatchHighlightHeaderView(title: sectionData.title)).view
    }
}


///Swift UI code for tableview header section
import SwiftUI

struct MatchHighlightHeaderView: View {
    let title: String
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 224/255, blue: 138/255, opacity: 1)
            VStack {
                Text(title)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .bold))
            }
            .frame(height: 50)
        }
    }
}

