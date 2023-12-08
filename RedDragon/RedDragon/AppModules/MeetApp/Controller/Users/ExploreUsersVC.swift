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
    @IBOutlet weak var searchBar: UISearchBar!
    var users = [MeetUser]()
    var cancellable = Set<AnyCancellable>()
    private var likedUserVM: MeetLikedUserViewModel?
    var filteredUserArray = [MeetUser]()
    
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
        self.filteredUserArray = users
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
        return filteredUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToViewController(MeetUserDetailVC.self, storyboardName: StoryboardName.meet, animationType: .autoReverse(presenting: .zoom)) {
            vc in
            vc.selectedUserId = self.filteredUserArray[indexPath.row].id ?? 0
        }
    }
}

extension ExploreUsersVC {
    private func tableCell(indexPath:IndexPath) -> MeetUserTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.meetUserTableViewCell, for: indexPath) as! MeetUserTableViewCell
        cell.nameLabel.text = filteredUserArray[indexPath.row].name ?? ""
        cell.locationLabel.text = filteredUserArray[indexPath.row].location ?? ""
        cell.profileImageView.sd_setImage(with: URL(string: filteredUserArray[indexPath.row].profileImg ?? ""), placeholderImage: UIImage(named: "placeholderUser"))
        cell.likeButton.tag = indexPath.row
        cell.dislikeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)
        cell.dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        likedUserVM = MeetLikedUserViewModel()
        let params: [String: Any] = ["liked_to": filteredUserArray[sender.tag].id!]
        
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
            let name = filteredUserArray[likedUserIndex].name ?? ""
            self.matchUserNameLabel.text = name
        }
        self.view.makeToast(SuccessMessage.successfullyLikedUser)
        self.filteredUserArray.remove(at: likedUserIndex)
        self.tableView.deleteRows(at: [IndexPath(row: likedUserIndex, section: 0)], with: .fade)
        self.tableView.reloadData()
    }
    
    @objc func dislikeButtonTapped(sender: UIButton) {
        self.filteredUserArray.remove(at: sender.tag)
        self.tableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
        self.tableView.reloadData()
    }
}

extension ExploreUsersVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredUserArray = self.users
            self.tableView.reloadData()
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
            self.tableView.reloadData()
            
        }
    }
}
