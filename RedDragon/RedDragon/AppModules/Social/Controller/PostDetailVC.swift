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
    
    var cancellable = Set<AnyCancellable>()
    var postModel = SocialPost()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshForLocalization()
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    }
    
    func initialSettings() {
        self.view.addSubview(Loader.activityIndicator)
        ///Hide tabbar
        self.tabBarController?.tabBar.isHidden = true
        nibInitialization()
        fetchSocialViewModel()
        SocialLikeCommentListVM.shared.fetchCommentListAsyncCall(postId: postModel.id)
    }
    
    func nibInitialization() {
        listTableView.register(CellIdentifier.postTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func refreshForLocalization() {
        headerLabel.text = "Post".localized
    }
}

// MARK: - API Services
extension PostDetailVC {
    func fetchSocialViewModel() {
        ///fetch match list
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
                SocialLikeCommentListVM.shared.commentsArray = response ?? []
                self?.listTableView.reloadData()
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
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.socialCommentTableViewCell, for: indexPath) as! SocialCommentTableViewCell
            cell.configure(model: SocialLikeCommentListVM.shared.commentsArray[indexPath.row - 1], _index: indexPath.row - 1)
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
