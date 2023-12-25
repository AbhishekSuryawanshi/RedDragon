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
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func makeNetworkCall() {
        analysisViewModel?.fetchPredictionAnalysisAsyncCall(matchID: matchSlug)
    }

}

extension AnalysisViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analysisModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.analysisTableViewCell, for: indexPath) as! AnalysisTableViewCell
        cell.userImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.userImgView.sd_setImage(with: URL(string: analysisModel?.data?[indexPath.row].user?.imgURL ?? ""))
        cell.nameLbl.text = analysisModel?.data?[indexPath.row].user?.name
        cell.descriptionTxtView.text = analysisModel?.data?[indexPath.row].comments
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
