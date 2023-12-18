//
//  GossipDetailVC.swift
//  RedDragon
//
//  Created by Qasr01 on 12/12/2023.
//

import UIKit
import Combine

class GossipDetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gossipImageView: UIImageView!
    @IBOutlet weak var contentLabel: ExpandableLabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var noCommentView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var cancellable = Set<AnyCancellable>()
    var commentSectionID = ""
    var gossipModel = Gossip()
    var sportType: SportsType = .football
    var newsSource = "thehindu"
    var allCommentsArray: [Comment] = []
    var commentsArray: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            commentView.isHidden = false
            CommentListVM.shared.getCommentsAsyncCall(sectionId: commentSectionID)
        } else {
            commentView.isHidden = true
        }
    }
    
    func initialSettings() {
        nibInitialization()
        fetchCommentsViewModel()
        fetchGossipViewModel()
        
        if sportType == .eSports {
            ESportsDetailVM.shared.fetchESportsDetailAsyncCall(id: gossipModel.id ?? 0)
        } else {
            let param: [String: Any] = [
                "slug": gossipModel.slug ?? "",
                "source": newsSource,
                "category": sportType.sourceNewsKey
            ]
            GossipVM.shared.fetchNewsDetailAsyncCall(params: param)
        }
    }
    
    func nibInitialization() {
        commentTableView.register(CellIdentifier.commentTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func setView() {
        if let content = gossipModel.content?.attributedHtmlString {
            var lines = content.string.split(whereSeparator: \.isNewline)
            if lines.count > 0 {
                lines.remove(at: 0)
            }
            let headingRemovedString = lines.joined(separator: "\n")
            contentLabel.text = headingRemovedString
        }
        if sportType == .eSports {
            dateLabel.text = gossipModel.eSportDate.formatDate(inputFormat: .mmmdyyyyhma, outputFormat: .ddMMyyyy)
            timeLabel.text = gossipModel.eSportDate.formatDate(inputFormat: .mmmdyyyyhma, outputFormat: .hmma)
        } else {
            dateLabel.text = getGossipDate().formatDate(inputFormat: .mmmmdyyyyhma, outputFormat: .ddMMyyyy)
            timeLabel.text = getGossipDate().formatDate(inputFormat: .mmmmdyyyyhma, outputFormat: .hmma)
        }
        
        titleLabel.text = gossipModel.title
        gossipImageView.setImage(imageStr: gossipModel.mediaSource.last ?? "")
    }
    
    func getGossipDate() -> String {
        let splitArray = gossipModel.content?.components(separatedBy: "class=\"publish-time\"> ")
        let dateStringArray = splitArray?.last?.components(separatedBy: " | Updated")
        return dateStringArray?.first ?? ""
    }
    
    // MARK: - Button Action
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        navigateToViewController(NewsCommentsVC.self, storyboardName: StoryboardName.gossip, animationType: .autoReverse(presenting: .zoom)) { vc in
            vc.sectionId = self.commentSectionID
            vc.newsTitle = self.gossipModel.title ?? ""
            vc.commentsArray = self.allCommentsArray
        }
    }
}
// MARK: - API Services
extension GossipDetailVC {
    
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
                    self?.allCommentsArray = dataResponse.data ?? []
                    self?.commentsArray = Array((dataResponse.data ?? []).prefix(2))
                } else {
                    if let errorResponse = response?.error {
                        self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                    }
                }
                self?.commentTableView.reloadData()
                self?.noCommentView.isHidden = self?.commentsArray.count ?? 0 > 0
            })
            .store(in: &cancellable)
    }
    
    func fetchGossipViewModel() {
        GossipVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        GossipVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.gossipModel.content = response?.data?.content ?? ""
                self?.setView()
            })
            .store(in: &cancellable)
        GossipVM.shared.displayLoader = { [weak self] value in
            value ? self?.startLoader() : stopLoader()
        }
        
        ESportsDetailVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        ESportsDetailVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                let eSportsModel = response?.specificeSportNews.first ?? ESports()
                self?.gossipModel.content = eSportsModel.articalDescription
                self?.gossipModel.eSportDate = eSportsModel.articalPublishedDate
                self?.setView()
            })
            .store(in: &cancellable)
        ESportsDetailVM.shared.displayLoader = { [weak self] value in
            value ? self?.startLoader() : stopLoader()
        }
    }
}

// MARK: - TableView Delegates
extension GossipDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentHeightConstarint.constant = CGFloat(commentsArray.count * 70)
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.commentTableViewCell, for: indexPath) as! CommentTableViewCell
        cell.configureComments(model: commentsArray[indexPath.row], _index: indexPath.row)
        cell.commentLabel.numberOfLines = 1
        cell.deleteButtonHeightConstaint.constant = 0
        return cell
    }
}

extension GossipDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
