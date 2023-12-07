//
//  UserDetailVC.swift
//  RedDragon
//
//  Created by iOS Dev on 23/11/2023.
//

import UIKit
import SDWebImage
import Combine

class MeetUserDetailVC: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startConversationButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var userVM: MeetUserDetailViewModel?
    var cancellable = Set<AnyCancellable>()
    var selectedUserId = Int()
    var userDetail: MeetUser?
    var sportsInterestArray = [SportsInterest]()
    var isMyMatchUser: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }

    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
        makeNetworkCall()
        fetchMeetUserDetailViewModel()
        startConversationButton.isHidden = isMyMatchUser! ? false : true
    }
    
    func nibInitialization() {
        collectionView.register(CellIdentifier.headerBottom_1CollectionViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func makeNetworkCall() {
        userVM = MeetUserDetailViewModel()
        userVM?.fetchMeetUserDetailAsyncCall(userID: selectedUserId)
    }
    
    // MARK: - Button Actions

    @IBAction func startConversationBtnAction(_ sender: UIButton) {
        let receiverName = userDetail?.name ?? userDetail?.email ?? ""
        let receiverImage = userDetail?.profileImg ?? ""
        let receiverID = userDetail?.id ?? 0
        
        DispatchQueue.main.async {
            ChannelManager.sharedManager.initialiseChatWith(userID: String(receiverID), userName: receiverName, userImage: receiverImage,fromViewController: self)
         }
    }
}

extension MeetUserDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsInterestArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionCell(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = sportsInterestArray[indexPath.row].name?.capitalized ?? ""
        return CGSize(width: title.size(withAttributes: [NSAttributedString.Key.font : fontMedium(15)]).width + 60, height: 40)
    }
}

extension MeetUserDetailVC {
    private func collectionCell(indexPath:IndexPath) -> HeaderBottom_1CollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerBottom_1CollectionViewCell, for: indexPath) as! HeaderBottom_1CollectionViewCell
        let title = sportsInterestArray[indexPath.row].name?.capitalized ?? ""
        let icon = sportsInterestArray[indexPath.row].sportImage?.image ?? ""
        cell.configure(title: title, iconName: icon, selected: true)
        return cell
    }
    
    ///fetch view model for user detail
    func fetchMeetUserDetailViewModel() {
        userVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        userVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        userVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] userDetail in
                self?.execute_onUserDetailResponseData(userDetail!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onUserDetailResponseData(_ userDetail: MeetUserDetailModel) {
        self.userDetail = userDetail.response.data
        nameLabel.text = self.userDetail?.name
        locationLabel.text = self.userDetail?.location
        aboutLabel.text = self.userDetail?.about ?? "Welcome to my profile".localized
        profileImageView.setImage(imageStr: self.userDetail?.profileImg ?? "", placeholder: UIImage(named: "placeholderUser"))
        sportsInterestArray = self.userDetail?.sportsInterest ?? []
        collectionView.reloadData()
    }
}
