//
//  MeetHomeVC.swift
//  RedDragon
//
//  Created by iOS Dev on 20/11/2023.
//

import UIKit
import Shuffle
import Gifu
import Combine

class MeetHomeVC: UIViewController {
    @IBOutlet weak var cardStack: SwipeCardStack!
    @IBOutlet weak var viewContainerForButtons: UIView!
    @IBOutlet weak var matchGifImageView: GIFImageView!
    @IBOutlet weak var matchUserNameLabel: UILabel!
    @IBOutlet weak var gifContainerView: UIView!
    
    var cancellable = Set<AnyCancellable>()
    private var userVM: MeetUserViewModel?
    private var likedUserVM: MeetLikedUserViewModel?
    var arrayOfUsers = [MeetUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        cardStack.delegate = self
        cardStack.dataSource = self
        gifContainerView.isHidden = true
        makeNetworkCall()
        fetchMeetUserViewModel()
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func makeNetworkCall() {
        userVM = MeetUserViewModel()
        userVM?.fetchMeetUserListAsyncCall()
    }
    
    // MARK: - Button Actions
    @IBAction func likeDislikeButtonTapped(_ sender: UIButton) {
        if sender.tag == 1 {  //Dislike User
            cardStack.swipe(.left, animated: true)
    
        }else { // Like User
            cardStack.swipe(.right, animated: true)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        matchGifImageView.stopAnimatingGIF()
        gifContainerView.isHidden = true
    }
}

// MARK: - Network Related Response
extension MeetHomeVC {
    
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
        cardStack.reloadData()
    }
    
    func fetchMeetLikeUserViewModel(_ likedUserIndex: Int) {
        likedUserVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        likedUserVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        likedUserVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] likedUser in
                self?.execute_onLikeUserResponseData(likedUser!, likedUserIndex)
            })
            .store(in: &cancellable)
    }
    
    func execute_onLikeUserResponseData(_ likedUser: MeetLikedUserModel, _ likedUserIndex: Int) {
        
        if likedUser.response?.data?.isMatch ?? false {
            // Show Gif
            self.gifContainerView.isHidden = false
            self.matchGifImageView.animate(withGIFNamed: "match")
            let name = arrayOfUsers[likedUserIndex].name ?? ""
            self.matchUserNameLabel.text = name
        }
    }
}

// MARK: - Shuffle Delegates
extension MeetHomeVC: SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .up, .right]
        for direction in card.swipeDirections {
            card.setOverlay(SwipeCardOverlay(direction: direction), forDirection: direction)
        }
        let model = arrayOfUsers[index]
        card.content = SwipeCardContentView(withImageURLString: model.profileImg ?? "")
        card.footer = SwipeCardFooterView(withTitle: "\(model.name ?? "")", subtitle: model.location)
        return card
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return arrayOfUsers.count
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        print("Swiped all cards!")
        viewContainerForButtons.isHidden = true
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        if direction == .right {
            likedUserVM = MeetLikedUserViewModel()
            let params: [String: Any] = ["liked_to": arrayOfUsers[index].id!]
            
            likedUserVM?.postLikeUserAsyncCall(parameters: params)
            fetchMeetLikeUserViewModel(index)
        }
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        navigateToViewController(MeetUserDetailVC.self, storyboardName: StoryboardName.meet, animationType: .autoReverse(presenting: .zoom)) {
            vc in
            vc.selectedUserId = self.arrayOfUsers[index].id ?? 0
        }
    }
}
