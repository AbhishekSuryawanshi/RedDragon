import UIKit
import TwilioChatClient

class ChannelManager: NSObject {
    static let sharedManager = ChannelManager()
    
    static let defaultChannelUniqueName = "general"
    static let defaultChannelName = "General Channel"
    var channelsList:TCHChannels?
    var channels: [TCHChannel] = []
    var generalChannel:TCHChannel!
    weak var delegate:ChatListTV?
    weak var chatlistdelegate : ChatListTVDelegate?
    
    //    override init() {
    //        super.init()
    //        channels = NSMutableOrderedSet()
    //    }
    
    // MARK: - General channel
    
    func joinGeneralChatRoomWithCompletion(completion: @escaping (Bool) -> Void) {
        
        let uniqueName = ChannelManager.defaultChannelUniqueName
        if let channelsList = self.channelsList {
            channelsList.channel(withSidOrUniqueName: uniqueName) { result, channel in
                self.generalChannel = channel
                
                if self.generalChannel != nil {
                    self.joinGeneralChatRoomWithUniqueName(name: nil, completion: completion)
                } else {
                    self.createGeneralChatRoomWithCompletion { succeeded in
                        if (succeeded) {
                            self.joinGeneralChatRoomWithUniqueName(name: uniqueName, completion: completion)
                            return
                        }
                        completion(false)
                    }
                }
            }
        }
    }
    
    func joinGeneralChatRoomWithUniqueName(name: String?, completion: @escaping (Bool) -> Void) {
        generalChannel.join { result in
            if ((result.isSuccessful()) && name != nil) {
                self.setGeneralChatRoomUniqueNameWithCompletion(completion: completion)
                return
            }
            completion((result.isSuccessful()))
        }
    }
    
    func createGeneralChatRoomWithCompletion(completion: @escaping (Bool) -> Void) {
        let channelName = ChannelManager.defaultChannelName
        let options = [
            TCHChannelOptionFriendlyName: channelName,
            TCHChannelOptionType: TCHChannelType.public.rawValue
            ] as [String : Any]
          channelsList!.createChannel(options: options) { result, channel in
            if (result.isSuccessful()) {
                self.generalChannel = channel
            }
            completion((result.isSuccessful()))
        }
    }
    
    func setGeneralChatRoomUniqueNameWithCompletion(completion:@escaping (Bool) -> Void) {
        generalChannel.setUniqueName(ChannelManager.defaultChannelUniqueName) { result in
            completion((result.isSuccessful()))
        }
    }
    
    // MARK: - Populate channels
    
    func populateChannels() {
      //  self.channels = []
        DispatchQueue.global(qos: .userInitiated).async {
            Thread.sleep(forTimeInterval: 2.0)
            DispatchQueue.main.async {
                self.channels = self.channelsList?.subscribedChannelsSorted(by: .lastMessage, order: .descending) ?? []
                self.chatlistdelegate?.checkforChannels()
            }
        }
        
        //        channelsList?.userChannelDescriptors { result, paginator in
        //            self.channels.append(contentsOf: (paginator?.items())!)
        //            self.sortChannels()
        //        }
    }
    
    func sortChannels() {
        //  let sortSelector = #selector(NSString.localizedCaseInsensitiveCompare(_:))
        //let descriptor = NSSortDescriptor(key: "dateUpdated", ascending: true, selector: sortSelector)
        channels = channels.sorted(by: {$0.dateUpdated!.compare($1.dateUpdated!) == .orderedDescending})
        self.chatlistdelegate?.checkforChannels()
    }
    // MARK: - Create channel
    func createChat(_ isSender: UInt64, _ isReceiver: UInt64) -> String {
        if isSender > isReceiver {
          //  print ("The channel is \("\(isSender)_\(isReceiver)")")
            return "\(isSender)_\(isReceiver)" } else {
         //   print ("The channel is \("\(isReceiver)_\(isSender)")")
            return "\(isReceiver)_\(isSender)" }
    }
    
    func createChannelWithName(name: String, completion: @escaping (Bool, TCHChannel?) -> Void) {
        if (name == ChannelManager.defaultChannelName) {
            completion(false, nil)
            return
        }
        let channelOptions = [
            TCHChannelOptionUniqueName: name,
            TCHChannelOptionType: TCHChannelType.private.rawValue,
            
            ] as [String : Any]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        self.channelsList?.createChannel(options: channelOptions) { result, channel in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion((result.isSuccessful()), channel)
        }
    }
    
    func getChannelwithUnique(name: String, completion: @escaping (Bool, TCHChannel?) -> Void) {
        if (name == ChannelManager.defaultChannelName) {
            completion(false, nil)
            return
        }
        self.channelsList?.channel(withSidOrUniqueName: name, completion: { (result, channel) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion((result.isSuccessful()), channel)
        })
    }
    
    func initialiseChatWith(userID: String, userName: String? = "", userImage: String? = "", fromViewController: UIViewController){
        
        let storyboard = UIStoryboard(name: "Meet", bundle: Bundle.main)
        let chatDetailVC = storyboard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
        let CurrentUserID = 6
        let channelName = ChannelManager.sharedManager.createChat(UInt64(exactly: CurrentUserID)!, UInt64(userID)!)
        
        ChannelManager.sharedManager.createChannelWithName(name: channelName) { (isSucess, channel) in
            if isSucess{
                // print("New Channel")
                chatDetailVC.name = userName ?? "User"
                chatDetailVC.channel = channel
                chatDetailVC.receiverImage = userImage ?? ""
                chatDetailVC.selectedUserId = Int(userID) ?? 0
                
                fromViewController.navigationController?.pushViewController(chatDetailVC, animated: true)
                DispatchQueue.global(qos: .background).async {
                    channel?.members?.add(byIdentity: "\(CurrentUserID)", completion: { (result) in
                        channel?.members?.add(byIdentity: userID, completion: { (result) in
                            
                        })
                    })
                }
            }else{
                ChannelManager.sharedManager.getChannelwithUnique(name: channelName) { (isSucess, channel) in
                    if isSucess{
                        chatDetailVC.name = userName ?? ""
                        chatDetailVC.channel = channel
                        chatDetailVC.receiverImage = userImage ?? ""
                        chatDetailVC.selectedUserId = Int(userID) ?? 0
                        fromViewController.navigationController?.pushViewController(chatDetailVC, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - TwilioChatClientDelegate
extension ChannelManager : TwilioChatClientDelegate {
    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
        DispatchQueue.main.async {
            if !self.channels.isEmpty {
                // self.channels.append(channel)
                //self.sortChannels()
            }
        }
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, updated: TCHChannelUpdate) {
        
    }
    
    func chatClient(_ client: TwilioChatClient, channelDeleted channel: TCHChannel) {
        DispatchQueue.main.async {
            if !self.channels.isEmpty {
                //self.channels.remove(channel)
            }
        }
    }
    
    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
    }
}
