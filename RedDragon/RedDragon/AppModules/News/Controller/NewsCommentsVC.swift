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
    
    override func viewWillAppear(_ animated: Bool) {
        refreshPage()
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
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
        listTableView.reloadData()
        //listTableView.setContentOffset(CGPointMake(0, listTableView.contentSize.height - listTableView.frame.size.height), animated: true)
        if commentsArray.count > 0 {
            let indexPosition = IndexPath(row: commentsArray.count - 1, section: 0)
            self.listTableView.scrollToRow(at: indexPosition, at: UITableView.ScrollPosition.bottom, animated: false)
        }
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
            DeleteCommentVM.shared.deleteCommentAsyncCall(id: self.commentsArray[sender.tag].id)
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
                    self?.commentsArray = dataResponse.data?.reversed() ?? []
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
                self?.listTableView.reloadData()
                if self?.commentsArray.count ?? 0 > 0 {
                    let indexPosition = IndexPath(row: (self?.commentsArray.count ?? 1) - 1, section: 0)
                    self?.listTableView.scrollToRow(at: indexPosition, at: UITableView.ScrollPosition.bottom, animated: false)
                }
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
        if commentsArray.count == 0 {
            tableView.setEmptyMessage(ErrorMessage.commentListEmptyAlert)
        } else {
            tableView.restore()
        }
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.commentTableViewCell, for: indexPath) as! CommentTableViewCell
        cell.configureComments(model: commentsArray[indexPath.row], _index: indexPath.row)
        cell.deleteButton.addTarget(self, action: #selector(deleteCommentBTNTapped(sender:)), for: .touchUpInside)
        return cell
    }
}

extension NewsCommentsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = commentsArray[indexPath.row]
        let height = model.comment.heightOfString2(width: screenWidth - 90, font: fontRegular(13))
        if (UserDefaults.standard.user?.id ?? 0) == model.user.id {
            return height + 75
        } else {
            return height + 53
        }
    }
}
