//
//  PostListVC.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit

protocol PostListVCDelegate: AnyObject {
    func postList(height: CGFloat)
}

class PostListVC: UIViewController {
    
    @IBOutlet weak var headerLBL: UILabel!
    @IBOutlet weak var listTV: UITableView!
    
    weak var delegate: PostListVCDelegate?
    var postList: [SocialPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshForLocalization()
        guard let token = UserDefaults.standard.token else {
            listTV.reloadData()
            return
        }
        getPostList()
    }
    
    override func viewDidLayoutSubviews() {
        listTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func initialSettings() {
        nibInitialization()
    }
    
    func refreshForLocalization() {
        headerLBL.text = "Recent Post & Analysis".localized
    }
    
    func nibInitialization() {
        listTV.register(CellIdentifier.postTableViewCell)
    }
    
    func getPostList() {
//        self.startLoader()
//        PSPostVM.shared.getPostList { posts, status, errorMsg in
//            stopLoader()
//            if status {
//                self.postList = posts
//                self.calculateContentHeight()
//            } else {
//                PSToast.show(message: errorMsg, view: self.view)
//            }
//            self.listTV.reloadData()
//        }
    }
    
    func calculateContentHeight() {
        var height: CGFloat = 0
        for post in self.postList {
            height = height + 50 //PSPostVM.shared.heightOfPostCell(model: post)
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
//                    self.listTV.reloadData()
//                } else {
//                    PSToast.show(message: errorMsg, view: self.view)
//                }
//                self.listTV.reloadData()
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
//            popoverController.sourceView = self.listTV
//            popoverController.sourceRect = self.listTV.bounds
//        }
//        self.present(vc, animated: true)
    }
    
    // MARK: - Button Actions
    @objc func moreBTNTapped(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let user = UserDefaults.standard.user, user.id == postList[sender.tag].userId {// app user
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
                    self.blockUser(userId: self.postList[sender.tag].userId)
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
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel , handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: {
           
        })
    }
    
    @objc func shareBTNTapped(sender: UIButton) {
        let postModel = postList[sender.tag]
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
//        self.startLoader()
//        let model = self.postList[sender.tag]
//        PSPostVM.shared.addLike(dislike: model.liked, postId: model.id) { status, errorMsg in
//            stopLoader()
//            if status {
//                self.postList[sender.tag].liked = !model.liked
//                let cellNmber = IndexPath(row: sender.tag, section: 0)
//                self.listTV.reloadRows(at: [cellNmber], with: .automatic)
//            } else {
//                PSToast.show(message: errorMsg, view: self.view)
//            }
//            self.listTV.reloadData()
//        }
    }
    
    @objc func commentBTNTapped(sender: UIButton) {
//        let nextVC = homeStoryboard.instantiateViewController(withIdentifier: "PSPostDetailVC") as! PSPostDetailVC
//        nextVC.postModel = postList[sender.tag]
//        nextVC.likeView = false
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func pollOptionBTNTapped(sender: UIButton) {
        let postModel = postList[sender.tag]
        var param: [String: Any] = [
            "answer": String(sender.titleLabel?.tag ?? 0)
        ]
        switch sender.titleLabel?.tag {
        case 1:
            param.updateValue(postModel.option_1Count + 1, forKey: "option_1_count")
        case 2:
            param.updateValue(postModel.option_2Count + 1, forKey: "option_2_count")
        default:
            param.updateValue(postModel.option_3Count + 1, forKey: "option_3_count")
        }
//        self.startLoader()
//        PSPostVM.shared.addEditPoll(isForEdit: true, pollId: postModel.id, parameters: param) { status, message in
//            stopLoader()
//            if status {
//                PSToast.show(message: PSMessages.pollSuccess, view: self.view)
//                self.getPostList()
//            } else {
//                PSToast.show(message: message, view: self.view)
//            }
//        }
    }
}

// MARK: - TableView Delegate
extension PostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if postList.count == 0 {
            tableView.setEmptyMessage(UserDefaults.standard.token ?? "" == "" ? StringConstants.postsEmptyLoginAlert : ErrorMessage.dataNotFound)
        } else {
            tableView.restore()
        }
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.postTableViewCell, for: indexPath) as! PostTableViewCell
        cell.delegate = self
        cell.configure(_index: indexPath.row, model: postList[indexPath.row])
        cell.moreButton.addTarget(self, action: #selector(moreBTNTapped(sender:)), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(likeBTNTapped(sender:)), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(commentBTNTapped(sender:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(shareBTNTapped(sender:)), for: .touchUpInside)
      //  cell.optionBTN_1.addTarget(self, action: #selector(pollOptionBTNTapped(sender:)), for: .touchUpInside)
      //  cell.optionBTN_2.addTarget(self, action: #selector(pollOptionBTNTapped(sender:)), for: .touchUpInside)
       // cell.optionBTN_3.addTarget(self, action: #selector(pollOptionBTNTapped(sender:)), for: .touchUpInside)
        return cell
    }
}

extension PostListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if postList[indexPath.row].type != "POLL" {
//            let nextVC = homeStoryboard.instantiateViewController(withIdentifier: "PSPostDetailVC") as! PSPostDetailVC
//            nextVC.postModel = postList[indexPath.row]
//            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50//PSPostVM.shared.heightOfPostCell(model: postList[indexPath.row])
    }
}

// MARK: - Table Cell Delegate
extension PostListVC: PostTableCellDelegate {
    func postImageTapped(url: String) {
        presentToViewController(ImageZoomVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom)) { vc in
            vc.imageUrl = url
        }
    }
}
