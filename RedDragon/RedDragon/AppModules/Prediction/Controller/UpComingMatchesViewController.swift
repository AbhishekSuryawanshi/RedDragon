//
//  UpComingMatchesViewController.swift
//  RedDragon
//
//  Created by Ali on 11/22/23.
//

import UIKit
import SDWebImage
import Combine

class UpComingMatchesViewController: UIViewController {

    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var upcomingMatchesTableView: UITableView!
    
    var dateArr: [String]? = []
    private var predictionMatchesViewModel: PredictionViewModel?
    var predictionMatchesModel: PredictionMatchesModel?
    
    private var cancellable = Set<AnyCancellable>()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNextFiveDatesArr()
        loadFunctionality()
        upcomingMatchesTableView.reloadData()
    }
    
    func loadFunctionality() {
        nibInitialization()
      //  configureUI()
    }
    
    func nibInitialization() {
        dateCollectionView.register(CellIdentifier.homeTitleCollectionVc)
        upcomingMatchesTableView.register(CellIdentifier.predictUpcomingTableViewCell)
        dateCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
       
    }
    
    func getNextFiveDatesArr(){
        for i in 0 ..< 5{
            let date = Date()
            let addingDate = date.add(days: i)
            dateArr?.append(addingDate?.formatDate(outputFormat: dateFormat.yyyyMMdd) ?? "")
          
        }
    }
    
    func makeNetworkCall(date: String?) {
        predictionMatchesViewModel?.fetchPredictionMatchesAsyncCall(lang: "en", date: date ?? "", sportType: "football")
    }
    
    @objc func predictBtnAction(sender: UIButton){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
         //   self.predictionMatchesModel?.data
          
        }
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
}

extension UpComingMatchesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.homeTitleCollectionVc, for: indexPath) as! HomeTitleCollectionVc
        cell.titleLable.text = dateArr?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchPredictionMatchesViewModel()
        makeNetworkCall(date: dateArr?[indexPath.row])
    }

}

extension UpComingMatchesViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return predictionMatchesModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionMatchesModel?.data?[section].matches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictUpcomingTableViewCell, for: indexPath) as! PredictUpcomingTableViewCell
        cell.configCell(predictionData: predictionMatchesModel?.data?[indexPath.section], row: indexPath.row)
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PredictUpcomingHeaderView()
        headerView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        headerView.leagueImgView.sd_setImage(with: URL(string: predictionMatchesModel?.data?[section].logo ?? ""))
        headerView.leagueNameLbl.text = predictionMatchesModel?.data?[section].league
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    
}

extension UpComingMatchesViewController {
    ///fetch viewModel for match prediction
    func fetchPredictionMatchesViewModel() {
        predictionMatchesViewModel = PredictionViewModel()
        predictionMatchesViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        predictionMatchesViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        predictionMatchesViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.renderResponseData(data: data!)
            })
            .store(in: &cancellable)
    }
    
    func renderResponseData(data: PredictionMatchesModel) {
        predictionMatchesModel = data
        let data = data.data
        UIView.animate(withDuration: 1.0) { [self] in
            upcomingMatchesTableView.reloadData()
                
        }
        
    }
}
