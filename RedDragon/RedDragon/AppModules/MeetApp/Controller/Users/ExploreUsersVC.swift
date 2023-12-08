//
//  ExploreUserVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit
import SDWebImage
import Gifu
import Combine

class ExploreUsersVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var matchGifImageView: GIFImageView!
    @IBOutlet weak var matchUserNameLabel: UILabel!
    @IBOutlet weak var gifContainerView: UIView!
    var users = [MeetUser]()
    var cancellable = Set<AnyCancellable>()
    private var likedUserVM: MeetLikedUserViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }

    // MARK: - Methods
    func performInitialSetup() {
        gifContainerView.isHidden = true
        nibInitialization()
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.meetUserTableViewCell)
    }
    
    func configureUsers(users: [MeetUser]) {
        self.users = users
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    // MARK: - Button Actions
    @IBAction func dialogCancelButtonTapped(_ sender: UIButton) {
        matchGifImageView.stopAnimatingGIF()
        gifContainerView.isHidden = true
    }
}

extension ExploreUsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToViewController(MeetUserDetailVC.self, storyboardName: StoryboardName.meet, animationType: .autoReverse(presenting: .zoom)) {
            vc in
            vc.selectedUserId = self.users[indexPath.row].id ?? 0
        }
    }
}

extension ExploreUsersVC {
    private func tableCell(indexPath:IndexPath) -> MeetUserTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.meetUserTableViewCell, for: indexPath) as! MeetUserTableViewCell
        cell.nameLabel.text = users[indexPath.row].name ?? ""
        cell.locationLabel.text = users[indexPath.row].location ?? ""
        cell.profileImageView.sd_setImage(with: URL(string: users[indexPath.row].profileImg ?? ""), placeholderImage: UIImage(named: "placeholderUser"))
        cell.likeButton.tag = indexPath.row
        cell.dislikeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)
        cell.dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        likedUserVM = MeetLikedUserViewModel()
        let params: [String: Any] = ["liked_to": users[sender.tag].id!]
        
        likedUserVM?.postLikeUserAsyncCall(parameters: params)
        fetchMeetLikeUserViewModel(sender.tag)
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
            let name = users[likedUserIndex].name ?? ""
            self.matchUserNameLabel.text = name
        }
        self.view.makeToast(SuccessMessage.successfullyLikedUser)
        self.users.remove(at: likedUserIndex)
        self.tableView.deleteRows(at: [IndexPath(row: likedUserIndex, section: 0)], with: .fade)
        self.tableView.reloadData()
    }
    
    @objc func dislikeButtonTapped(sender: UIButton) {
        self.users.remove(at: sender.tag)
        self.tableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
        self.tableView.reloadData()
    }
}
