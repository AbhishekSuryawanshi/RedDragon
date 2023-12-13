//
//  StreetEventDetailsViewController.swift
//  RedDragon
//
//  Created by Remya on 12/12/23.
//

import UIKit
import Combine

class StreetEventDetailsViewController: UIViewController {

    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var tableStack: UIStackView!
    @IBOutlet weak var lblTotalRequests: UILabel!
    @IBOutlet weak var tableViewPositions: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var viewTeam: UIView!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var imageViewTeam: UIImageView!
    @IBOutlet weak var lblTeamLocation: UILabel!
    @IBOutlet weak var teamStack: UIStackView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var matchDateStack: UIStackView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var fixedSearchingFor: UILabel!
    @IBOutlet weak var fixedMatchDate: UILabel!
    @IBOutlet weak var fixedPostOwner: UILabel!
    @IBOutlet weak var fixedTeamInfo: UILabel!
    
    
    var details:StreetEvent?
    var feedType:FeedsType?
    var tableViewPlayersObserver: NSKeyValueObservation?
    var sendEventRequestsViewModel:SendEventRequestsViewModel?
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initialSettings()
    }
    
    
    
    @IBAction func actionProfile(_ sender: Any) {
//        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//        vc.isOtherPlayer = true
//        vc.userID = details?.creatorUserId
//        vc.playerID = details?.creatorUserId
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func actionSeeAll(_ sender: UIButton) {
        
    }
    
   
    @IBAction func actionRespond(_ sender: UIButton) {
//        if !Utility.isUserLoggedIn(){
//            Utility.showErrorSnackView(message: "Please login first to continue".localized)
//            return
//        }
//        if AppPreferences.getUserData()?.id == details?.creatorUserId{
//            viewAllRequests()
//        }
//        else{
//            prepareEventRequest()
//        }
        
    }
    
    @IBAction func actionViewTeamDetails(_ sender: Any) {
        navigateToViewController(StreetTeamDetailsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.teamID = self.details?.teamID
        }
    }
    
    func viewAllRequests(){
        
//        let vc = UIStoryboard(name: "Feeds", bundle: nil).instantiateViewController(withIdentifier: "EventRequestsViewController") as! EventRequestsViewController
//        vc.eventID = details?.id
//        vc.feedType = self.feedType
//        self.navigationController?.pushViewController(vc, animated: true)
//        
    }
    
    func initialSettings(){
        setupLocalisation()
        nibInitialization()
        tableViewPlayersObserver = tableViewPositions.observe(\.contentSize, options: .new) { (_, change) in
                    guard let height = change.newValue?.height else { return }
                    self.tableViewHeight.constant = height
                }
        configureViewModel()
        fillDetails()
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableViewPositions, cellName: CellIdentifier.listPlayerPositionTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func configureViewModel() {
        sendEventRequestsViewModel = SendEventRequestsViewModel()
        sendEventRequestsViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        sendEventRequestsViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        sendEventRequestsViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.eventRequestSuccess()
            })
            .store(in: &cancellable)
    }
    
    func eventRequestSuccess(){
        self.customAlertView(title: ErrorMessage.success.localized, description: "Event Request Sent", image: ImageConstants.successImage) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func setupLocalisation(){
        btnDetails.setTitle("View Details".localized, for: .normal)
        btnProfile.setTitle("View Profile".localized, for: .normal)
        fixedSearchingFor.text = "Searching for:".localized
        fixedMatchDate.text = "Match Date".localized
        fixedPostOwner.text = "Post Owner".localized
        fixedTeamInfo.text = "Team Info".localized
    }
    
    func fillDetails(){
        lblLocation.text = details?.address
        lblDescription.text = details?.description
        imgPost.setImage(imageStr: details?.eventImgURL ?? "", placeholder: .placeholder1)
        if details?.eventImgURL != nil{
            imgPost.isHidden = false
        }
        else{
            imgPost.isHidden = true
        }
        imgUser.setImage(imageStr: details?.creatorImgURL ?? "",placeholder: .placeholder1)
        lblName.text = details?.creatorName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.ddMMyyyyWithTimeZone.rawValue
        if let dt1 = dateFormatter.date(from: details?.createdAt ?? "") {
            lblTime.text = dt1.timeAgoDisplay()
        }
        imageViewTeam.setImage(imageStr: details?.teamLogoURL ?? "", placeholder: .placeholderTeam)
        lblTeamName.text = details?.teamName
        lblTeamLocation.text = details?.teamAddress
//        if Utility.getCurrentLang() == "zh-Hans"{
//            lblTeamName.text = details?.team_name_cn
//            lblDescription.text = details?.description_cn
//            
//        }
        switch details?.type ?? ""{
        case FeedsType.searchTeam.rawValue:
            self.feedType = .searchTeam
            lblType.text = "Team".localized
            btnProfile.isHidden = false
            tableStack.isHidden = true
            teamStack.isHidden = true
            matchDateStack.isHidden = true
            btnAction.setTitle("Send Request".localized, for: .normal)
            lblTop.text = "Searching a team".localized
        case FeedsType.searchPlayer.rawValue:
            self.feedType = .searchPlayer
            btnProfile.isHidden = true
            lblType.text = "Player".localized
            tableViewPositions.reloadData()
            tableStack.isHidden = false
            teamStack.isHidden = false
            btnAction.setTitle("Join Team".localized, for: .normal)
            matchDateStack.isHidden = true
            lblTop.text = "Searching a player".localized
        case FeedsType.challengeTeam.rawValue:
            self.feedType = .challengeTeam
            lblType.text = "Challenge".localized
            btnProfile.isHidden = true
            tableStack.isHidden = true
            teamStack.isHidden = false
            btnAction.setTitle("Accept Challenge".localized, for: .normal)
            txtDate.text = details?.scheduleTime
            lblTop.text = "Challenge".localized
           // if AppPreferences.getUserData()?.id != details?.creatorUserId{
                let dt_formatter = DateFormatter()
                dt_formatter.dateFormat = dateFormat.yyyyMMddHHmm.rawValue
                let matchDate = dt_formatter.date(from: details?.scheduleTime ?? "")
                let diff = getDaysDifference(dateStr: details?.scheduleTime ?? "", format: .yyyyMMddHHmm)
                if matchDate != nil || diff < 0{
                    matchDateStack.isHidden = true
                    btnAction.isHidden = true
                }
           // }
        default:
            lblType.text = ""
        }
        
//        if AppPreferences.getUserData()?.id == details?.creatorUserId{
//            btnAction.setTitle("View Requests".localized, for: .normal)
//            if self.feedType == .challengeTeam{
//                btnAction.isHidden = true
//            }
//        }
        
        if details?.isClosed == 1{
            btnAction.isHidden = true
        }
      
    }
    func chooseTeam(completion:((StreetTeam?)->Void)?){
        navigateToViewController(MyStreetTeamsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.isForSelection = true
            vc.passTeam = completion
        }
    }
    
    
    
    func prepareEventRequest(){
        switch feedType{
        case .searchPlayer:
            let param = ["event_id":details!.id]
            sendEventRequestsViewModel?.sendEventRequestAsyncCall(param: param)
        case .searchTeam:
            callChooseTeam()
        case .challengeTeam:
            callChooseTeam()
        case .none:
            break
        }
        
    }
    
    func callChooseTeam(){
        var message = ""
        let teamMessage = "Are you sure you would like to invite".localized + "\(details?.creatorName ?? "")" + "to the selected team".localized
        let matchMessage = "Are you sure you would like to create a match with the selected team".localized
        if feedType == .searchTeam{
            message = teamMessage
        }
        else{
            message = matchMessage
        }
        chooseTeam { team in
            self.customAlertView_2Actions(title: "Alert".localized, description: message) {
                let param = ["event_id":self.details!.id,
                             "team_id":team!.id]
                self.sendEventRequestsViewModel?.sendEventRequestAsyncCall(param: param)
            }
            
        }
    }
   
}

extension StreetEventDetailsViewController{
     func getDaysDifference(dateStr:String,format:dateFormat) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let dt1 = dateFormatter.date(from: dateStr) ?? Date()
       return Calendar.current.dateComponents([.day], from: dt1, to: Date()).day ?? 0
    }
}


extension StreetEventDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details?.positions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.listPlayerPositionTableViewCell, for: indexPath) as! ListPlayerPositionTableViewCell
        cell.configureCell(obj: details?.positions?[indexPath.row])
        return cell
    }
}


//
//extension StreetEventDetailsViewController:FeedsDetailsViewModelDelegate{
//    func didFinishSendRequest() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//}
