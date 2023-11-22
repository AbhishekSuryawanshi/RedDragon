//
//  PostDetailVC.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit
import Combine

class PostDetailVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var commentTextView: GrowingTextView!
    
    var cancellable = Set<AnyCancellable>()
    var postModel = SocialPost()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshPage()
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
    }
    
    func initialSettings() {
        ///Hide tabbar
        self.tabBarController?.tabBar.isHidden = true
        nibInitialization()
        fetchSocialPostViewModel()
        commentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        SocialLikeCommentListVM.shared.fetchCommentListAsyncCall(postId: postModel.id)
    }
    
    func nibInitialization() {
        listTableView.register(CellIdentifier.postTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func refreshPage() {
        headerLabel.text = "Post".localized
        commentTextView.placeholder = "Add a comment".localized
    }
    
    func shareAction(model: SocialPost, image: UIImage) {
        stopLoader()
        DispatchQueue.main.async {
            let vc = UIActivityViewController(activityItems: [image, "\n\n\("Dive into this story via the RedDragon app".localized) \n\(model.descriptn) \n\("Stay connected to the latest in football, basketball, tennis, and other sports with us. Install it from the App Store to find more news.".localized) \n\n \(URLConstants.appstore)"], applicationActivities: [])
            if let popoverController = vc.popoverPresentationController {
                popoverController.sourceView = self.listTableView
                popoverController.sourceRect = self.listTableView.bounds
            }
            self.present(vc, animated: true)
        }
    }
    
    // MARK: - Button Actions
    @IBAction func commentSentButtonTapped(_ sender: UIButton) {
        guard !commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        commentTextView.endEditing(true)
        let param: [String: Any] = [
            "post_id": postModel.id,
            "txt": commentTextView.text!
        ]
        SocialAddCommentVM.shared.addCommentAsyncCall(parameters: param)
    }
    
    @objc func deleteCommentBTNTapped(sender: UIButton) {
        self.customAlertView_2Actions(title: "".localized, description: StringConstants.deleteAlert.localized) {
            SocialDeleteCommentVM.shared.deleteComment(id: SocialLikeCommentListVM.shared.commentsArray[sender.tag].id)
        }
    }
    
    @objc func shareButtonTapped(sender: UIButton) {
        startLoader()
        var shareImage = UIImage() //ToDo add app logo
        if postModel.postImages.count > 0 {
            UIImageView().kf.setImage(with: URL(string: postModel.postImages.first ?? "")) { result in
                switch result {
                case .success(let value):
                    shareImage = value.image
                    self.shareAction(model: self.postModel, image: shareImage)
                case .failure(let error):
                    print("Error Image: \(error)")
                    self.shareAction(model: self.postModel, image: shareImage)
                }
            }
        } else {
            shareAction(model: postModel, image: shareImage)
        }
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        SocialAddLikeVM.shared.addLikeAsyncCall(dislike: postModel.liked, postId: postModel.id)
    }
}

// MARK: - API Services
extension PostDetailVC {
    func fetchSocialPostViewModel() {
        ///fetch comment list
        SocialLikeCommentListVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialLikeCommentListVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialLikeCommentListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    SocialLikeCommentListVM.shared.commentsArray = dataResponse.data ?? []
                    self?.postModel.commentCount = SocialLikeCommentListVM.shared.commentsArray.count
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
                self?.listTableView.reloadData()
            })
            .store(in: &cancellable)
        
        ///Add comment
        SocialAddCommentVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialAddCommentVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialAddCommentVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    self?.commentTextView.text = ""
                    SocialLikeCommentListVM.shared.fetchCommentListAsyncCall(postId: self?.postModel.id ?? 0)
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
            })
            .store(in: &cancellable)
        
        ///Delete comment
        SocialDeleteCommentVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialDeleteCommentVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialDeleteCommentVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    SocialLikeCommentListVM.shared.fetchCommentListAsyncCall(postId: self?.postModel.id ?? 0)
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
            })
            .store(in: &cancellable)
        
        /// Add Like
        SocialAddLikeVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialAddLikeVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialAddLikeVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    if let status = self?.postModel.liked {
                        ///update like status and likecount in post model
                        self?.postModel.liked = !status
                        self?.postModel.likeCount = status ? (self?.postModel.likeCount ?? 0) - 1 : (self?.postModel.likeCount ?? 0) + 1
                        self?.listTableView.reloadData()
                    }
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
            })
            .store(in: &cancellable)
    }
}

// MARK: - TableView Delegates
extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + SocialLikeCommentListVM.shared.commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.postTableViewCell, for: indexPath) as! PostTableViewCell
            cell.configure(_index: indexPath.row, model: postModel, detailPage: true)
            cell.userNameLabel.tintColor = UIColor.blue3
            cell.commentsLabel.text = SocialLikeCommentListVM.shared.commentsArray.count == 0 ? "" : "Comments".localized
            cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)
            cell.shareButton.addTarget(self, action: #selector(shareButtonTapped(sender:)), for: .touchUpInside)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.socialCommentTableViewCell, for: indexPath) as! SocialCommentTableViewCell
            cell.configure(model: SocialLikeCommentListVM.shared.commentsArray[indexPath.row - 1], _index: indexPath.row - 1)
            cell.deleteButton.addTarget(self, action: #selector(deleteCommentBTNTapped(sender:)), for: .touchUpInside)
            return cell
        }
    }
}

extension PostDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let postContentHeight = SocialPostListVM.shared.heightOfPostCell(model: postModel)
            return postContentHeight + 35
        } else {
            let model = SocialLikeCommentListVM.shared.commentsArray[indexPath.row - 1]
            let height = model.comment.heightOfString2(width: screenWidth - 90, font: fontRegular(13))
            if (UserDefaults.standard.user?.id ?? 0) == model.user.id {
                return height + 75
            } else {
                return height + 53
            }
        }
    }
}
