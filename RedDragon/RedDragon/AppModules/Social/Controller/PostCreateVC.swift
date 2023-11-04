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
    var loadMatches = true
    var imageArray: [String] = []
    var leagueId = ""
    var isForEdit = false
    var postModel = SocialPost()
    var pollArray: [Poll] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    func initialSettings() {
        nibInitialization()
        setValue()
        fetchSocialViewModel()
        fetchImageViewModel()
    }
    
    func nibInitialization() {
        imageCollectionView.register(CellIdentifier.singleImageCollectionViewCell)
        pollTableView.register(CellIdentifier.socialPollTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func setValue() {
        self.tabBarController?.tabBar.isHidden = true
        if let user = UserDefaults.standard.user {
            //ToDo
            userImageView.setImage(imageStr: user.image, placeholder: UIImage(named: "person.circle.fill"))
            userNameLabel.text = "\(user.firstName) \(user.lastName)"
        }
        dateLabel.text = Date().formatDate(outputFormat: dateFormat.hhmmaddMMMyyyy)
        setfeedImageCVLayout(collectionview: self.imageCollectionView, imageCount: imageArray.count)
        imageCollectionView.reloadData()
        
        imageBgView.isHidden = true
        matchView.isHidden = true
        pollView.isHidden = true
        
        containerTopConstarint.constant = 0
        headerLabel.text = isForEdit ? "Edit Post".localized : "Create Post".localized
        contentTxtView.placeholder = "What do you want to talk about?".localized
        contentTxtView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentTxtView.delegate = self
        contentTxtView.minHeight = 40
        contentTxtView.maxHeight = 400
        postButton.setTitle(isForEdit ? "Save".localized : "Post".localized, for: .normal)
        pollTextField.placeholder = "Add Choise".localized
        imageButton.setTitle("Image".localized, for: .normal)
        pollButton.setTitle("Poll".localized, for: .normal)
        matchButton.setTitle("Match".localized, for: .normal)
        
        //ToDo
        /*
         questientTxtView.placeholder = "Type here..".localized
         questientTxtView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         eventDesTxtView.setPlaceholder(text: "Type here..".localized)
         eventDesTxtView.checkPlaceholder()
         questienTitleLabel.text = "Your question*".localized
         option1Label.text = "Option 1*".localized
         option2Label.text = "Option 2*".localized
         option1TF.placeholder = "add option".localized
         option2TF.placeholder = "add option".localized
         */
        
        if isForEdit {
            //ToDo
            //dateLabel.text = postModel.updatedTime.formatDate2(inputFormat: .ddMMyyyyWithTimeZone)
            if  postModel.type == "POLL" {
                currentPostType = .poll
                
                //                questientTxtView.text = postModel.question
                //                option1TF.text = postModel.option_1
                //                option2TF.text = postModel.option_2
                contentTxtView.text = postModel.descriptn == "_Test_" ? "" : postModel.descriptn
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
                
                if let content = postModel.contentHtml.attributedHtmlString {
                    contentTxtView.text = content.string
                }
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
                    showNewImageActionSheet()
                } else {
                    self.customAlertView(title: ErrorMessage.photoMaxCountAlert.localized, description: "", image: ImageConstants.alertImage)
                }
            case .poll:
                return
            case .match:
                showMatchList()
            default: //event
                return
            }
        }
    }
    
    func showMatchList() {
        loadMatches = false
        if loadMatches {
            SocialMatchVM.shared.fetchMatchListAsyncCall()
        } else {
            ViewEmbedder.embed(withIdentifier: "PostMatchesVC", storyboard: UIStoryboard(name: StoryboardName.social, bundle: nil)
                               , parent: self, container: self.matchContainerView) { vc in
                let vc = vc as! PostMatchesVC
                vc.delegate = self
            }
            UIView.animate(withDuration: 0.35) {
                self.containerTopConstarint.constant = -460
                self.view.layoutIfNeeded()
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
        leagueImageView.setImage(imageStr: selectedMatch.league.logo, placeholder: UIImage.noLeague)
        matchDateLabel.text = selectedMatch.matchUnixTime.formatDate(outputFormat: dateFormat.hhmmaddMMMyyyy2, today: true)
        homeImageView.setImage(imageStr: selectedMatch.homeTeam.logo, placeholder: UIImage.noTeam)
        awayImageView.setImage(imageStr: selectedMatch.awayTeam.logo, placeholder: UIImage.noTeam)
        homeNameLabel.text = UserDefaults.standard.language == "en" ? selectedMatch.homeTeam.enName : selectedMatch.homeTeam.cnName
        awayNameLabel.text = UserDefaults.standard.language == "en" ? selectedMatch.awayTeam.enName : selectedMatch.awayTeam.cnName
        scoreLabel.text = "\(selectedMatch.homeScores.first ?? 0) - \(selectedMatch.awayScores.first ?? 0)"
    }
    
    func validate() -> Bool {
        //ToDo
        /*
         if currentPostType == .poll {
         if questientTxtView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
         PSToast.show(message: PSMessages.questionEmptyAlert, view: self.view)
         return false
         } else if option1TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
         PSToast.show(message: PSMessages.option1EmptyAlert, view: self.view)
         return false
         } else if option2TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
         PSToast.show(message: PSMessages.option2EmptyAlert, view: self.view)
         return false
         }
         } else {
         if contentTxtView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
         PSToast.show(message: PSMessages.textEmptyAlert, view: self.view)
         return false
         }
         }
         */
        
        return true
    }
    
    // MARK: - Button Actions
    
    @objc func removePollBTNTapped(sender: UIButton) {
        self.customAlertView_2Actions(title: StringConstants.deleteAlert, description: "") {
            self.pollArray.remove(at: sender.tag)
            self.pollTableView.reloadData()
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
    
    func checkPostorPoll(onCompletion:@escaping () -> Void) {
        //Poll data added to a basic post, so type converting to "POLL"
        // delete post and add as a new poll
        //ToDo
        /*
         isForEdit = false
         self.startLoader()
         PSPostVM.shared.deletePostOrPoll(type: .post, id: postModel.id) { status, message in
         
         self.postModel.type = "POLL"
         self.postButtonTapped(UIButton())
         onCompletion()
         }
         */
    }
    
    @IBAction func pollAddButtonTapped(_ sender: UIButton) {
        guard !pollTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        pollTextField.endEditing(true)
        pollArray.append(Poll(title: pollTextField.text!, count: 0))
        pollTextField.text = ""
        pollTableView.reloadData()
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        
        if validate() {
            //ToDo
            /*
             if currentPostType == .poll {
             if postModel.type == "POST" {
             checkPostorPoll(){}
             return
             }
             
             let descriptn = contentTxtView.text! == "" ? "_Test_" : contentTxtView.text!
             let param: [String: Any] = [
             "question": questientTxtView.text!,
             "league_id": leagueId,
             "user_id": String(UserDefaults.standard.user?.id ?? 0),
             "option_1": option1TF.text!,
             "option_2": option2TF.text!,
             "answer": "0",
             "description": descriptn
             ]
             
             self.startLoader()
             PSPostVM.shared.addEditPoll(isForEdit: isForEdit, pollId: postModel.id, parameters: param) { status, message in
             stopLoader()
             if status {
             self.showAlert1(message: self.isForEdit ? PSMessages.postUpdateSuccess : PSMessages.postCreateSuccess) {
             self.navigationController?.popViewController(animated: true)
             }
             } else {
             PSToast.show(message: message, view: self.view)
             }
             }
             } else {
             var param: [String: Any] = [
             "title": "PitchStories", // Ignore title
             "content_html": "<html><body> <p> \(contentTxtView.text!) </p> </body> </html>",
             "is_visible": "1",
             "league_id": leagueId,
             "imgsUrls" : imageArray
             ]
             if currentPostType == .match {
             param.updateValue(selectedMatch.convertToString ?? "", forKey: "match_detail")
             }
             self.startLoader()
             PSPostVM.shared.addEditPost(isForEdit: isForEdit, postId: postModel.id, parameters: param) { status, message in
             stopLoader()
             if status {
             self.showAlert1(message: self.isForEdit ? PSMessages.postUpdateSuccess : PSMessages.postCreateSuccess) {
             self.navigationController?.popViewController(animated: true)
             }
             } else {
             PSToast.show(message: message, view: self.view)
             }
             }
             }
             */
        }
    }
}

// MARK: - API Services
extension PostCreateVC {
    func fetchImageViewModel() {
        PostImageViewModel.shared.$userImage
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.imageArray.append(response ?? "")
                self?.setImageView()
            })
            .store(in: &cancellable)
    }
    
    func fetchSocialViewModel() {
        ///fetch match list
        SocialMatchVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialMatchVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialMatchVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.loadMatches = false
                SocialMatchVM.shared.matchArray = response ?? []
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
        cell.imageImageView.setImage(imageStr: imageArray[indexPath.row],placeholder: UIImage.placeholder)
        cell.imageImageView.cornerRadius = 7
        cell.imageImageView.clipsToBounds = true
        cell.closeButton.tag = indexPath.row
        cell.closeButton.addTarget(self, action: #selector(removeImage(sender:)), for: .touchUpInside)
        return cell
    }
}

extension PostCreateVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentToViewController(ImageZoomVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom)) { vc in
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
            PostImageViewModel.shared.imageAsyncCall(imageName: imageName, imageData: imageData)
        }
    }
    
    func showNewImageActionSheet() {
        let alert = UIAlertController(title: "Upload Image".localized, message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localized, style: .default , handler:{ (UIAlertAction)in
            let imagePicker = ImagePicker(viewController: self)
            imagePicker .delegate = self
            imagePicker .checkCameraAuthorization()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library".localized, style: .default , handler:{ (UIAlertAction)in
            let imagePicker = ImagePicker(viewController: self)
            imagePicker .delegate = self
            imagePicker .checkLibraryAuthorization()
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.imageCollectionView
            popoverController.sourceRect = self.imageCollectionView.bounds
        }
        self.present(alert, animated: true, completion: {})
    }
}

//MARK: - Custom Delegate
extension PostCreateVC: PostMatchesVCDelegate {
    func matchSelected(match: SocialMatch) {
        selectedMatch = match
        setMatchDetail()
        UIView.animate(withDuration: 0.7) {
            self.containerTopConstarint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
