//
//  AnalysisViewController.swift
//  RedDragon
//
//  Created by QASR02 on 07/11/2023.
//

import UIKit
import Combine
import SDWebImage

class AnalysisViewController: UIViewController {
    
    @IBOutlet weak var analysisTableView: UITableView!
    
    private var analysisViewModel: AnalysisViewModel?
    private var analysisModel: AnalysisModel?
    private var cancellable = Set<AnyCancellable>()
    var matchSlug = ""
    var data: MatchDataClass?
    var followUserVM = FollowUserViewModel()
    var unfollowUserVM = UnfollowUserViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    func configureView(){
        loadFunctionality()
        fetchAnalysisViewModel()
        makeNetworkCall()
    }
    
    func loadFunctionality() {
        nibInitialization()
    }
    
    func nibInitialization() {
        analysisTableView.register(CellIdentifier.analysisTableViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func makeNetworkCall() {
        analysisViewModel?.fetchPredictionAnalysisAsyncCall(matchID: matchSlug)
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
    
    @objc func followBtnAction(sender: UIButton){
        if sender.tag != 0{
            if sender.backgroundColor == UIColor.init(hex: "FFE08A"){
                unfollowUserVM.postUnfollowUser(userId: sender.tag)
                unfollowUserViewModelResponse()
            }
            else{
                followUserVM.postFollowUser(userId: sender.tag)
                followUserViewModelResponse()
            }
        }
       
    }

}

extension AnalysisViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analysisModel?.response?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.analysisTableViewCell, for: indexPath) as! AnalysisTableViewCell
        cell.userImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
       // cell.userImgView.sd_setImage(with: URL(string: analysisModel?.response?.data?[indexPath.row].user?.imgURL ?? ""))
        cell.nameLbl.text = analysisModel?.response?.data?[indexPath.row].user?.name
      //  cell.descriptionTxtView.text = analysisModel?.response?.data?[indexPath.row].comments
        cell.winPercentageLbl.text = String(format: "%.1f",analysisModel?.response?.data?[indexPath.row].user?.predStats?.successRate ?? 0.0 ) + "%"
        cell.betsLbl.text = " \(analysisModel?.response?.data?[indexPath.row].user?.predStats?.allCnt ?? 0)" + " " + "Predictions".localized + " "
        if analysisModel?.response?.data?[indexPath.row].isFollow == true{
            cell.followBtn.setTitle("Following".localized, for: .normal)
            cell.followBtn.backgroundColor = UIColor.init(hex: "FFE08A")
            cell.followBtn.setTitleColor(.black, for: .normal)
        }
        else{
            cell.followBtn.setTitle("Follow".localized, for: .normal)
            cell.followBtn.backgroundColor = UIColor.init(hex: "00658C")
            cell.followBtn.setTitleColor(.white, for: .normal)
        }
        cell.followBtn.tag = analysisModel?.response?.data?[indexPath.row].reddragonUserID ?? 0
        cell.followBtn.addTarget(self, action: #selector(followBtnAction), for: .touchUpInside)
       labelWithImage(lbl: cell.fireCountLbl, text: " \(analysisModel?.response?.data?[indexPath.row].user?.predStats?.successCnt ?? 0)" + " ")
        cell.winRateLbl.text = "Win Rate".localized
        cell.predictedLbl.text = "Predicted".localized
        if analysisModel?.response?.data?[indexPath.row].predictedTeam == "1"{
            cell.predictionLbl.text = " " + "Draw".localized + " "
        }
        else if analysisModel?.response?.data?[indexPath.row].predictedTeam == "2"{
            cell.predictionLbl.text = " " + (data?.homeTeamName ?? "Home") + " " + "Win".localized + " "
        }
        else if analysisModel?.response?.data?[indexPath.row].predictedTeam == "3"{
            cell.predictionLbl.text = " " + (data?.awayTeamName ?? "Away") + " " + "Win".localized + " "
        }
            
        
      
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToViewController(PredictionResultViewController.self, storyboardName: StoryboardName.prediction, animationType: .autoReverse(presenting: .zoom), configure: { vc in
            vc.data = self.data
            vc.analysisData = self.analysisModel?.response?.data?[indexPath.row]
            //vc.configureTopView()
             
           })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
}

extension AnalysisViewController {
    ///fetch viewModel for prediction
    func fetchAnalysisViewModel() {
        analysisViewModel = AnalysisViewModel()
        analysisViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        analysisViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        analysisViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.renderResponseData(data: data!)
            })
            .store(in: &cancellable)
    }
    
    func renderResponseData(data: AnalysisModel) {
        analysisModel = data
        if let data = data.response?.data{
            UIView.animate(withDuration: 1.0) { [self] in
                analysisTableView.reloadData()
                
            }
        }
        else{
            handleError(data.error)
        }
        
    }
    
    func followUserViewModelResponse() {
        followUserVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        followUserVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        followUserVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] result in
                if result?.response?.code == 200 {
                 //   self?.userArray[index].following = true
                 //   self?.tableView.reloadData()
                    self?.makeNetworkCall()
                }
                else{
                   // handleError(result?.response)
                }
            })
            .store(in: &cancellable)
    }
    
    func unfollowUserViewModelResponse() {
        unfollowUserVM.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        unfollowUserVM.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        unfollowUserVM.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] result in
                if result?.response?.code == 200 {
                 //   self?.userArray[index].following = false
                 //   self?.tableView.reloadData()
                    self?.makeNetworkCall()
                }
            })
            .store(in: &cancellable)
    }
    
    func handleError(_ error :  ErrorResponse?){
        if let error = error {
            if error.messages?.first != "Unauthorized user" {
                self.customAlertView(title: ErrorMessage.alert.localized, description: error.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
            }
            else{
                self.customAlertView_3Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                    /// Show login page to login/register new user
                    self.presentViewController(LoginVC.self, storyboardName: StoryboardName.login) { vc in
                        vc.delegate = self
                        
                    }
                } dismissAction: {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }


}
extension AnalysisViewController: LoginVCDelegate{
    func viewControllerDismissed() {
        makeNetworkCall()
    }
}
