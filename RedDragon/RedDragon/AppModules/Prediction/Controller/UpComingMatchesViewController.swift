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

    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var upcomingMatchesTableView: UITableView!
    
    var dateArr: [String]? = []
    private var predictionMatchesViewModel: PredictionViewModel?
    var predictionMatchesModel: PredictionMatchesModel?
    var sportsArr = ["football" , "basketball"]
    var selectedSports = ""
    
    private var cancellable = Set<AnyCancellable>()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.09803921569, blue: 0.06274509804, alpha: 1)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Upcoming Matches"
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
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
        sportsCollectionView.register(CellIdentifier.leagueNamesCollectionCell)
        upcomingMatchesTableView.register(CellIdentifier.predictUpcomingTableViewCell)
        sportsCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        dateCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        selectedSports = sportsArr[0]
        
       
    }
    
    func getNextFiveDatesArr(){
        for i in 0 ..< 5{
            let date = Date()
            let addingDate = date.add(days: i)
            dateArr?.append(addingDate?.formatDate(outputFormat: dateFormat.yyyyMMdd) ?? "")
          
        }
    }
    
    func makeNetworkCall(date: String?, sport: String) {
        predictionMatchesViewModel?.fetchPredictionMatchesAsyncCall(lang: "en", date: date ?? "", sportType: sport)
    }
    
    @objc func predictBtnAction(sender: UIButton){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction, animationType: .autoReverse(presenting: .zoom), configure: { vc in
            vc.sport = self.selectedSports
         //   self.predictionMatchesModel?.data
          
        })
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
}

extension UpComingMatchesViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView{
            return dateArr?.count ?? 0
        }
        if collectionView == sportsCollectionView{
            return sportsArr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dateCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.homeTitleCollectionVc, for: indexPath) as! HomeTitleCollectionVc
            cell.titleLable.text = dateArr?[indexPath.row]
            return cell
        }
        if collectionView == sportsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
            cell.leagueName.text = sportsArr[indexPath.row]
            return cell
        }
        else{
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollectionView{
            fetchPredictionMatchesViewModel()
            makeNetworkCall(date: dateArr?[indexPath.row], sport: selectedSports)
        }
        if collectionView == sportsCollectionView{
            fetchPredictionMatchesViewModel()
            selectedSports = sportsArr[indexPath.row]
            makeNetworkCall(date: dateArr?[indexPath.row], sport: sportsArr[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sportsCollectionView{
            return CGSize(width: screenWidth / 2, height: 30)
        }
        if collectionView == dateCollectionView{
            return CGSize(width: 80, height: 40)
        }
        else{
            return CGSize(width: 0, height: 0)
        }
    }

}

extension UpComingMatchesViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return predictionMatchesModel?.response?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionMatchesModel?.response?.data?[section].matches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictUpcomingTableViewCell, for: indexPath) as! PredictUpcomingTableViewCell
        cell.configCell(predictionData: predictionMatchesModel?.response?.data?[indexPath.section], row: indexPath.row, sport: selectedSports)
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToViewController(MatchDetailsVC.self, storyboardName: StoryboardName.matchDetail, animationType: .autoReverse(presenting: .zoom), configure:{ vc in
            vc.isFromPrediction = true
            vc.matchSlug = self.predictionMatchesModel?.response?.data?[indexPath.section].matches?[indexPath.row].slug
            vc.sports = self.selectedSports
        })
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PredictUpcomingHeaderView()
        headerView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        headerView.leagueImgView.sd_setImage(with: URL(string: predictionMatchesModel?.response?.data?[section].logo ?? ""))
        headerView.leagueNameLbl.text = predictionMatchesModel?.response?.data?[section].league
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
        let data = data.response?.data
        UIView.animate(withDuration: 1.0) { [self] in
            upcomingMatchesTableView.reloadData()
                
        }
        
    }
}
