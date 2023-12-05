//
//  ChatListTV.swift
//  VinderApp
//
//  Created by iOS Dev on 26/10/2023.
//

import UIKit
import TwilioChatClient

protocol ChatListTVDelegate: AnyObject {
    func refresh()
    func checkforChannels()
}

class ChatListTV: UITableView {
    
    var didSelect : ((_ index:Int) -> Void)?
    var channels : [TCHChannel] = []
    var data = [MeetUser]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func configure() {
        setup()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        estimatedRowHeight = 70.0
        rowHeight = UITableView.automaticDimension
        tableFooterView = UIView(frame: .zero)
        self.register(ChatListTableViewCell.nib(), forCellReuseIdentifier: ChatListTableViewCell.identifier)
    }
   
//    func refreshTablewith(tableData : [TCHChannelDescriptor]){
//        channels = tableData
//        reloadData()
//    }
    
    func displayData(data: [MeetUser], channels: [TCHChannel]) {
        self.data = data
        self.channels = channels
        reloadData()
    }
    
    private func chatTableCell(_ indexPath:IndexPath) -> ChatListTableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: ChatListTableViewCell.identifier , for: indexPath) as! ChatListTableViewCell
        cell.labelName.text = data[indexPath.row].name 
        cell.imageUser.sd_setImage(with: URL(string: data[indexPath.row].profileImg ?? "" ), placeholderImage: UIImage(named: "placeholderUser"), options: .allowInvalidSSLCertificates, completed: nil)
       
            let channel = channels[indexPath.row]
            channel.messages?.getLastWithCount(1, completion: { (result, messages) in
                if result.isSuccessful(){
                    if messages?.count ?? 0 > 0 {
                        cell.labelMessage.text = messages?[0].body ?? ""
                        cell.labelTime.text =  DateTodayFormatter().stringFromDate(date: channel.lastMessageDate as NSDate?) ?? ""
                    }else{
                        cell.labelMessage.text = ""
                    }
                }
            })
        
       // cell.labelTime.text = Date()
        return cell
    }
}

extension ChatListTV: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return chatTableCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect!(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


