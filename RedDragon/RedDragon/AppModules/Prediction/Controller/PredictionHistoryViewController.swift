//
//  PredictionHistoryViewController.swift
//  RedDragon
//
//  Created by Ali on 11/22/23.
//

import UIKit
import SDWebImage
import Combine

class PredictionHistoryViewController: UIViewController {

    @IBOutlet weak var predictionHistoryTitleLbl: UILabel!
    @IBOutlet weak var predictionMatchesTableView: UITableView!
    @IBOutlet weak var datesCollectionView: UICollectionView!
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    
    private var predictionListUserViewModel:PredictionsListUserViewModel?
    var predictionListUserModel: PredictionListModel?
    var sportsArr = ["football","basketball"]
    var selectedSports = ""
    var dateArr: [String]? = []
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        predictionHistoryTitleLbl.text = "Prediction History".localized
        getPreviousFiveDatesArr()
        configureView()
    }
    
    
    func configureView() {
       // selectedSports = sportsArr[0]
        loadFunctionality()
        fetchPredictionUserListViewModel()
      //  makeNetworkCall(sport: selectedSports)
        
    }
    
    func loadFunctionality() {
        nibInitialization()
    }
    
    func nibInitialization() {
        datesCollectionView.register(CellIdentifier.homeTitleCollectionVc)
        predictionMatchesTableView.register(CellIdentifier.predictHistoryTableViewCell)
        sportsCollectionView.register(CellIdentifier.leagueNamesCollectionCell)
        if selectedSports == "football"{
            sportsCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
            selectedSports = sportsArr[0]
        }
        else{
            sportsCollectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .left)
            selectedSports = sportsArr[1]
        }
        datesCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        
    }
    
    func getPreviousFiveDatesArr(){
        for i in -5 ..< 0{
            let date = Date()
            let addingDate = date.add(days: i)
            dateArr?.append(addingDate?.formatDate(outputFormat: dateFormat.yyyyMMdd) ?? "")
          
        }
    }
    
    func makeNetworkCall(sport: String, date: String?) {
        let userID = UserDefaults.standard.user?.appDataIDs.predictMatchUserId
        predictionListUserViewModel?.fetchPredictionUserListAsyncCall(appUserID: "\(userID ?? 0)" , sportType: sport, date: date ?? "")  // To give logged in user id instead of 7
      
    }
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func labelWithImage(lbl:UILabel, text: String){
        // Create Attachment
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named:"fire1")
        // Set bound to reposition
        let imageOffsetY: CGFloat = -3.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        completeText.append(attachmentString)
        // Add your text to mutable string
        let textAfterIcon = NSAttributedString(string: text)
        completeText.append(textAfterIcon)
        lbl.textAlignment = .center
        lbl.attributedText = completeText
    }
    
    func getPredictedTeam(predictiveTeam:String?) -> String{
        if predictiveTeam == "1"{
            return "Draw"
        }
        else if predictiveTeam == "2"{
            return "Home"
        }
        else if predictiveTeam == "3"{
            return "Away"
        }
        else{
            return ""
        }
    }

    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PredictionHistoryViewController{
    func fetchPredictionUserListViewModel() {
        predictionListUserViewModel = PredictionsListUserViewModel()
        predictionListUserViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        predictionListUserViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        predictionListUserViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.renderResponseData(data: data!)
            })
            .store(in: &cancellable)
    }
    
    func renderResponseData(data: PredictionListModel) {
        predictionListUserModel = data
        if let data = data.response?.data{
            UIView.animate(withDuration: 1.0) { [self] in
                self.predictionMatchesTableView.reloadData()
                
            }
        }
    }
}

extension PredictionHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == datesCollectionView{
            return dateArr?.count ?? 0
        }
        if collectionView == sportsCollectionView{
            return sportsArr.count
        }
        return 0
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == datesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.homeTitleCollectionVc, for: indexPath) as! HomeTitleCollectionVc
            cell.titleLable.text = dateArr?[indexPath.row]
            return cell
        }
        else if collectionView == sportsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
            cell.leagueName.text = sportsArr[indexPath.row].localized
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == datesCollectionView{
            fetchPredictionUserListViewModel()
            makeNetworkCall(sport: selectedSports, date: dateArr?[indexPath.row])
        }
        if collectionView == sportsCollectionView{
            fetchPredictionUserListViewModel()
            selectedSports = sportsArr[indexPath.row]
            makeNetworkCall(sport: sportsArr[indexPath.row], date: dateArr?[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == sportsCollectionView{
            return CGSize(width: screenWidth / 2, height: 30)
        }
        if collectionView == datesCollectionView{
            return CGSize(width: 80, height: 40)
        }
        else{
            return CGSize(width: 0, height: 0)
        }
       
    }
    
    
}

extension PredictionHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionListUserModel?.response?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictHistoryTableViewCell, for: indexPath) as! PredictHistoryTableViewCell
        cell.selectionStyle = .none
        cell.leagueNameLbl.text = predictionListUserModel?.response?.data?[indexPath.row].matchDetail.leagueName?.localized
        cell.dateLbl.text = predictionListUserModel?.response?.data?[indexPath.row].matchDetail.matchDatetime
        cell.team1ImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.team1ImgView.sd_setImage(with: URL(string: predictionListUserModel?.response?.data?[indexPath.row].matchDetail.homeTeamImage ?? ""))
        cell.team1Lbl.text = predictionListUserModel?.response?.data?[indexPath.row].matchDetail.homeTeamName?.localized
        cell.team2Lbl.text = predictionListUserModel?.response?.data?[indexPath.row].matchDetail.awayTeamName?.localized
        cell.team2ImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.team2ImgView.sd_setImage(with: URL(string: predictionListUserModel?.response?.data?[indexPath.row].matchDetail.awayTeamImage ?? ""))
        cell.scoreLbl.text = (predictionListUserModel?.response?.data?[indexPath.row].matchDetail.homeScore ?? "0") + " - " + (predictionListUserModel?.response?.data?[indexPath.row].matchDetail.awayScore ?? "0")
        labelWithImage(lbl: cell.rewardsLbl, text: " Rewards: ".localized + "\(predictionListUserModel?.response?.data?[indexPath.row].user?.predStats?.coins ?? 0)")
        if predictionListUserModel?.response?.data?[indexPath.row].isSuccess == 0{
            cell.predictionRewardView.backgroundColor = UIColor.init(hex: "FFDAD5")
            cell.rewardsLbl.isHidden = true
            cell.wrongPredictionLbl.text = (getPredictedTeam(predictiveTeam: predictionListUserModel?.response?.data?[indexPath.row].predictedTeam)).localized + " - " + "Wrong Prediction".localized
            
        }
        else if predictionListUserModel?.response?.data?[indexPath.row].isSuccess == 1{
            cell.predictionRewardView.backgroundColor = UIColor.init(hex: "CEF6D7")
            cell.rewardsLbl.isHidden = false
            cell.correctPredictionLbl.text = (getPredictedTeam(predictiveTeam: predictionListUserModel?.response?.data?[indexPath.row].predictedTeam)).localized + " - " + "Correct Prediction".localized
        }
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 119
    }
    
}
