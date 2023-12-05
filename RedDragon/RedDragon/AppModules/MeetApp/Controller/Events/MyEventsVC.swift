//
//  MyEventsVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit

class MyEventsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var upcomingEventsArray = [MeetEvent]()
    var pastEventsArray = [MeetEvent]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
    }
    
    func nibInitialization() {
        collectionView.register(CellIdentifier.myEventsCollectionViewCell)
        tableView.register(CellIdentifier.exploreEventsTableViewCell)
    }
    
    func configureEvents(upcomingEvents: [MeetEvent], pastEvents: [MeetEvent]) {
        self.upcomingEventsArray = upcomingEvents
        self.pastEventsArray = pastEvents
    }
    
    // MARK: - Button Action
    @IBAction func createEventButtonTapped(_ sender: UIButton) {
        navigateToXIBViewController(CreateEventVC.self, nibName: "CreateEventVC")
    }
}

extension MyEventsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingEventsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionCell(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.width)-80, height: 178)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToXIBViewController(EventDetailVC.self, nibName: "EventDetailVC") {
            vc in
            vc.selectedEventId = self.upcomingEventsArray[indexPath.row].eventId ?? 0
        }
    }
}

extension MyEventsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastEventsArray.count // Hot events collection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToXIBViewController(EventDetailVC.self, nibName: "EventDetailVC") {
            vc in
            vc.selectedEventId = self.pastEventsArray[indexPath.row].eventId ?? 0
        }
    }
}

extension MyEventsVC {
    private func collectionCell(indexPath:IndexPath) -> MyEventsCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.myEventsCollectionViewCell, for: indexPath) as! MyEventsCollectionViewCell
        
        congifureCell(cell: cell, event: upcomingEventsArray[indexPath.row])
        return cell
    }
    
    private func tableCell(indexPath:IndexPath) -> ExploreEventsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.exploreEventsTableViewCell, for: indexPath) as! ExploreEventsTableViewCell
        
        congifureCell(cell: cell, event: pastEventsArray[indexPath.row])
        return cell
    }

    func congifureCell<T>(cell: T, event: MeetEvent) {
        if let cell = cell as? ExploreEventsTableViewCell {
            cell.eventNameLbl.text = event.name ?? ""
            cell.eventImgView.setImage(imageStr: event.bannerImage?.image ?? "", placeholder: UIImage(named: "defaultEvent"))
            cell.eventCreatedByUserLbl.text = event.creator?.name ?? ""
            cell.noOfPeopleJoinedLbl.text = "\(event.peopleJoinedCount ?? 0) People joined"
            let date = event.date?.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.ddMMM) ?? ""
            cell.dateTimeLbl.text = "\(date), \(event.time ?? "")"
        }else if let cell = cell as? MyEventsCollectionViewCell {
            cell.eventNameLbl.text = event.name ?? ""
            cell.eventImgView.setImage(imageStr: event.bannerImage?.image ?? "", placeholder: UIImage(named: "defaultEvent"))
            cell.eventCreatedByUserLbl.text = event.creator?.name ?? ""
            cell.noOfPeopleJoinedLbl.text = "\(event.peopleJoinedCount ?? 0) People joined"
            let date = event.date?.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.ddMMM) ?? ""
            cell.dateTimeLbl.text = "\(date), \(event.time ?? "")"
        }
    }
}
