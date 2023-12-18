//
//  StreetTeamDetailsVC.swift
//  RedDragon
//
//  Created by Remya on 12/8/23.
//

import UIKit
import Combine

class StreetTeamDetailsVC: UIViewController {

    @IBOutlet weak var imageViewTeam: UIImageView!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var collectionViewHeader: UICollectionView!
    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet weak var descriptionStack: UIStackView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableListHeight: NSLayoutConstraint!
    @IBOutlet weak var fixedInfo: UILabel!
    @IBOutlet weak var fixedAboutTeam: UILabel!
    
    //Variables
    var teamDetailsViewModel:StreetTeamDetailsViewModel?
    var teamDetails:StreetTeamDetails?
    var teamID:Int?
    var headers = ["Information".localized,"Players".localized,"Matches".localized]
    var selectedHeader = 0
    var listHeaders = ["Today".localized,"Scheduled".localized,"Ended".localized]
    var tableViewObserver: NSKeyValueObservation?
    var tableViewListObserver: NSKeyValueObservation?
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    
    func initialSetup(){
        nibInitialization()
        setupLocalisation()
        fetchTeamDetailsViewModel()
        collectionViewHeader.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        
        collectionViewHeader.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
        tableViewObserver = infoTableView.observe(\.contentSize, options: .new) { (_, change) in
                    guard let height = change.newValue?.height else { return }
                    self.tableHeight.constant = height
                }
        tableViewListObserver = tableViewList.observe(\.contentSize, options: .new) { (_, change) in
                    guard let height = change.newValue?.height else { return }
                    self.tableListHeight.constant = height
                }
        makeNetworkCall()
       
    }
    
    func nibInitialization() {
        collectionViewHeader.register(CellIdentifier.headerTopCollectionViewCell)
        defineTableViewNibCell(tableView: tableViewList, cellName: CellIdentifier.streetMatchTableViewCell)
        defineTableViewNibCell(tableView: tableViewList, cellName: CellIdentifier.streetMatchPlayerTableViewCell)
        defineTableViewNibCell(tableView: tableViewList, cellName: CellIdentifier.streetHomeHeaderTableViewCell)
        defineTableViewNibCell(tableView: infoTableView, cellName: CellIdentifier.infoTableViewCell)
    }
    
    func setupLocalisation(){
        
        fixedInfo.text = "Info".localized
        fixedAboutTeam.text = "About Team".localized
       
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func fetchTeamDetailsViewModel() {
        teamDetailsViewModel = StreetTeamDetailsViewModel()
        teamDetailsViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        teamDetailsViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        teamDetailsViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                    self?.teamDetails = response?.response?.data
                    self?.fillDetails()
            })
            .store(in: &cancellable)
    }
    
    
    
    func makeNetworkCall(){
        teamDetailsViewModel?.fetchStreetTeamDetailsAsyncCall(id: teamID!)
    }
    
    func configureViews(){
        if selectedHeader == 0{
            infoStack.isHidden = false
            tableViewList.isHidden = true
        }
        else{
            infoStack.isHidden = true
            tableViewList.isHidden = false
            tableViewList.reloadData()
        }
        
    }
    
    func fillDetails(){
        imageViewTeam.setImage(imageStr: teamDetails?.logoImgURL ?? "", placeholder: .placeholderTeam)
       
        lblTeam.text = teamDetails?.name
        lblLocation.text = teamDetails?.address
        if teamDetails?.description?.count ?? 0 == 0{
            descriptionStack.isHidden = true
        }
        lblAbout.text = teamDetails?.description
        infoTableView.reloadData()
        
//        if Utility.getCurrentLang() == "zh-Hans"{
//            lblTeam.text = viewModel.teamDetails?.name_cn
//            lblAbout.text = viewModel.teamDetails?.description_cn
//            
//        }
    }
    
    func toPlayerDetails(player:Player?){
//        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//        vc.isOtherPlayer = true
//        vc.playerID = player?.player_id
//        vc.userID = player?.userId
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toMatchDetails(matchID:Int?){
        navigateToViewController(StreetMatchesDetailsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.matchID = matchID
        }
        
    }
 
}





extension StreetTeamDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
        cell.configureCell(title: headers[indexPath.row], selected: selectedHeader == indexPath.row)
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedHeader = indexPath.row
        configureViews()
        collectionView.reloadData()
        tableViewList.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = UIScreen.main.bounds.width - 40
        return CGSize(width: w/CGFloat(headers.count), height: 40)
    }
    
}


extension StreetTeamDetailsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == infoTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.infoTableViewCell, for: indexPath) as! InfoTableViewCell
            if indexPath.row % 2 != 0{
                cell.backView.backgroundColor = .wheat1
            }
            else{
                cell.backView.backgroundColor = .wheat8
                
            }
            switch indexPath.row{
            case 0:
                var team = teamDetails?.name ?? ""
//                if Utility.getCurrentLang() == "zh-Hans"{
//                    team = viewModel.teamDetails?.name_cn ?? ""
//                }
                cell.configureCell(key: "Team Name".localized, value: team)
            case 1:
                cell.configureCell(key: "Address".localized, value: teamDetails?.address ?? "")
            case 2:
                let dtStr = teamDetails?.createdAt ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormat.ddMMyyyyWithTimeZone.rawValue
                let dt = dateFormatter.date(from: dtStr)
                let displayDate = dt?.formatDate(outputFormat: dateFormat.ddMMyyyy) ?? ""
                cell.configureCell(key: "Created Date".localized, value: displayDate)
            case 3:
                let name = (teamDetails?.creator?.firstName ?? "") + " " + (teamDetails?.creator?.lastName ?? "")
                
                cell.configureCell(key: "Team Owner".localized, value: name)
                
            default:
                break
            }
            
            return cell
        }
        else {
            if selectedHeader == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchPlayerTableViewCell) as! StreetMatchPlayerTableViewCell
                cell.configureCell(obj: teamDetails?.players?[indexPath.row])
                return cell
                
            }
            else if selectedHeader == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchTableViewCell, for: indexPath) as! StreetMatchTableViewCell
                if indexPath.section == 0{
                    cell.configureCell(obj: teamDetails?.matches?.today?[indexPath.row])
                }
                else if indexPath.section == 1{
                    cell.configureCell(obj: teamDetails?.matches?.scheduled?[indexPath.row])
                }
                else{
                    cell.configureCell(obj: teamDetails?.matches?.past?[indexPath.row])
                }
                return cell
            }
            else{
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedHeader{
        case 0:
            return 4
        case 1:
            return teamDetails?.players?.count ?? 0
        case 2:
            if section == 0{
                return teamDetails?.matches?.today?.count ?? 0
            }
            else if section == 1{
                return teamDetails?.matches?.scheduled?.count ?? 0
            }
            else{
                return teamDetails?.matches?.past?.count ?? 0
            }
        default:
            return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedHeader == 2{
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewList{
            if selectedHeader == 1{
                //toPlayerDetails(player: teamDetails?.players?[indexPath.row])
            }
            else if selectedHeader == 2{
                if indexPath.section == 0{
                    toMatchDetails(matchID: teamDetails?.matches?.today?[indexPath.row].id)
                }
                else if indexPath.section == 1{
                    toMatchDetails(matchID: teamDetails?.matches?.scheduled?[indexPath.row].id)
                }
                else{
                    toMatchDetails(matchID: teamDetails?.matches?.past?[indexPath.row].id)
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableViewList{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetHomeHeaderTableViewCell) as! StreetHomeHeaderTableViewCell
            cell.lblTitle.text = listHeaders[section]
            cell.btnMore.isHidden = true
            return cell
        }
        else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == infoTableView{
            return CGFloat.leastNormalMagnitude
        }
        else{
            if selectedHeader == 2{
                if section == 0 && (teamDetails?.matches?.today?.count ?? 0) == 0{
                    return CGFloat.leastNormalMagnitude
                }
               else if section == 1 && (teamDetails?.matches?.scheduled?.count ?? 0) == 0{
                    return CGFloat.leastNormalMagnitude
                }
                else if section == 2 && (teamDetails?.matches?.past?.count ?? 0) == 0{
                     return CGFloat.leastNormalMagnitude
                 }
                return 50
            }
            return CGFloat.leastNormalMagnitude
        }
    }
}

