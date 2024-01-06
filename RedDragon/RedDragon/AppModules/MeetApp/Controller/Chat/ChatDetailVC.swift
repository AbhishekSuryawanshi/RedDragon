//
//  ChatDetailVC.swift
//  VinderApp
//
//  Created by iOS Dev on 26/10/2023.
//

import UIKit
import SDWebImage
import TwilioChatClient
import Gifu

class ChatDetailVC: UIViewController {
    var channel: TCHChannel?
    var messages:Set<TCHMessage> = Set<TCHMessage>()
    var sortedMessages:[TCHMessage]!
    var receiverImage = String()
    var name = String()
    var viewModel: MeetUserViewModel?
    var selectedUserId = Int()
    var userBlocked: (()-> Void)?
    
    @IBOutlet weak var chatDetailTableView: ChatDetailTV!
   // @IBOutlet var view_TextView: HSExpandableTextView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ImgViewOption: UIImageView!
    @IBOutlet weak var commentTextView: GrowingTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial Setup
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMessages()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func initialSetup() {
//        ImgViewOption.image = UIImage.gif(name: "option")
//        CommonFxns.showAlertWithCompletion(title: AlertMessages.ALERT_CONDUCT, message: AlertMessages.ALERT_CONDUCT_MESSAGE, vc: self) {
//            self.dismiss(animated: true)
//        }
        commentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        nameLbl.text = name.capitalized
   //     CommonFxns.setImage(imageView: profileImgView, urlString: receiverImage, placeHolder: UIImage(named: "smallDefaultUserProfileImg"))
        channel?.delegate = self
        self.chatDetailTableView.channel = channel
    }
   
    // MARK: - Button Actions
    @IBAction func commentSentButtonTapped(_ sender: UIButton) {
        guard !commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        commentTextView.endEditing(true)
        let messageOptions = TCHMessageOptions().withBody(commentTextView.text)
        self.channel?.messages?.sendMessage(with: messageOptions, completion: { (result, Message) in
            self.commentTextView.text = ""
        })
    }
    
    @IBAction func btnBackClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func optionBtnAction(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       
        let unmatchAction = UIAlertAction(title: "Report Profile".localized, style: .default, handler: { (UIAlertAction) in
            self.customAlertView_3Actions(title: "Report Profile".localized, description: "Are you sure you want to report this user?".localized) {
                /// navigate to Report user
                self.navigateToXIBViewController(ReportUserVC.self, nibName: "ReportUserVC") { vc in
                    vc.reportType = .reportUser
                    vc.userId = self.selectedUserId
                }
            } dismissAction: {
                self.navigationController?.popViewController(animated: true)
            }
        })
            optionMenu.addAction(unmatchAction)
       
           let blockAction = UIAlertAction(title: "Block Profile".localized, style: .default, handler: { (UIAlertAction) in
          
               self.customAlertView_3Actions(title: "Block Profile".localized, description: "Are you sure you want to block this user?".localized) {
                   /// navigate to Block user
                   self.navigateToXIBViewController(ReportUserVC.self, nibName: "ReportUserVC") { vc in
                       vc.reportType = .blockUser
                       vc.userId = self.selectedUserId
                   }
               } dismissAction: {
                   self.navigationController?.popViewController(animated: true)
               }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (UIAlertAction) in
            optionMenu.dismiss(animated: true)
        })
        
        optionMenu.addAction(blockAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func loadMessages(){
        messages.removeAll()
        // if channel?.synchronizationStatus == .all {
        channel?.messages?.getLastWithCount(10) { (result, items) in
            if items != nil {
                self.addMessages(newMessages: Set(items!))
            }
        }
    }
   
    func addMessages(newMessages:Set<TCHMessage>) {
        messages = messages.union(newMessages)
        sortMessages()
        DispatchQueue.main.async {
            self.chatDetailTableView!.reloadMessageTablewith(messages: self.sortedMessages)
            if self.messages.count > 0 {
                self.chatDetailTableView!.scrollToBottom()
            }
        }
    }
   
    func sortMessages() {
        sortedMessages = messages.sorted(by: { (a, b) -> Bool in
             (a.dateCreated ?? "") < (b.dateCreated ?? "")
        })
    }
}
