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
    var cancellable = Set<AnyCancellable>()
    private var hotEventVM: MeetHotEventViewModel?
    private var allEventVM: MeetAllEventViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        makeNetworkCall()
        fetchHotEventVM()
        fetchAllEventVM()
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func makeNetworkCall() {
        hotEventVM = MeetHotEventViewModel()
        allEventVM = MeetAllEventViewModel()
        hotEventVM?.fetchMeetHotEventListAsyncCall()
        allEventVM?.fetchMeetAllEventListAsyncCall()
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
                self?.execute_onHotEventListResponseData(eventList!)
            })
            .store(in: &cancellable)
    }
    
    func fetchAllEventVM() {
        allEventVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] eventList in
                self?.execute_onAllEventListResponseData(eventList!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onHotEventListResponseData(_ eventList: MeetEventListModel) {
        hotEventsArray = eventList.response?.data ?? []
    }
    
    func execute_onAllEventListResponseData(_ eventList: MeetEventListModel) {
        allEventsArray = eventList.response?.data ?? []
        embedExploreEventsVC() // default First segment selected
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
          //  vc.configureUsers(users: self.arrayOfMatchUsers)
        }
    }
}
