//
//  StreetPlayerProfileViewController.swift
//  RedDragon
//
//  Created by Remya on 12/14/23.
//

import UIKit
import Combine

class StreetPlayerProfileViewController: UIViewController {

    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var collectionViewTop: UICollectionView!
    @IBOutlet weak var tableViewEvents: UITableView!
    
    //Variables
    var tableViewObserver: NSKeyValueObservation?
    var user:StreetProfileUser?
    var actiVities:StreetMatchHome?
    var isOtherPlayer = false
    var playerID:Int?
    var userID:Int?
    var playerProfileVM:StreetPlayerProfileViewModel?
    var myPlayerProfileVM:StreetMyPlayerProfileViewModel?
    var streethomeVM: StreetHomeViewModel?
    private var cancellable = Set<AnyCancellable>()
    var types = ["Events".localized,"Overview".localized]
    var eventHeaders = ["My Posts".localized,"My Teams".localized,"My Matches".localized]
    var selectedHeader = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

    }
    
    @IBAction func actionEditProfile(_ sender: Any) {
        navigateToViewController(StreetEditProfileViewController.self,storyboardName: StoryboardName.streetMatches)
    }
    
   
    func initialSetup(){
        userID = 48
        playerID = 48
        isOtherPlayer = true
        nibInitialization()
        configureViewModels()
        btnUpdate.setTitle("Edit Profile".localized, for: .normal)
        tableViewObserver = tableView.observe(\.contentSize, options: .new) { (_, change) in
                    guard let height = change.newValue?.height else { return }
                    self.tableHeight.constant = height
                }
        var heading = "My Profile".localized
       
        if !isOtherPlayer{
            myPlayerProfileVM?.getMyProfileAsyncCall()
            //setupDetails()
        }
        else{
            heading = "Player Profile".localized
            btnUpdate.isHidden = true
            playerProfileVM?.getPlayerProfileAsyncCall(id: playerID!)
        }
        lblTitle.text = heading
        streethomeVM?.fetchStreetHomeAsyncCall(id: userID)
        collectionViewTop.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    func nibInitialization() {
        collectionViewTop.register(CellIdentifier.headerTopCollectionViewCell)
        defineTableViewNibCell(tableView: tableViewEvents, cellName: CellIdentifier.streetMatchTableViewCell)
        defineTableViewNibCell(tableView: tableViewEvents, cellName: CellIdentifier.streetHomeHeaderTableViewCell)
        defineTableViewNibCell(tableView: tableViewEvents, cellName: CellIdentifier.newTeamTableViewCell)
        defineTableViewNibCell(tableView: tableViewEvents, cellName: CellIdentifier.feedsTableViewCell)
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.infoTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func configureViewModels() {
        streethomeVM = StreetHomeViewModel()
        streethomeVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        streethomeVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        streethomeVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if response?.response?.data != nil{
                    self?.handleActivities(data: response!.response!.data!)
                }
            })
            .store(in: &cancellable)
        
        
        myPlayerProfileVM = StreetMyPlayerProfileViewModel()
        myPlayerProfileVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        myPlayerProfileVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        myPlayerProfileVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let data = response?.response?.data{
                    self?.handleUserData(data: data)
                }
            })
            .store(in: &cancellable)
        
        playerProfileVM = StreetPlayerProfileViewModel()
        playerProfileVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        playerProfileVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        playerProfileVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let data = response?.response?.data{
                    self?.handleUserData(data: data)
                }
            })
            .store(in: &cancellable)
    }
    
    func handleActivities(data:StreetMatchHome){
        self.actiVities = data
        tableViewEvents.reloadData()
        
    }
    
    func handleUserData(data:StreetProfileUser){
        self.user = data
        setupDetails()
    }
    
    
    func setupDetails(){
        userID = user?.id
        lblName.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        lblLocation.text = user?.player?.address
        lblAbout.text = user?.player?.description
//        if Utility.getCurrentLang() == "zh-Hans"{
//            lblAbout.text = user?.player.description_cn
//        }
        if !(user?.player?.imgURL?.isEmpty ?? false){
            imgProfile.setImage(imageStr: user?.player?.imgURL ?? "", placeholder: .placeholderUser)
        }
        tableView.reloadData()
    }
 
}

extension StreetPlayerProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewEvents{
            return getRows(section: section)
        }
        else{
            return 5
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewEvents{
            return 3
        }
        else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewEvents{
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.feedsTableViewCell, for: indexPath) as! FeedsTableViewCell
                cell.configureCell(obj: actiVities?.events?[indexPath.row])
                return cell
            }
            else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newTeamTableViewCell, for: indexPath) as! NewTeamTableViewCell
                cell.configureCell(obj: actiVities?.teams?[indexPath.row])
                return cell
                
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchTableViewCell, for: indexPath) as! StreetMatchTableViewCell
                cell.configureCell(obj: actiVities?.matches?[indexPath.row])
                return cell
            }
            
            
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.infoTableViewCell, for: indexPath) as! InfoTableViewCell
            
            switch indexPath.row{
            case 0:
                var position = user?.player?.positionName ?? ""
//                if Utility.getCurrentLang() == "zh-Hans"{
//                    position = user?.player?.position_name_cn ?? ""
//                }
                cell.configureCell(key: "Main Position".localized, value: position)
            case 1:
                var valueText = user?.player?.dominateFoot ?? ""
//                if Utility.getCurrentLang() == "zh-Hans"{
//                    if valueText == "LEFT"{
//                        valueText = "LEFT".localized
//                    }
//                    else{
//                        valueText = "RIGHT".localized
//                    }
//                }
                cell.configureCell(key: "Preferred Foot".localized, value: valueText)
            case 2:
                cell.configureCell(key: "Height".localized, value: (String(user?.player?.height ?? 0)) + " cm")
            case 3:
                cell.configureCell(key: "Weight".localized, value: (String(user?.player?.weight ?? 0)) + " kg")
            case 4:
                let age = StreetMatchPlayerTableViewCell.getDateDiffrence(dateStr: user?.player?.birthdate ?? "")
                cell.configureCell(key: "Age".localized, value: "\(age)")
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewEvents{
            if indexPath.section == 0{
                goToPostDetails(event: actiVities?.events?[indexPath.row])
            }
            else if indexPath.section == 1{
                goToTeamDetails(team: actiVities?.teams?[indexPath.row])
            }
            else{
                goToMatchDetails(match: actiVities?.matches?[indexPath.row])
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableViewEvents{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetHomeHeaderTableViewCell) as! StreetHomeHeaderTableViewCell
            cell.lblTitle.text = eventHeaders[section]

            cell.callSelection = {
                if section == 0{
                    self.gotoMyPosts()
                }
                else if section == 1{
                    self.gotoMyTeams()
                }
                else{
                    self.gotoMyMatches()
                }
            }
            return cell
        }
        else{
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tableViewEvents{
            if getRows(section: section) == 0{
                return CGFloat.leastNormalMagnitude
                
            }
            return 40
        }
        else{
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func getRows(section:Int)->Int{
        if section == 0 && ((actiVities?.events?.count ?? 0) >= 2){
            return 2
        }
        
        if section == 1 && ((actiVities?.teams?.count ?? 0) >= 2){
            return 2
        }
        else if section == 1{
            return (actiVities?.teams?.count ?? 0)
        }
        if section == 2 && ((actiVities?.matches?.count ?? 0) >= 2){
            return 2
        }
        else {
            return 0
        }
        
    }
    
    func gotoMyMatches(){
        navigateToViewController(StreetMyMatchesViewController.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.matches = self.actiVities?.matches
        }
    }
    
    func gotoMyTeams(){
        navigateToViewController(MyStreetTeamsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.isFromProfile = true
            vc.teams = self.actiVities?.teams
            
        }
        
    }
    
    func gotoMyPosts(){
        navigateToViewController(StreetMyEventsViewController.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.events = self.actiVities?.events
        }
        
    }
    
    func goToMatchDetails(match:StreetMatch?){
        navigateToViewController(StreetMatchesDetailsVC.self, storyboardName: StoryboardName.streetMatches) { vc in
            vc.matchID = match?.id
        }
    }
    
    func goToTeamDetails(team:StreetTeam?){
        
        navigateToViewController(StreetTeamDetailsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.teamID = team?.id
        }

    }
    
    func goToPostDetails(event:StreetEvent?){
        navigateToViewController(StreetEventDetailsViewController.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.details = event
        }
    }
}

extension StreetPlayerProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return types.count
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
        cell.configureCell(title: types[indexPath.row], selected: selectedHeader == indexPath.row)
        cell.titleLabel.text = types[indexPath.row]
            return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedHeader = indexPath.row
        collectionView.reloadData()
        if indexPath.row == 0{
            scroll.isHidden = true
            eventsView.isHidden = false
        }
        else{
            scroll.isHidden = false
            eventsView.isHidden = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let w = UIScreen.main.bounds.width - 60
            return CGSize(width: w/CGFloat(types.count), height: 40)
    }
    
}
