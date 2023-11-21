//
//  MeetExploreVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit
import Combine

class MeetExploreVC: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!
    var arrayOfUsers = [MeetUser]()
    var cancellable = Set<AnyCancellable>()
    private var userVM: MeetUserViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        makeNetworkCall()
        fetchMeetUserViewModel()
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func makeNetworkCall() {
        userVM = MeetUserViewModel()
        userVM?.fetchMeetUserListAsyncCall()
    }
    
    // MARK: - Segment Control Actions
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        if self.segmentControl.selectedSegmentIndex == 0{
            embedExploreUsersVC()
        }else{
            embedMyMatchesVC()
        }
    }
}

// MARK: - Network Related Response
extension MeetExploreVC {
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    ///fetch view model for user list
    func fetchMeetUserViewModel() {
        userVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        userVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        userVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] userList in
                self?.execute_onUserListResponseData(userList!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onUserListResponseData(_ userList: MeetUserListModel) {
        arrayOfUsers = userList.response?.data ?? []
    }
}
// MARK: - Functions to add Child controllers in Parent View
extension MeetExploreVC {
    func embedExploreUsersVC() {
        ViewEmbedder.embed(withIdentifier: "ExploreUsersVC", storyboard: UIStoryboard(name: StoryboardName.meet, bundle: nil), parent: self, container: viewContainer) { vc in
            let vc = vc as! ExploreUsersVC
            vc.configureUsers(users: self.arrayOfUsers)
        }
    }
    
    func embedMyMatchesVC() {
        ViewEmbedder.embed(withIdentifier: "MyMatchVC", storyboard: UIStoryboard(name: StoryboardName.meet, bundle: nil), parent: self, container: viewContainer) { vc in
            let vc = vc as! MyMatchVC
        }
    }
}
