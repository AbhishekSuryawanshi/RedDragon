//
//  NewsCommentsVC.swift
//  RedDragon
//
//  Created by Qasr01 on 13/12/2023.
//

import UIKit
import Combine

class NewsCommentsVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var commentTextView: GrowingTextView!
    
    var cancellable = Set<AnyCancellable>()
    var commentsArray: [Comment] = []
    var newsTitle = ""
    var sectionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
initialSettings()
    }

    func initialSettings() {
        nibInitialization()
        fetchCommentsViewModel()
        commentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func nibInitialization() {
        listTableView.register(CellIdentifier.commentTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func refreshPage() {
        headerLabel.text = "Comments" + " - \(newsTitle)"
        commentTextView.placeholder = "Add a comment".localized
    }
    
    // MARK: - Button Actions
    @IBAction func commentSentButtonTapped(_ sender: UIButton) {
        guard !commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        commentTextView.endEditing(true)
        let param: [String: Any] = [
            "comment_section_id": sectionId,
            "comment": commentTextView.text!
        ]
        AddCommentVM.shared.addCommentAsyncCall(parameters: param)
    }
    
    @objc func deleteCommentBTNTapped(sender: UIButton) {
        self.customAlertView_2Actions(title: "".localized, description: StringConstants.deleteAlert.localized) {
            SocialDeleteCommentVM.shared.deleteComment(id: SocialLikeCommentListVM.shared.commentsArray[sender.tag].id)
        }
    }
    
}

// MARK: - API Services
extension NewsCommentsVC {
    func fetchCommentsViewModel() {
        ///fetch comment list
        CommentListVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        CommentListVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        CommentListVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    self?.commentsArray = dataResponse.data ?? []
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
                self?.listTableView.reloadData()
            })
            .store(in: &cancellable)
        
        ///Add comment
        AddCommentVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        AddCommentVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        AddCommentVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    self?.commentTextView.text = ""
                    CommentListVM.shared.getCommentsAsyncCall(sectionId: self?.sectionId ?? "")
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
            })
            .store(in: &cancellable)
        
        ///Delete comment
        DeleteCommentVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        DeleteCommentVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        DeleteCommentVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let dataResponse = response?.response {
                    CommentListVM.shared.getCommentsAsyncCall(sectionId: self?.sectionId ?? "")
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
extension NewsCommentsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.commentTableViewCell, for: indexPath) as! CommentTableViewCell
        cell.configureComments(model: commentsArray[indexPath.row], _index: indexPath.row - 1)
        cell.deleteButton.addTarget(self, action: #selector(deleteCommentBTNTapped(sender:)), for: .touchUpInside)
        return cell
    }
}

extension NewsCommentsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = SocialLikeCommentListVM.shared.commentsArray[indexPath.row]
        let height = model.comment.heightOfString2(width: screenWidth - 90, font: fontRegular(13))
        if (UserDefaults.standard.user?.id ?? 0) == model.user.id {
            return height + 75
        } else {
            return height + 53
        }
    }
}
