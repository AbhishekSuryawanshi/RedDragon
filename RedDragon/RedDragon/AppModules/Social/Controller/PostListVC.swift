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
    func postList(height: CGFloat)
}

class PostListVC: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var cancellable = Set<AnyCancellable>()
    weak var delegate: PostListVCDelegate?
    var postArray: [SocialPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let token = UserDefaults.standard.token else {
            listTableView.reloadData()
            return
        }
        loadFunctionality()
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func initialSettings() {
        nibInitialization()
    }
    
    func loadFunctionality() {
        self.view.addSubview(Loader.activityIndicator)
        nibInitialization()
        fetchPostViewModel()
        makeNetworkCall()
    }
    
    func nibInitialization() {
        listTableView.register(CellIdentifier.postTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func calculateContentHeight() {
        var height: CGFloat = 0
        for post in self.postArray {
            height = height + SocialPostListVM.shared.heightOfPostCell(model: post)
        }
        self.delegate?.postList(height: height + 150)
    }
    
    func deletePost(_index: Int) {
//        showAlert2(title: "", message: PSMessages.deleteAlert) {
//            self.startLoader()
//            let model = self.postList[_index]
//            PSPostVM.shared.deletePostOrPoll(type: model.type == "POLL" ? .poll : .post, id: model.id) { status, errorMsg in
//                stopLoader()
//                if status {
//                    self.postList.remove(at: _index)
//                    self.calculateContentHeight()
//                    self.listTableView.reloadData()
//                } else {
//                    PSToast.show(message: errorMsg, view: self.view)
//                }
//                self.listTableView.reloadData()
//            }
//        }
    }
    
    func blockUser(userId: Int) {
//        let param: [String: Any] = [
//            "blocked_user_id": userId,
//            "flag": true
//        ]
//        
//        self.startLoader()
//        PSSettingVM.shared.blockUserOrPost(type: .user, parameters: param) { status, errorMsg in
//            stopLoader()
//            if status{
//                self.getPostList()
//            } else {
//                PSToast.show(message: errorMsg, view: self.view)
//            }
//        }
    }
    
    func shareAction(model: SocialPost, image: UIImage) {
//        let vc = UIActivityViewController(activityItems: [image, "\n\n\("Check out the football detail".localized) \(model.descriptn) \("from".localized) \(Bundle.appName.localized) \n\n \(PSURLs.appstore)"], applicationActivities: [])
//        if let popoverController = vc.popoverPresentationController {
//            popoverController.sourceView = self.listTableView
//            popoverController.sourceRect = self.listTableView.bounds
//        }
//        self.present(vc, animated: true)
    }
    
    // MARK: - Button Actions
    @objc func moreBTNTapped(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let user = UserDefaults.standard.user, user.id == postArray[sender.tag].userId {// app user
            let action1 = UIAlertAction(title: "Edit Post".localized, style: .default , handler:{ (UIAlertAction) in
               // self.showCreatePostVC(model: self.postList[sender.tag], isForEdit: true, leagueId: self.postList[sender.tag].leagueId)
            })
            alert.addAction(action1)
            let action2 = UIAlertAction(title: "Delete Post".localized, style: .default , handler:{ (UIAlertAction) in
                self.deletePost(_index: sender.tag)
            })
            alert.addAction(action2)
        } else {
            let action1 = UIAlertAction(title: "Block User".localized, style: .default , handler:{ (UIAlertAction) in
                self.customAlertView_2Actions(title: "".localized, description: StringConstants.blockAlert.localized) {
                    self.blockUser(userId: self.postArray[sender.tag].userId)
                }
            })
            alert.addAction(action1)
            let action2 = UIAlertAction(title: "Report Post".localized, style: .default , handler:{ (UIAlertAction) in
                self.customAlertView_2Actions(title: "".localized, description: StringConstants.reportPostAlert) {
                    //ToDo
//                    let nextVC = homeStoryboard.instantiateViewController(withIdentifier: "PSReportVC") as! PSReportVC
//                    nextVC.contentId = self.postList[sender.tag].id
//                    nextVC.reportType = self.postList[sender.tag].type == "POLL" ? .poll : .post
//                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            })
            alert.addAction(action2)
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc func shareBTNTapped(sender: UIButton) {
        let postModel = postArray[sender.tag]
        var shareImage = UIImage(named: "appLogo")!
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
    
    @objc func likeBTNTapped(sender: UIButton) {
        let model = postArray[sender.tag]
        SocialLikeCommentVM.shared.addLikeAsyncCall(dislike: model.liked, postId: model.id)
    }
    
    @objc func commentBTNTapped(sender: UIButton) {
//        let nextVC = homeStoryboard.instantiateViewController(withIdentifier: "PSPostDetailVC") as! PSPostDetailVC
//        nextVC.postModel = postList[sender.tag]
//        nextVC.likeView = false
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - API Services
extension PostListVC {
    func makeNetworkCall() {
       SocialPostListVM.shared.fetchPostListAsyncCall()
    }
    
    func fetchPostViewModel() {
        ///fetch post and poll list
        SocialPostListVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialPostListVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialPostListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] postData in
                self?.execute_onResponseData(postData ?? [])
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
                self?.view.makeToast(StringConstants.pollSuccess)
                SocialPostListVM.shared.fetchPostListAsyncCall()

            })
            .store(in: &cancellable)
        
        
        SocialLikeCommentVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialLikeCommentVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        SocialLikeCommentVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                SocialPostListVM.shared.fetchPostListAsyncCall()
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ postData: [SocialPost]) {
        ///Posts and polls comes in separate order, so we have to apply date filter
       // postArray = postData.filter({ $0.type == "POST" })
        postArray = postData
        postArray = postArray.sorted(by: { $0.updatedTime.compare($1.updatedTime) == .orderedDescending })
        calculateContentHeight()
        listTableView.reloadData()
    }
}

// MARK: - TableView Delegate
extension PostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if postArray.count == 0 {
            tableView.setEmptyMessage(UserDefaults.standard.token ?? "" == "" ? StringConstants.postsEmptyLoginAlert : ErrorMessage.dataNotFound)
        } else {
            tableView.restore()
        }
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.postTableViewCell, for: indexPath) as! PostTableViewCell
        cell.delegate = self
        cell.configure(_index: indexPath.row, model: postArray[indexPath.row])
        cell.moreButton.addTarget(self, action: #selector(moreBTNTapped(sender:)), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(likeBTNTapped(sender:)), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(commentBTNTapped(sender:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(shareBTNTapped(sender:)), for: .touchUpInside)
        return cell
    }
}

extension PostListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if postArray[indexPath.row].type != "POLL" {
//            let nextVC = homeStoryboard.instantiateViewController(withIdentifier: "PSPostDetailVC") as! PSPostDetailVC
//            nextVC.postModel = postArray[indexPath.row]
//            self.navigationController?.pushViewController(nextVC, animated: true)
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
       SocialPollVM.shared.addEditPostListAsyncCall(isForEdit: true, pollId: postModel.id, parameters: param)
    }
    
    func postImageTapped(url: String) {
        presentToViewController(ImageZoomVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom)) { vc in
            vc.imageUrl = url
        }
    }
}