//
//  PostCreateVC.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit

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
    @IBOutlet weak var imageBgViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var matchView: UIView!
    @IBOutlet weak var matchBgView: UIView!
    @IBOutlet weak var leagueImgeView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var matchDateLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var awayImageView: UIImageView!
    
    @IBOutlet weak var pollStackView: UIStackView!
    
    
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
    
    var currentPostType: SocialPostType = .none
    var selectedMatch = SocialMatch()
    var loadMatches = true
    var imageArray: [String] = []
    var leagueId = ""
    var isForEdit = false
    var postModel = SocialPost()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    func initialSettings() {
        nibInitialization()
        setValue()
    }
    
    func nibInitialization() {
        imageCollectionView.register(CellIdentifier.singleImageCollectionViewCell)
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
        pollStackView.isHidden = true
        
        
        containerTopConstarint.constant = 0
        headerLabel.text = isForEdit ? "Edit Post".localized : "Create Post".localized
        contentTxtView.placeholder = "What do you want to talk about?".localized
        contentTxtView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentTxtView.minHeight = 40
        contentTxtView.maxHeight = 400
        contentTxtView.minHeight = 80
        contentTxtView.maxHeight = 80
        postButton.setTitle(isForEdit ? "Save".localized : "Post".localized, for: .normal)
        //ToDo
        //        bottomTitleLabel.text = "Select your post".localized
        //        photoLabel.text = "Add photos".localized
        //        pollingLabel.text = "Polling".localized
        //        matchLabel.text = "Match".localized
        //        eventLabel.text = "Event".localized
        //        vsLabel.text = "vs".localized
        
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
        pollStackView.isHidden = currentPostType != .poll
        matchView.isHidden = currentPostType != .match || (selectedMatch.id == "" && currentPostType == .match)
        imageBgViewWidthConstraint.constant = imageArray.count == 0 ? 0 : screenWidth - 40
        
        if btnTap {
            switch currentPostType {
            case .photo:
                if imageArray.count < 5 {
                    showNewImageActionSheet()
                } else {
                    //ToDo
                    //  PSToast.show(message: PSMessages.photoMaxCountAlert, view: self.view)
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
    
    func getMatchList() {
        //ToDo
        /*
         let param: [String: Any] = [
         "leagueId": leagueId,
         "fromDayNum": -5,
         "toDayNum": 5
         ]
         self.startLoader()
         PSHomeVM.shared.getMatchList(parameters: param) { status, errorMsg in
         stopLoader()
         self.loadMatches = false
         self.showMatchList()
         if status {} else {
         PSToast.show(message: errorMsg, view: self.view)
         }
         }
         */
        
    }
    
    func showMatchList() {
        if loadMatches {
            getMatchList()
        } else {
            //ToDo
            /*
             ViewEmbedder.embed(withIdentifier: "PostMatchesVC", storyboard: homeStoryboard
             , parent: self, container: self.matchContainerView) { vc in
             let vc = vc as! PostMatchesVC
             vc.delegate = self
             }
             
             UIView.animate(withDuration: 6) {
             self.containerTopConstarint.constant = -460
             }
             */
            
        }
    }
    
    @objc func removeImage(sender: UIButton) {
        imageArray.remove(at: sender.tag)
        setImageView()
    }
    
    func setImageView() {
        setfeedImageCVLayout(collectionview: self.imageCollectionView, imageCount: self.imageArray.count)
        self.imageBgViewWidthConstraint.constant = screenWidth - 40
        self.imageCollectionView.reloadData()
    }
    
    func setMatchDetail() {
        matchView.isHidden = false
        //ToDo
        /*
         matchDateLabel.text = selectedMatch.matchUnixTime.formatDate(outputFormat: dateFormat.eddmmmyyyy, today: true)
         matchTimeLabel.text = selectedMatch.matchUnixTime.formatDate(outputFormat: dateFormat.hmma)
         homeIconIV.setImage(imageStr: selectedMatch.homeTeam.logo, placeholder: UIImage.noTeam)
         awayIconIV.setImage(imageStr: selectedMatch.awayTeam.logo, placeholder: UIImage.noTeam)
         homeLabel.text = selectedLang == .en ? selectedMatch.homeTeam.enName : selectedMatch.homeTeam.cnName
         awayLabel.text = selectedLang == .en ? selectedMatch.awayTeam.enName : selectedMatch.awayTeam.cnName
         vsLabel.text = "vs".localized
         homeScoreLabel.text = "\(selectedMatch.homeScores.first ?? 0)"
         awayScoreLabel.text = "\(selectedMatch.awayScores.first ?? 0)"
         matchBgView.applyShadow(radius: 3, opacity: 0.5, offset: CGSize(width: 1 , height: 1))
         */
        
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

extension PostCreateVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.singleImageCollectionViewCell, for: indexPath) as! SingleImageCollectionViewCell
        cell.imageImageView.setImage(imageStr: imageArray[indexPath.row])
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

// MARK: - TextView Delegates
extension PostCreateVC: UITextViewDelegate, GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {}
    func textViewDidEndEditing(_ textView: UITextView) {}
}

//MARK: - ImagePicker Delegate
extension PostCreateVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() {}
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        let imageData = image.jpegData(compressionQuality: 0.7) ?? Data()
        //ToDo
        //        PSLoginVM.shared.uploadImage(forProfileImage: false, imageData: imageData, imageName: imageName) { imageStr, status, message  in
        //            self.imageArray.append(imageStr)
        //            self.setImageView()
        //        }
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
        UIView.animate(withDuration: 6) {
            self.containerTopConstarint.constant = 0
        }
    }
}
