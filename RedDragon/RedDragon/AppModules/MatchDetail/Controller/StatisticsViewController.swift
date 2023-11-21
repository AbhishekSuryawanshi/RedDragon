//
//  StatisticsViewController.swift
//  RedDragon
//
//  Created by QASR02 on 07/11/2023.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var highlightLabel: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var recentMatchesTableView: UITableView!
    @IBOutlet weak var recentMatchesTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var highlightViewHeight: NSLayoutConstraint!
    
    private var statisticsArray: [Statistic]?
    private var mediaArray: [Media]?
    private var eventsArray: [Event]?

    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.statisticTableViewCell)
        collectionview.register(CellIdentifier.mediaCollectionView)
        defineTableViewNibCell(tableView: recentMatchesTableView, cellName: CellIdentifier.recentMatchTableCell)
    }
    
    func configureStatisticView(statisticData: [Statistic]?) {
        guard let statisticData = statisticData else {
            return
        }
        if statisticData.isEmpty {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.dataNotFound.localized, image: ImageConstants.alertImage)
            tableViewHeight.constant = 0
        } else {
            statisticsArray = statisticData
            tableView.reloadData()
        }
    }
    
    func configureMediaData(mediaData: [Media]?) {
        guard let mediaData = mediaData else {
            return
        }
        if mediaData.isEmpty {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.dataNotFound.localized, image: ImageConstants.alertImage)
            highlightViewHeight.constant = 0
        } else {
            mediaArray = mediaData
            collectionview.reloadData()
        }
    }
    
    func configureEventsData(recentMatches: [Event]?) {
        guard let recentMatches = recentMatches else {
            return
        }
        if recentMatches.isEmpty {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.dataNotFound.localized, image: ImageConstants.alertImage)
        } else {
            eventsArray = recentMatches
            recentMatchesTableView.reloadData()
        }
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return statisticsArray?[section].data.count ?? 0
        } else {
            return eventsArray?[section].matches.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return statisticsArray?.count ?? 0
        } else {
            return eventsArray?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            guard let statistics = statisticsArray?[indexPath.section] else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.statisticTableViewCell, for: indexPath) as! StatisticsTableViewCell
            cell.configuration(statics: statistics.data[indexPath.row])
            return cell
        } else {
            guard let eventData = eventsArray?[indexPath.section] else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.recentMatchTableCell, for: indexPath) as! RecentMatchTableViewCell
            cell.configureRecentMatches(data: eventData, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 30
        } else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView {
            guard let sectionData = statisticsArray?[section] else {
                return nil
            }
            return UIHostingController(rootView: MatchStatisticHeaderView(title: sectionData.header)).view
        } else {
            guard let sectionData = eventsArray?[section] else {
                return nil
            }
            return UIHostingController(rootView: RecentMatchHeaderView(title: sectionData.leagueName)).view
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            tableViewHeight.constant = self.tableView.contentSize.height - 1200
        } else if tableView == self.recentMatchesTableView {
            recentMatchesTableViewHeight.constant = self.recentMatchesTableView.contentSize.height
        }
    }
}

extension StatisticsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = mediaArray?[indexPath.item] else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.mediaCollectionView, for: indexPath) as! MediaCollectionViewCell
        cell.configureMediaData(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaURL = mediaArray?[indexPath.item].video
        if let url = URL(string: mediaURL ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2.4 - 15, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}


///SwiftUI code for statistic table header
import SwiftUI

struct MatchStatisticHeaderView: View {
    let title: String
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 12, weight: .bold))
            }
        }
        .frame(height: 30)
    }
}

struct RecentMatchHeaderView: View {
    let title: String
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 12, weight: .bold))
            }
        }
        .frame(height: 30)
    }
}
