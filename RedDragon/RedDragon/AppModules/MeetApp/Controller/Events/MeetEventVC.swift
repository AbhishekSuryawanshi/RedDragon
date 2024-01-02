//
//  MeetEventVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit
import Combine

class MeetEventVC: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!
   
    var hotEventsArray = [MeetEvent]()
    var allEventsArray = [MeetEvent]()
    var myUpcomingEventsArray = [MeetEvent]()
    var myPastEventsArray = [MeetEvent]()
    var cancellable = Set<AnyCancellable>()
    private var hotEventVM: MeetHotEventViewModel?
    private var allEventVM: MeetAllEventViewModel?
    private var myUpcomingEventVM: MeetMyUpcomingEventViewModel?
    private var myPastEventVM: MeetMyPastEventViewModel?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
        performLanguageLocalisation()
    }
    
    func performLanguageLocalisation() {
        segmentControl.setTitle("Explore".localized, forSegmentAt: 0)
        segmentControl.setTitle("My Events".localized, forSegmentAt: 1)
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        makeNetworkCall()
        fetchHotEventVM()
        fetchAllEventVM()
        fetchMyUpcomingEventVM()
        fetchMyPastEventVM()
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func makeNetworkCall() {
        hotEventVM = MeetHotEventViewModel()
        allEventVM = MeetAllEventViewModel()
        myUpcomingEventVM = MeetMyUpcomingEventViewModel()
        myPastEventVM = MeetMyPastEventViewModel()
        
        hotEventVM?.fetchMeetHotEventListAsyncCall()
        allEventVM?.fetchMeetAllEventListAsyncCall()
        myUpcomingEventVM?.fetchMeetMyUpcomingEventListAsyncCall()
        myPastEventVM?.fetchMeetMyPastEventListAsyncCall()
    }
    
    // MARK: - Segment Control Actions
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        if self.segmentControl.selectedSegmentIndex == 0 {
            embedExploreEventsVC()
        }else{
            embedMyEventsVC()
        }
    }
}

// MARK: - Network Related Response
extension MeetEventVC {
    ///fetch view model for event list
    func fetchHotEventVM() {
        hotEventVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        hotEventVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        hotEventVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] eventList in
                self?.execute_onHotEventListResponse(eventList!)
            })
            .store(in: &cancellable)
    }
    
    func fetchAllEventVM() {
        allEventVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] eventList in
                self?.execute_onAllEventListResponse(eventList!)
            })
            .store(in: &cancellable)
    }
    
    func fetchMyUpcomingEventVM() {
        myUpcomingEventVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] eventList in
                self?.execute_onMyUpcomingEventResponse(eventList!)
            })
            .store(in: &cancellable)
    }
    
    func fetchMyPastEventVM() {
        myPastEventVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] eventList in
                self?.execute_onMyPastEventListResponse(eventList!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onHotEventListResponse(_ eventList: MeetEventListModel) {
        hotEventsArray = eventList.response?.data ?? []
    }
    
    func execute_onAllEventListResponse(_ eventList: MeetEventListModel) {
        allEventsArray = eventList.response?.data ?? []
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.embedExploreEventsVC() // default First segment selected
        }
    }
    
    func execute_onMyUpcomingEventResponse(_ eventList: MeetEventListModel) {
        myUpcomingEventsArray = eventList.response?.data ?? []
    }
    
    func execute_onMyPastEventListResponse(_ eventList: MeetEventListModel) {
        myPastEventsArray = eventList.response?.data ?? []
    }
}

// MARK: - Functions to add Child controllers in Parent View
extension MeetEventVC {
    func embedExploreEventsVC() {
        let childVC = ExploreEventsVC(nibName: "ExploreEventsVC" , bundle: nil)
        ViewEmbedder.embedXIBController(childVC: childVC, parentVC: self, container: viewContainer) { vc in
            let vc = vc as! ExploreEventsVC
            vc.configureEvents(hotEvents: self.hotEventsArray, allEvents: self.allEventsArray)
        }
    }
    
    func embedMyEventsVC() {
        let childVC = MyEventsVC(nibName: "MyEventsVC" , bundle: nil)
        ViewEmbedder.embedXIBController(childVC: childVC, parentVC: self, container: viewContainer) { vc in
            let vc = vc as! MyEventsVC
            vc.configureEvents(upcomingEvents: self.myUpcomingEventsArray, pastEvents: self.myPastEventsArray)
        }
    }
}
