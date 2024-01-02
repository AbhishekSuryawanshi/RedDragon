//
//  ExploreEventsVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit

class ExploreEventsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var hotEventsArray = [MeetEvent]()
    var hotEventsArray1 = [MeetEvent]()
    var allEventsArray1 = [MeetEvent]()
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
        tableView.register(ExploreEventsTableViewCell.nibName)
        tableView.register(NoDataTableViewCell.nibName)
    }
    
    func configureEvents(hotEvents: [MeetEvent], allEvents: [MeetEvent]) {
        self.hotEventsArray = hotEvents
        self.hotEventsArray1 = hotEvents
        self.allEventsArray1 = allEvents
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
            return hotEventsArray.isEmpty ? 1 : hotEventsArray.count // Hot events collection
        default:
            return allEventsArray.isEmpty ? 1 : allEventsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return hotEventsArray.isEmpty ? noDataTableCell(indexPath: indexPath) : tableCell(indexPath: indexPath) // Hot events collection
        default:
            return allEventsArray.isEmpty ? noDataTableCell(indexPath: indexPath) : tableCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventsHeadingsList[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return hotEventsArray.isEmpty ? UITableView.automaticDimension : 74 // Hot events collection
        default:
            return allEventsArray.isEmpty ? UITableView.automaticDimension : 74
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if !hotEventsArray.isEmpty {
                navigateToXIBViewController(EventDetailVC.self, nibName: "EventDetailVC") {
                    vc in
                    vc.selectedEventId = self.hotEventsArray[indexPath.row].eventId ?? 0
                }
            }
        default:
            if !allEventsArray.isEmpty {
                navigateToXIBViewController(EventDetailVC.self, nibName: "EventDetailVC") {
                    vc in
                    vc.selectedEventId = self.allEventsArray[indexPath.row].eventId ?? 0
                }
            }
        }
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
        cell.noOfPeopleJoinedLbl.text = "\(event.peopleJoinedCount ?? 0)" + "People joined".localized
        let date = event.date?.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.ddMMM) ?? ""
        cell.dateTimeLbl.text = "\(date), \(event.time ?? "")"
    }
    
    private func noDataTableCell(indexPath:IndexPath) -> NoDataTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoDataTableViewCell.nibName, for: indexPath) as! NoDataTableViewCell
        tableView.separatorStyle = .none
        cell.configureCell(message: "No events found.".localized)
        return cell
    }
}

extension ExploreEventsVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.hotEventsArray = self.hotEventsArray1
            self.allEventsArray = self.allEventsArray1
            self.tableView.reloadData()
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
            return
            
        }else if searchText.count >= 1 {
            self.hotEventsArray = hotEventsArray1.filter{($0.name?.lowercased().contains(searchText.lowercased()) ?? false)
                || ($0.creator?.name?.lowercased().contains(searchText.lowercased()) ?? false)}
            
            self.allEventsArray = allEventsArray1.filter{($0.name?.lowercased().contains(searchText.lowercased()) ?? false)
                || ($0.creator?.name?.lowercased().contains(searchText.lowercased()) ?? false)}
            
            self.tableView.reloadData()
            
        }
    }
}
