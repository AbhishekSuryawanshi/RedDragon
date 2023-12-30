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

}

extension AnalysisViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analysisModel?.response?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.analysisTableViewCell, for: indexPath) as! AnalysisTableViewCell
        cell.userImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.userImgView.sd_setImage(with: URL(string: analysisModel?.response?.data?[indexPath.row].user?.imgURL ?? ""))
        cell.nameLbl.text = analysisModel?.response?.data?[indexPath.row].user?.name
        cell.descriptionTxtView.text = analysisModel?.response?.data?[indexPath.row].comments
        cell.winPercentageLbl.text = String(format: "%.1f",analysisModel?.response?.data?[indexPath.row].user?.predStats?.successRate ?? 0.0 ) + "%"
        cell.betsLbl.text = " \(analysisModel?.response?.data?[indexPath.row].user?.predStats?.allCnt ?? 0)" + " Predictions  ".localized
       labelWithImage(lbl: cell.fireCountLbl, text: " \(analysisModel?.response?.data?[indexPath.row].user?.predStats?.successCnt ?? 0)" + " ")
       // cell.fireCountLbl.text = " \(analysisModel?.response?.data?[indexPath.row].user?.predStats?.successCnt ?? 0)" + " "
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToViewController(PredictionResultViewController.self, storyboardName: StoryboardName.prediction, animationType: .autoReverse(presenting: .zoom), configure: { vc in
            vc.data = self.data
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
        UIView.animate(withDuration: 1.0) { [self] in
            analysisTableView.reloadData()
                
        }
        
    }
}
