//
//  ExploreEventsVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit

class ExploreEventsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var hotEventsArray = [MeetEvent]()
    var allEventsArray = [MeetEvent]()
    let eventsHeadingsList = ["Happening Soon".localized, "More Events".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        performInitialSetup()
    }

    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.exploreEventsTableViewCell)
    }
    
    func configureEvents(hotEvents: [MeetEvent], allEvents: [MeetEvent]) {
        self.hotEventsArray = hotEvents
        self.allEventsArray = allEvents
    }
}

extension ExploreEventsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eventsHeadingsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return hotEventsArray.count // Hot events collection
        default:
            return allEventsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventsHeadingsList[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }
}

extension ExploreEventsVC {
    private func tableCell(indexPath:IndexPath) -> ExploreEventsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.exploreEventsTableViewCell, for: indexPath) as! ExploreEventsTableViewCell
       
        switch indexPath.section {
        case 0:
            congifureCell(cell: cell, event: hotEventsArray[indexPath.row])
        default:
            congifureCell(cell: cell, event: allEventsArray[indexPath.row])
        }
        return cell
    }
    
    func congifureCell(cell: ExploreEventsTableViewCell, event: MeetEvent) {
        cell.eventNameLbl.text = event.name ?? ""
        cell.eventImgView.setImage(imageStr: event.bannerImage?.image ?? "", placeholder: UIImage(named: "defaultEvent"))
        cell.eventCreatedByUserLbl.text = event.creator?.name ?? ""
        cell.noOfPeopleJoinedLbl.text = "\(event.peopleJoinedCount ?? 0) People joined"
        let date = event.date?.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.ddMMM) ?? ""
        cell.dateTimeLbl.text = "\(date), \(event.time ?? "")"
    }
}
