//
//  MeetChatVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit
import TwilioChatClient
import Combine
//import TwilioAccessManager

class MeetChatVC: UIViewController, ChatListTVDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var chatListTableView: ChatListTV!
   
    weak var chatTableDelegate: ChatListTVDelegate?
    var channels: [TCHChannel] = []
    var searchText = String()
    var filteredUserArray = [MeetUser]()
    var users = [MeetUser]()
    let dispatchGroup = DispatchGroup()
    private var userVM: MeetUserViewModel!
    private var myMatchUserVM: MeetMyMatchUserViewModel?
    var usersArray = [MeetUser]()
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        searchBar.delegate = self
        channels = [TCHChannel]()
        navigationController?.setNavigationBarHidden(true, animated: false)
        callToViewModelToFetchUser()
        chatListTableView.didSelect = didSelect
    }
   
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    //MARK:- View setup
    func callToViewModelToFetchUser(){
        userVM = MeetUserViewModel()
        myMatchUserVM = MeetMyMatchUserViewModel()
        userVM?.fetchMeetUserListAsyncCall()
        myMatchUserVM?.fetchMyMatchUserAsyncCall()
        fetchMeetUserViewModel()
    }
    
    //MARK:- View setup
    func didSelect(index:Int) {
        let receiverName = filteredUserArray[index].name ?? ""
        let receiverImage = filteredUserArray[index].profileImg ?? ""
        let receiverID = filteredUserArray[index].id ?? 0
        
        navigateToViewController(ChatDetailVC.self, storyboardName: StoryboardName.meet, animationType: .autoReverse(presenting: .zoom)) {
            vc in
            vc.channel = self.channels[index]
            vc.receiverImage = receiverImage
            vc.name = receiverName
            vc.selectedUserId = receiverID
            vc.userBlocked = self.userBlocked
        }
    }
    
    func userBlocked(){
        callToViewModelToFetchUser()
    }
    
    func getRecentChatList() {
        ChannelManager.sharedManager.chatlistdelegate = self
        ChannelManager.sharedManager.populateChannels()
    }
    
    func refresh() {
        
    }
   
    func checkforChannels() {
        
        var arrUserIDs = [Int]()
        let userID = "6"
        var count = 0
        
        for channel in ChannelManager.sharedManager.channels {
            count += 1
            
            if channel.uniqueName != nil {
                if (channel.uniqueName?.contains("_"))!{
                    var userIDs = channel.uniqueName?.components(separatedBy: "_")
                    if (userIDs?.contains(userID))! {
                        userIDs = userIDs?.filter{ $0 !=  userID}
                        arrUserIDs.append(Int(userIDs?[0] ?? "")!)
                        channels.append(channel)
                    }
                }
            }
        }
        
        if count == (ChannelManager.sharedManager.channels.count){
            self.getChatUserList(userIDs: arrUserIDs)
        }
    }
    
    func getChatUserList(userIDs : [Int]) {
        if userIDs.isEmpty {
          //  emptyView.isHidden = false
            chatListTableView.isHidden = true
        }else {
            var nonBlock : [Int] = []
            users.removeAll()
            chatListTableView.isHidden = false
        //    emptyView.isHidden = true
            
                for id in userIDs {
                    for user in usersArray {
                        if user.id == id {
                            nonBlock.append(id)
                            users.append(user)
                        }
                    }
                }
            
            for index in 0..<userIDs.count {
                if !nonBlock.contains(userIDs[index]){
                    channels.remove(at: index)
                }
            }
            
            self.filteredUserArray = users
            chatListTableView.displayData(data: filteredUserArray, channels: self.channels)
        }
    }
}

// MARK: - Network Related Response
extension MeetChatVC {
    
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
        usersArray = userList.response?.data ?? []
        getRecentChatList()
    }
}

extension MeetChatVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredUserArray = self.users
            self.chatListTableView.displayData(data: self.filteredUserArray, channels: self.channels)
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
            return
    
            }else if searchText.count >= 1 {
                    filteredUserArray = users.filter({ (chatUser) -> Bool in
                        let tmp: NSString = NSString.init(string: chatUser.name ?? "")
                        let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                        return range.location != NSNotFound
                    })
          
            
            if filteredUserArray.isEmpty {
                // print("No result")
                // showSnackbar(showMessage: ManageLocalization.getLocalizedString(key: "no_result"))
            }
            self.chatListTableView.displayData(data: self.filteredUserArray, channels: self.channels)
            //chatListTableView.reloadData()
           }
    }
    
}



