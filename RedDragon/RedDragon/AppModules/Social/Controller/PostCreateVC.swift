//
//  PostCreateVC.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit
import Combine

class PostCreateVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentTxtView: GrowingTextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var pollButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var matchButton: UIButton!
    @IBOutlet weak var containerTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var matchContainerView: UIView!
    
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var matchView: UIView!
    @IBOutlet weak var matchBgView: UIView!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var matchDateLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var awayImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayNameLabel: UILabel!
    
    @IBOutlet weak var pollView: UIView!
    @IBOutlet weak var pollTextField: UITextField!
    @IBOutlet weak var pollTableView: UITableView!
    @IBOutlet weak var pollTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pollFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pollAddButtonHeightConstraint: NSLayoutConstraint!
    
    enum SocialPostType {
        case none
        case photo
        case match
        case poll
    }
    
    /// none - Initial stage, Post contains text, type = "POST"
    /// photo - Post contains text, images (maximum 5), type = "POST"
    /// match - Post contains text, match details in "matchDetail", type = "POST"
    /// poll - Post contains text and poll details, type = "POLL"
    
    var cancellable = Set<AnyCancellable>()
    var currentPostType: SocialPostType = .none
    var selectedMatch = SocialMatch()
    var imageArray: [String] = []
    var isForEdit = false
    var postModel = SocialPost()
    var pollArray: [Poll] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    func initialSettings() {
        ///Hide tabbar
        self.tabBarController?.tabBar.isHidden = true
        nibInitialization()
        setValue()
        fetchImageViewModel()
        fetchPostViewModel()
    }
    
    func nibInitialization() {
        imageCollectionView.register(CellIdentifier.singleImageCollectionViewCell)
        pollTableView.register(CellIdentifier.socialPollTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func setValue() {
        
        if let user = UserDefaults.standard.user {
            userImageView.setImage(imageStr: user.profileImg, placeholder: .placeholderUser)
            userNameLabel.text = user.name
        }
        dateLabel.text = Date().formatDate(outputFormat: dateFormat.hhmmaddMMMyyyy)
        setfeedImageCVLayout(collectionview: self.imageCollectionView, imageCount: imageArray.count)
        imageCollectionView.reloadData()
        
        imageBgView.isHidden = true
        matchView.isHidden = true
        pollView.isHidden = true
        
        containerTopConstarint.constant = 0
        headerLabel.text = isForEdit ? "Edit Post".localized : "Create Post".localized
        contentTxtView.placeholder = ErrorMessage.textEmptyAlert.localized
        contentTxtView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentTxtView.delegate = self
        contentTxtView.minHeight = 60
        contentTxtView.maxHeight = 400
        postButton.setTitle(isForEdit ? "Save".localized : "Post".localized, for: .normal)
        pollTextField.placeholder = "Add Choice".localized
        imageButton.setTitle("Image".localized, for: .normal)
        pollButton.setTitle("Poll".localized, for: .normal)
        matchButton.setTitle("Match".localized, for: .normal)
        pollFieldHeightConstraint.constant = 37
        pollAddButtonHeightConstraint.constant = 47
        
        if isForEdit {
            dateLabel.text = postModel.updatedTime.formatDate2(inputFormat: .ddMMyyyyWithTimeZone)
            if  postModel.type == "POLL" {
                currentPostType = .poll
                contentTxtView.text = postModel.question
                pollArray = postModel.pollArray
                setPollView()
            } else {
                if postModel.matchDetail != "" { // POST Match
                    currentPostType = .match
                    selectedMatch = postModel.matchModel
                    setMatchDetail()
                } else if postModel.postImages.count > 0 { // POST Image
                    currentPostType = .photo
                    imageArray = postModel.postImages
                    setfeedImageCVLayout(collectionview: self.imageCollectionView, imageCount: imageArray.count)
                    imageCollectionView.reloadData()
                } else {
                    currentPostType = .none // POST basic...can convert to any post type
                }
                contentTxtView.text = postModel.descriptn
            }
            setPostTypeView(btnTap: false)
        }
    }
    
    func setPostTypeView(btnTap:Bool = true) {
        
        imageButton.alpha = (currentPostType == .photo || currentPostType == .none) ? 1.0 : 0.5
        pollButton.alpha = (currentPostType == .poll || currentPostType == .none) ? 1.0 : 0.5
        matchButton.alpha = (currentPostType == .match || currentPostType == .none) ? 1.0 : 0.5
        
        imageButton.isEnabled = (currentPostType == .photo || currentPostType == .none) ? true : false
        pollButton.isEnabled = (currentPostType == .poll || currentPostType == .none) ? true : false
        matchButton.isEnabled = (currentPostType == .match || currentPostType == .none) ? true : false
        
        imageBgView.isHidden = currentPostType != .photo
        pollView.isHidden = currentPostType != .poll
        matchView.isHidden = currentPostType != .match || (selectedMatch.id == "" && currentPostType == .match)
        // imageViewWidthConstraint.constant = imageArray.count == 0 ? 0 : screenWidth - 40
        imageBgView.isHidden = imageArray.count == 0
        if btnTap {
            switch currentPostType {
            case .photo:
                if imageArray.count < 5 {
                    showNewImageActionSheet(sourceView: imageCollectionView)
                } else {
                    self.customAlertView(title: ErrorMessage.photoMaxCountAlert.localized, description: "", image: ImageConstants.alertImage)
                }
            case .poll:
                return
            case .match:
                ViewEmbedder.embed(withIdentifier: "PostMatchesVC", storyboard: UIStoryboard(name: StoryboardName.social, bundle: nil)
                                   , parent: self, container: self.matchContainerView) { vc in
                    let vc = vc as! PostMatchesVC
                    vc.delegate = self
                }
                UIView.transition(with: matchContainerView, duration: 0.5, options: .curveEaseIn) {
                    self.containerTopConstarint.constant = -460
                    self.view.layoutIfNeeded()
                }
            default:
                return
            }
        }
    }
    
    @objc func removeImage(sender: UIButton) {
        imageArray.remove(at: sender.tag)
        setImageView()
    }
    
    func setImageView() {
        setfeedImageCVLayout(collectionview: self.imageCollectionView, imageCount: self.imageArray.count)
        imageBgView.isHidden = imageArray.count == 0
        imageCollectionView.reloadData()
    }
    
    func setMatchDetail() {
        matchView.isHidden = false
        leagueLabel.text = selectedMatch.league.name
        leagueImageView.setImage(imageStr: selectedMatch.league.logo, placeholder: .placeholderLeague)
        matchDateLabel.text = selectedMatch.matchUnixTime.formatDate(outputFormat: dateFormat.hhmmaddMMMyyyy2, today: true)
        homeImageView.setImage(imageStr: selectedMatch.homeTeam.logo, placeholder: .placeholderTeam)
        awayImageView.setImage(imageStr: selectedMatch.awayTeam.logo, placeholder: .placeholderTeam)
        homeNameLabel.text = UserDefaults.standard.language == "en" ? selectedMatch.homeTeam.enName : selectedMatch.homeTeam.cnName
        awayNameLabel.text = UserDefaults.standard.language == "en" ? selectedMatch.awayTeam.enName : selectedMatch.awayTeam.cnName
        scoreLabel.text = "\(selectedMatch.homeScores.first ?? 0) - \(selectedMatch.awayScores.first ?? 0)"
    }
    
    func validate() -> Bool {
        if contentTxtView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.textEmptyAlert)
            return false
        }
        if currentPostType == .poll {
            if pollArray.count < 2 {
                self.view.makeToast(ErrorMessage.pollOptionEmptyAlert)
                return false
            }
        } else {
            
        }
        return true
    }
    
    func checkPostorPoll(onCompletion:@escaping () -> Void) {
        /// Poll data added to a basic post, so type converting from "POST" to "POLL"
        /// delete post and add as a new poll
        
        isForEdit = false
        SocialDeleteVM.shared.deletePollOrPost(type: .post, id: postModel.id)
    }
    
    func setPollView() {
        pollTableView.reloadData()
        pollFieldHeightConstraint.constant = pollArray.count < 2 ? 37 : 0
        pollAddButtonHeightConstraint.constant = pollArray.count < 2 ? 47 : 0
    }
    
    // MARK: - Button Actions
    
    @objc func removePollBTNTapped(sender: UIButton) {
        self.customAlertView_2Actions(title: StringConstants.deleteAlert, description: "") {
            self.pollArray.remove(at: sender.tag)
            self.setPollView()
        }
    }
    
    @IBAction func postTypeButtonTapped(_ sender: UIButton) {
        
        if currentPostType == .none {
            switch sender.tag {
            case 1:
                currentPostType = .photo
            case 2:
                currentPostType = .poll
            case 3:
                currentPostType = .match
            default:
                currentPostType = .none
            }
            setPostTypeView()
        } else {
            if (sender.tag == 1 && currentPostType == .photo) || (sender.tag == 2 && currentPostType == .poll) || (sender.tag == 3 && currentPostType == .match) {
                setPostTypeView()
            } else {
                return
            }
        }
    }
    
    @IBAction func pollAddButtonTapped(_ sender: UIButton) {
        guard !pollTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        pollTextField.endEditing(true)
        pollArray.append(Poll(title: pollTextField.text!, count: 0))
        pollTextField.text = ""
        setPollView()
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        
        if validate() {
            
            if currentPostType == .poll {
                if postModel.type == "POST" {
                    checkPostorPoll(){}
                    return
                }
                let param: [String: Any] = [
                    "question": contentTxtView.text!,
                    "league_id": SocialLeagueVM.shared.leagueArray.first?.id ?? "4zp5rzghp5q82w1",
                    "user_id": String(UserDefaults.standard.user?.appDataIDs.euro5LeagueUserId ?? 0), ///Pass user id of euroleague
                    "option_1": pollArray[0].title,
                    "option_2": pollArray[1].title,
                    "answer": "0",
                    "description": "_Test_"
                ]
                /// "description" key not required, default key is adding because its a required field in backend
                
                SocialPollVM.shared.addEditPollListAsyncCall(isForEdit: isForEdit, pollId: postModel.id, parameters: param)
            } else {
                var param: [String: Any] = [
                    "title": "PitchStories", // Ignore title
                    "content_html": "<html><body> <p> \(contentTxtView.text!) </p> </body> </html>",
                    "is_visible": "1",
                    "league_id": postModel.leagueId,
                    "imgsUrls" : imageArray
                ]
                if currentPostType == .match {
                    param.updateValue(selectedMatch.convertToString ?? "", forKey: "match_detail")
                }
                SocialPostVM.shared.addEditPostListAsyncCall(isForEdit: isForEdit, postId: postModel.id, parameters: param)
            }
        }
    }
}

// MARK: - API Services
extension PostCreateVC {
    func fetchImageViewModel() {
        SocialPostImageVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    let postImage = URLConstants.euro5leagueBaseURL + (dataResponse.data?.imageUrl ?? "")
                    self?.imageArray.append(postImage)
                    self?.setImageView()
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
            })
            .store(in: &cancellable)
    }
    
    func fetchPostViewModel() {
        
        /// Add / Edit post
        SocialPostVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialPostVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialPostVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    self?.view.makeToast(self?.isForEdit ?? true ? StringConstants.postUpdateSuccess : StringConstants.postCreateSuccess)
                    
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
            })
            .store(in: &cancellable)
        
        /// Add / Edit poll
        SocialPollVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialPollVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialPollVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    self?.view.makeToast(self?.isForEdit ?? true ? StringConstants.pollUpdateSuccess : StringConstants.pollCreateSuccess)
                    
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
            })
            .store(in: &cancellable)
        
        /// Delete post
        SocialDeleteVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialDeleteVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialDeleteVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    self?.postModel.type = "POLL"
                    self?.postButtonTapped(UIButton())
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
            })
            .store(in: &cancellable)
    }
}

extension PostCreateVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.singleImageCollectionViewCell, for: indexPath) as! SingleImageCollectionViewCell
        cell.imageImageView.setImage(imageStr: imageArray[indexPath.row],placeholder: .placeholderPost)
        cell.imageImageView.cornerRadius = 7
        cell.imageImageView.clipsToBounds = true
        cell.closeButton.tag = indexPath.row
        cell.closeButton.addTarget(self, action: #selector(removeImage(sender:)), for: .touchUpInside)
        return cell
    }
}

extension PostCreateVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentOverViewController(ImageZoomVC.self, storyboardName: StoryboardName.social) { vc in
            vc.imageUrl = self.imageArray[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
        return cellSize
    }
}


// MARK: - TableView Delegates
extension PostCreateVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pollTableHeightConstraint.constant = CGFloat((pollArray.count * 46))
        return pollArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.socialPollTableViewCell, for: indexPath) as! SocialPollTableViewCell
        cell.configure(type: .createPost, poll: pollArray[indexPath.row])
        cell.closeButton.tag = indexPath.row
        cell.closeButton.addTarget(self, action: #selector(removePollBTNTapped(sender:)), for: .touchUpInside)
        return cell
    }
}

extension PostCreateVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}

// MARK: - TextView Delegates
extension PostCreateVC: GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {}
    func textViewDidEndEditing(_ textView: UITextView) {}
}

//MARK: - ImagePicker Delegate
extension PostCreateVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() {}
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            // Pass the image data and image name to your view model for uploading
            SocialPostImageVM.shared.uploadImageAsyncCall(imageName: imageName, imageData: imageData)
        }
    }
}

//MARK: - Custom Delegate
extension PostCreateVC: PostMatchesVCDelegate {
    func matchSelected(match: SocialMatch, matchSelected: Bool) {
        if matchSelected {
            selectedMatch = match
            setMatchDetail()
        }
        UIView.animate(withDuration: 0.7) {
            self.containerTopConstarint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
