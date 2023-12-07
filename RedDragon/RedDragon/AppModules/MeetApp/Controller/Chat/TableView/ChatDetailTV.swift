//
//  ChatDetailTV.swift
//  VinderApp
//
//  Created by iOS Dev on 26/10/2023.
//
import UIKit
import TwilioChatClient

protocol ChatDetailTVDelegate: AnyObject {
    func refresh()
}

class ChatDetailTV: UITableView {
    
    weak var chatTableDelegate: ChatDetailTVDelegate?
    var sortedMessages:[TCHMessage]!
    var channel : TCHChannel?
    var receiverImage = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.transform = CGAffineTransform.init(rotationAngle: -(CGFloat(Double.pi)))
        setup()
        nibInitialization()
    }
    
    func nibInitialization() {
        self.register(CellIdentifier.senderTableViewCell)
        self.register(CellIdentifier.receiverTableViewCell)
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        estimatedRowHeight = 70.0
        rowHeight = UITableView.automaticDimension
        tableFooterView = UIView(frame: .zero)
        //  reloadData()
    }
    
    @objc func refresh(_ control:UIRefreshControl) {
        chatTableDelegate?.refresh()
    }
    
    private func senderCell(indexPath:IndexPath) -> SenderTableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: SenderTableViewCell.identifier , for: indexPath) as! SenderTableViewCell
      
        cell.lblMessage.text = sortedMessages[indexPath.row].body ?? ""
        let date = NSDate.dateWithISO8601String(dateString: sortedMessages[indexPath.row].dateCreated ?? "")
        cell.lblTime.text = DateTodayFormatter().stringFromDate(date: date) ?? ""
        cell.transform = CGAffineTransform.init(rotationAngle: (-CGFloat(Double.pi)))
        return cell
    }
    
    private func receiverCell(indexPath:IndexPath) -> ReceiverTableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: ReceiverTableViewCell.identifier , for: indexPath) as! ReceiverTableViewCell
        
        cell.lblMessage.text = sortedMessages[indexPath.row].body ?? ""
        
        let date = NSDate.dateWithISO8601String(dateString: sortedMessages[indexPath.row].dateCreated ?? "")
        cell.lblTime.text = DateTodayFormatter().stringFromDate(date: date) ?? ""
        cell.transform = CGAffineTransform.init(rotationAngle: (-CGFloat(Double.pi)))
        return cell
    }
    
    func reloadMessageTablewith(messages : [TCHMessage]!){
        if messages.count > 0 && messages != nil {
            sortedMessages = messages.sorted(by: {$0.dateCreatedAsDate?.compare($1.dateCreatedAsDate!) == .orderedDescending})
            reloadData()
        }
    }
    func scrollToBottom() {
        if sortedMessages.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
  
    func loadMoreMessages(){
        if self.sortedMessages.last!.index!  != 0 {
            channel?.messages?.getBefore(UInt(truncating: self.sortedMessages.last!.index!) - 1, withCount: 10, completion: { (result, messages) in
                self.isserviceCallForNexrMessgae = false
                if result.isSuccessful() && messages!.count > 0 {
                    self.sortedMessages.append(contentsOf: (messages?.sorted(by: {$0.dateCreatedAsDate?.compare($1.dateCreatedAsDate!) == .orderedDescending}))!)
                    self.reloadData()
                }
            })
        }
    }
    
    var isserviceCallForNexrMessgae = Bool()
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.sortedMessages != nil {
            if self.sortedMessages.count >= 10 {
                let currentOffset = scrollView.contentOffset.y
                let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
                if maximumOffset - currentOffset <= 10.0 {
                    if !isserviceCallForNexrMessgae{
                        self.isserviceCallForNexrMessgae = true
                        self.loadMoreMessages()
                    }
                }
            }
        }
    }
}

extension ChatDetailTV: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sortedMessages != nil {
            return sortedMessages.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
     //   let userID = Constants.userDefault.string(forKey: UserDefaultKeys.UserId)!
        let userID = "6"
        
        if sortedMessages[indexPath.row].author == userID {
            return senderCell(indexPath: indexPath)
        }else{
            return receiverCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
}

extension ChatDetailVC : TCHChannelDelegate{
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        if !messages.contains(message) {
            addMessages(newMessages: [message])
        }
    }
    func chatClient(_ client: TwilioChatClient,
                    channel: TCHChannel,
                    synchronizationStatusUpdated status: TCHChannelSynchronizationStatus) {
        if status == .all {
            loadMessages()
        }
    }
}


