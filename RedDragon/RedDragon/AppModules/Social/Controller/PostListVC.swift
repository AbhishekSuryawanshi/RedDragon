//
//  PostListVC.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit
import Combine
import Toast

protocol PostListVCDelegate: AnyObject {
    func postList(height: CGFloat, count: Int)
}

class PostListVC: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var selectedSegment: socialHeaderSegment = .followed
    var cancellable = Set<AnyCancellable>()
    weak var delegate: PostListVCDelegate?
    var allPostArray: [SocialPost] = []
    var postArray: [SocialPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFunctionality()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func initialSettings() {
        nibInitialization()
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchEnable(notification:)), name: .socialSearch, object: nil)
    }
    
    func loadFunctionality() {
        nibInitialization()
        fetchPostViewModel()
        
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            makeNetworkCall()
        } else {
            ///Refresh for login or logout user
            postArray.removeAll()
            allPostArray.removeAll()
            calculateContentHeight()
            listTableView.reloadData()
        }
    }
    
    @objc func searchEnable(notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            let status = dict["status"] as? Bool ?? false
            let text = dict["text"] as? String ?? ""
            if status {
                postArray = allPostArray
                postArray = postArray.filter({(item: SocialPost) -> Bool in
                    if item.descriptn.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }
                    if item.firstName.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }
                    return false
                })
            } else {
                postArray = allPostArray
            }
            calculateContentHeight()
            listTableView.reloadData()
        }
    }
    
    func nibInitialization() {
        listTableView.register(CellIdentifier.postTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func calculateContentHeight() {
        var height: CGFloat = 0
        for post in self.postArray {
            height = height + SocialPostListVM.shared.heightOfPostCell(model: post)
        }
        self.delegate?.postList(height: height + 150, count: postArray.count)
    }
    
    func deletePost(_index: Int) {
        self.customAlertView_2Actions(title: "", description: StringConstants.deleteAlert.localized) {
            SocialDeleteVM.shared.deletePollOrPost(type: self.postArray[_index].type == "POLL" ? .poll : .post, id: self.postArray[_index].id)
        }
    }
    
    
    
    func shareAction(model: SocialPost, image: UIImage) {
        stopLoader()
        let vc = UIActivityViewController(activityItems: [image, "\n\n\("Dive into this story via the Rampage Sports app.".localized) \n\(model.descriptn) \n\("Stay connected to the latest in football, basketball, tennis, and other sports with us.".localized) \n\n \(URLConstants.appstore)"], applicationActivities: [])
        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = self.listTableView
            popoverController.sourceRect = self.listTableView.bounds
        }
        self.present(vc, animated: true)
    }
    
    // MARK: - Button Actions
    @objc func moreButtonTapped(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        /// RedDragon user id and local app (euro5League for social module) user ids are different
        /// When a user created in RedDragon, same user created as a new user in euro5League api (PitchStories app)
        if let user = UserDefaults.standard.user, user.appDataIDs.euro5LeagueUserId == postArray[sender.tag].userId {// app user
            let action1 = UIAlertAction(title: "Edit Post".localized, style: .default , handler:{ (UIAlertAction) in
                self.navigateToViewController(PostCreateVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom)) { vc in
                    vc.isForEdit = true
                    vc.postModel = self.postArray[sender.tag]
                }
            })
            alert.addAction(action1)
            let action2 = UIAlertAction(title: "Delete Post".localized, style: .default , handler:{ (UIAlertAction) in
                self.deletePost(_index: sender.tag)
            })
            alert.addAction(action2)
        } else {
            let action1 = UIAlertAction(title: "Block User".localized, style: .default , handler:{ (UIAlertAction) in
                self.customAlertView_2Actions(title: "".localized, description: StringConstants.blockAlert.localized) {
                    self.navigateToXIBViewController(ReportUserVC.self, nibName: "ReportUserVC") { vc in
                        vc.reportType = .blockUser
                        vc.userId = self.postArray[sender.tag].userId
                        vc.pushFromSocialModule = true
                    }
                }
            })
            alert.addAction(action1)
            let action2 = UIAlertAction(title: "Report Post".localized, style: .default , handler:{ (UIAlertAction) in
                self.customAlertView_2Actions(title: "".localized, description: StringConstants.reportPostAlert) {
                    self.navigateToXIBViewController(ReportUserVC.self, nibName: "ReportUserVC") { vc in
                        vc.reportType = self.postArray[sender.tag].type == "POST" ? .reportPost : .reportPoll
                        vc.userId = self.postArray[sender.tag].userId
                        vc.postOrPollId = self.postArray[sender.tag].id
                    }
                }
            })
            alert.addAction(action2)
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc func shareButtonTapped(sender: UIButton) {
        startLoader()
        let postModel = postArray[sender.tag]
        var shareImage: UIImage = .appLogo
        
        if postModel.postImages.count > 0 {
            UIImageView().kf.setImage(with: URL(string: postModel.postImages.first ?? "")) { result in
                switch result {
                case .success(let value):
                    shareImage = value.image
                    self.shareAction(model: postModel, image: shareImage)
                case .failure(let error):
                    print("Error Image: \(error)")
                    self.shareAction(model: postModel, image: shareImage)
                }
            }
        } else {
            shareAction(model: postModel, image: shareImage)
        }
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        let model = postArray[sender.tag]
        SocialAddLikeVM.shared.addLikeAsyncCall(dislike: model.liked, postId: model.id)
    }
    
    @objc func commentButtonTapped(sender: UIButton) {
        navigateToViewController(PostDetailVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom)) { vc in
            vc.postModel = self.postArray[sender.tag]
        }
    }
}

// MARK: - API Services
extension PostListVC {
    func makeNetworkCall() {
        if selectedSegment == .followed {
            SocialPostListVM.shared.fetchFollowedPostListAsyncCall()
        } else {
            SocialPostListVM.shared.fetchPostListAsyncCall()
        }
    }
    
    func fetchPostViewModel() {
        ///fetch post and poll list
        SocialPostListVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
            self?.execute_onPostListResponseData(nil)
        }
        //        SocialPostListVM.shared.displayLoader = { [weak self] value in
        //            self?.showLoader(value)
        //        }
        SocialPostListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onPostListResponseData(response)
            })
            .store(in: &cancellable)
        
        /// Update poll
        SocialPollVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        SocialPollVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialPollVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    SocialPostListVM.shared.fetchPostListAsyncCall()
                } else {
                    if let errorResponse = response?.error {
                        self?.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
                    }
                }
            })
            .store(in: &cancellable)
        
        /// Delete poll / post
        SocialDeleteVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        SocialDeleteVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialDeleteVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    SocialPostListVM.shared.fetchPostListAsyncCall()
                } else {
                    if let errorResponse = response?.error {
                        self?.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
                    }
                }
            })
            .store(in: &cancellable)
        
        /// Add Like
        SocialAddLikeVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        SocialAddLikeVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialAddLikeVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    SocialPostListVM.shared.fetchPostListAsyncCall()
                } else {
                    if let errorResponse = response?.error {
                        self?.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
                    }
                }
            })
            .store(in: &cancellable)
    }
    
    func execute_onPostListResponseData(_ response: SocialPostListResponse?) {
        postArray.removeAll()
        allPostArray.removeAll()
        if let dataResponse = response?.response {
            ///Posts and polls comes in separate order, so we have to apply date filter
            postArray = dataResponse.data ?? []
            postArray = postArray.sorted(by: { $0.updatedTime.compare($1.updatedTime) == .orderedDescending })
            if selectedSegment == .recommend {
                postArray = postArray.sorted(by: { $0.interactionsCount > $1.interactionsCount})
            }
            allPostArray = postArray
            var hashTagAttay: [String] = []
            for post in self.postArray {
                let descriptnTextArray = post.descriptn.split(separator: " ")
                for text in descriptnTextArray {
                    if text.contains("#") {
                        hashTagAttay.append(String(text))
                    }
                }
            }
            ///Remove duplicates
            let filteredArray = Array(Set(hashTagAttay))
            let dataDict:[String: Any] = ["data": filteredArray]
            NotificationCenter.default.post(name: .refreshHashTags, object: nil, userInfo: dataDict)
            
            ///set placeholder for tableview
            //        if postArray.count == 0 {
            //            listTableView.setEmptyMessage(UserDefaults.standard.token ?? "" == "" ? StringConstants.postsEmptyLoginAlert : ErrorMessage.dataNotFound)
            //        } else {
            //            listTableView.restore()
            //        }
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
        calculateContentHeight()
        listTableView.reloadData()
    }
}

// MARK: - TableView Delegate
extension PostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postArray.count == 0 {
            tableView.setEmptyMessage(ErrorMessage.postEmptyAlert)
        } else {
            tableView.restore()
        }
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.postTableViewCell, for: indexPath) as! PostTableViewCell
        cell.delegate = self
        cell.configure(_index: indexPath.row, model: postArray[indexPath.row])
        cell.moreButton.addTarget(self, action: #selector(moreButtonTapped(sender:)), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(commentButtonTapped(sender:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(shareButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
}

extension PostListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if postArray[indexPath.row].type != "POLL" {
            navigateToViewController(PostDetailVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom)) { vc in
                vc.postModel = self.postArray[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SocialPostListVM.shared.heightOfPostCell(model: postArray[indexPath.row])
    }
}

// MARK: - Table Cell Delegate
extension PostListVC: PostTableCellDelegate {
    func pollAdded(postModel: SocialPost, answer: Int) {
        var param: [String: Any] = [
            "answer": answer
        ]
        switch answer {
        case 1:
            param.updateValue(postModel.option_1Count + 1, forKey: "option_1_count")
        case 2:
            param.updateValue(postModel.option_2Count + 1, forKey: "option_2_count")
        default:
            param.updateValue(postModel.option_3Count + 1, forKey: "option_3_count")
        }
        SocialPollVM.shared.addEditPollListAsyncCall(isForEdit: true, pollId: postModel.id, parameters: param)
    }
    
    func postImageTapped(url: String) {
        presentViewController(ImageZoomVC.self, storyboardName: StoryboardName.social) { vc in
            vc.imageUrl = url
        }
    }
}
