import UIKit
import TwilioChatClient
// import TwilioAccessManager

class MessagingManager: NSObject {
    
    static let _sharedManager = MessagingManager()
    
    var client:TwilioChatClient?
    var delegate:ChannelManager?
    var connected = false
    var authorizationToken : String!
    var userID: String!
   
    override init() {
        super.init()
        delegate = ChannelManager.sharedManager
    }
    class func sharedManager() -> MessagingManager {
        return _sharedManager
    }
    func presentViewControllerByName(viewController: String) {
        presentViewController(controller: storyBoardWithName(name: "Main").instantiateViewController(withIdentifier: viewController))
    }
    func presentLaunchScreen() {
        presentViewController(controller: storyBoardWithName(name: "LaunchScreen").instantiateInitialViewController()!)
    }
    func presentViewController(controller: UIViewController) {
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = controller
    }
    func storyBoardWithName(name:String) -> UIStoryboard {
        return UIStoryboard(name:name, bundle: Bundle.main)
    }
    // MARK: User and session management
    func loginWith(identity: String,
                   completion: @escaping (Bool, NSError?) -> Void) {
        connectClientWith(identity: identity, completion: completion)
    }
    
    // MARK: Twilio Client
    func loadGeneralChatRoomWithCompletion(completion:@escaping (Bool, NSError?) -> Void) {
        ChannelManager.sharedManager.joinGeneralChatRoomWithCompletion { succeeded in
            if succeeded {
                completion(succeeded, nil)
            }
            else {
                let error = self.errorWithDescription(description: "Could not join General channel", code: 300)
                completion(succeeded, error)
            }
        }
    }
    
    func connectClientWith(identity: String,completion: @escaping (Bool, NSError?) -> Void) {
        request(identity: identity, completion: { succeeded, token in
            if let token = token, succeeded {
                self.initializeClientWithToken(token: token)
                completion(succeeded, nil)
            }
            else {
                let error = self.errorWithDescription(description: "Could not get access token", code:301)
                completion(succeeded, error)
            }
        })
    }
    
    func initializeClientWithToken(token: String) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self) { [weak self] result, chatClient in
            guard (result.isSuccessful()) else { return }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self?.connected = true
            self?.client = chatClient!
          //  print(chatClient?.user?.identity! ?? "")
        }
    }
    
    func request(identity: String, completion:@escaping (Bool, String?) -> Void) {
        TokenRequestHandler.fetchToken(identity: identity) {response,error in
            if error?.localizedDescription == nil{
                
                if let tokenData = response as? [String: String] {
                    let token = tokenData["token"]
                    let identity = tokenData["identity"]
                    completion(token != nil, token!)
                }
            }
        }
    }
    
    func errorWithDescription(description: String, code: Int) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey : description]
        return NSError(domain: "app", code: code, userInfo: userInfo)
    }
}

// MARK: - TwilioChatClientDelegate
extension MessagingManager : TwilioChatClientDelegate {
    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
        self.delegate?.chatClient(client, channelAdded: channel)
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, updated: TCHChannelUpdate) {
        self.delegate?.chatClient(client, channel: channel, updated: updated)
    }
    
    func chatClient(_ client: TwilioChatClient, channelDeleted channel: TCHChannel) {
        self.delegate?.chatClient(client, channelDeleted: channel)
    }
    
    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        if status == TCHClientSynchronizationStatus.completed {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            ChannelManager.sharedManager.channelsList = client.channelsList()
        }
        self.delegate?.chatClient(client, synchronizationStatusUpdated: status)
    }
}

//// MARK: - TwilioAccessManagerDelegate
//extension MessagingManager : TwilioAccessManagerDelegate {
//    func accessManagerTokenWillExpire(_ accessManager: TwilioAccessManager) {
//        request(identity: userID, completion: { succeeded, token in
//            if (succeeded) {
//                accessManager.updateToken(token!)
//            }
//            else {
//                // print("Error while trying to get new access token")
//            }
//        })
//    }
//    
//    func accessManager(_ accessManager: TwilioAccessManager!, error: Error!) {
//        // print("Access manager error: \(error.localizedDescription)")
//    }
//}
//
