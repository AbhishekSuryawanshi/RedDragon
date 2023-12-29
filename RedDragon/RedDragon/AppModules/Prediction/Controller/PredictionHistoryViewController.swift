//
//  PredictionHistoryViewController.swift
//  RedDragon
//
//  Created by Ali on 11/22/23.
//

import UIKit
import SDWebImage

class PredictionHistoryViewController: UIViewController {

    @IBOutlet weak var predictionMatchesTableView: UITableView!
  //  @IBOutlet weak var datesCollectionView: UICollectionView!
  //  @IBOutlet weak var sportsCollectionView: UICollectionView!
    
    var predictionListUserModel: PredictionListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    
    func configureView() {
       // selectedSports = sportsArr[0]
        loadFunctionality()
       // fetchPredictionMatchesViewModel()
      //  makeNetworkCall(sport: selectedSports)
        
    }
    
    func loadFunctionality() {
        nibInitialization()
    }
    
    func nibInitialization() {
      //  sportsCollectionView.register(CellIdentifier.leagueNamesCollectionCell)
      //  sportsCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
      //  selectedSports = sportsArr[0]
        
        predictionMatchesTableView.register(CellIdentifier.predictHistoryTableViewCell)
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension PredictionHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionListUserModel?.response?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.predictHistoryTableViewCell, for: indexPath) as! PredictHistoryTableViewCell
        cell.selectionStyle = .none
        cell.leagueNameLbl.text = predictionListUserModel?.response?.data?[indexPath.row].matchDetail.leagueName
        cell.dateLbl.text = predictionListUserModel?.response?.data?[indexPath.row].matchDetail.matchDatetime
        cell.team1ImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.team1ImgView.sd_setImage(with: URL(string: predictionListUserModel?.response?.data?[indexPath.row].matchDetail.homeTeamImage ?? ""))
        cell.team1Lbl.text = predictionListUserModel?.response?.data?[indexPath.row].matchDetail.homeTeamName
        cell.team2Lbl.text = predictionListUserModel?.response?.data?[indexPath.row].matchDetail.awayTeamName
        cell.team2ImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.team2ImgView.sd_setImage(with: URL(string: predictionListUserModel?.response?.data?[indexPath.row].matchDetail.awayTeamImage ?? ""))
        cell.scoreLbl.text = (predictionListUserModel?.response?.data?[indexPath.row].matchDetail.homeScore ?? "0") + " - " + (predictionListUserModel?.response?.data?[indexPath.row].matchDetail.awayScore ?? "0")
        
       // predictionsTeam1ImgView2.sd_imageIndicator = SDWebImageActivityIndicator.white
      //  predictionsTeam1ImgView2.sd_setImage(with: URL(string: data[1].matchDetail.homeTeamImage ?? ""))
      
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }*/
    
}
