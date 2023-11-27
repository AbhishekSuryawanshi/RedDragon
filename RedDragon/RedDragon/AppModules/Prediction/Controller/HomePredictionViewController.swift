//
//  HomePredictionViewController.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit

class HomePredictionViewController: UIViewController {

    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var predictionsTimeLbl3: UILabel!
    @IBOutlet weak var predictionsTeamWinLbl3: UILabel!
    @IBOutlet weak var predictionsTeam2Lbl3: UILabel!
    @IBOutlet weak var predictionsdateLbl3: UILabel!
    @IBOutlet weak var predictionsTeam1Lbl3: UILabel!
    @IBOutlet weak var predictionsLeagueNameLbl3: UILabel!
    @IBOutlet weak var predictionsLeagueImgView3: UIImageView!
    @IBOutlet weak var predictionsTimeLbl2: UILabel!
    @IBOutlet weak var predictionsTeamWinLbl2: UILabel!
    @IBOutlet weak var predictionsTeam2Lbl2: UILabel!
    @IBOutlet weak var predictionsdateLbl2: UILabel!
    @IBOutlet weak var predictionTeam1Lbl2: UILabel!
    @IBOutlet weak var predictionsLeagueLbl2: UILabel!
    @IBOutlet weak var predictionsLeagueImgView2: UIImageView!
    @IBOutlet weak var predictionsTimeLbl1: UILabel!
    @IBOutlet weak var predictionsTeamWinLbl1: UILabel!
    @IBOutlet weak var predictionsTeam2Lbl1: UILabel!
    @IBOutlet weak var predictionsdateLbl1: UILabel!
    @IBOutlet weak var predictionsTeam1Lbl1: UILabel!
    @IBOutlet weak var predictionsLeagueNameLbl1: UILabel!
    @IBOutlet weak var predictionsLeagueImgView1: UIImageView!
    @IBOutlet weak var seeAllPlacedPredictionsBtn: UIButton!
    @IBOutlet weak var placedPredictionsLbl: UILabel!
    @IBOutlet weak var upcomingteam2Lbl3: UILabel!
    @IBOutlet weak var upcomingdateLbl3: UILabel!
    @IBOutlet weak var upcomingTeam1Lbl3: UILabel!
    @IBOutlet weak var upcomingPredictBtn3: UIButton!
    @IBOutlet weak var upcomingLeagueNameLbl3: UILabel!
    @IBOutlet weak var upcomingLeagueImgView3: UIImageView!
    @IBOutlet weak var upcomingTeam2Lbl2: UILabel!
    @IBOutlet weak var upcomingdateLbl2: UILabel!
    @IBOutlet weak var upcomingTeam1Lbl2: UILabel!
    @IBOutlet weak var upcomingPredictBtn2: UIButton!
    @IBOutlet weak var upcomingLeagueNameLbl2: UILabel!
    @IBOutlet weak var upcomingLeagueImgView2: UIImageView!
    @IBOutlet weak var upcomingTeam2Lbl1: UILabel!
    @IBOutlet weak var upcomingdateLbl1: UILabel!
    @IBOutlet weak var upcomingTeam1Lbl1: UILabel!
    @IBOutlet weak var upcomingPredictBtn1: UIButton!
    @IBOutlet weak var upcomingLeagueNameLbl1: UILabel!
    @IBOutlet weak var upcomingLeagueImgView1: UIImageView!
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var upcomingMatchesLbl: UILabel!
    @IBOutlet weak var sportsSelectionView: UIView!
    @IBOutlet weak var predictionTopView: TopView!
    
    var sportsArr = ["FootBall" , "BasketBall"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func configureView() {
        loadFunctionality()
        
    }
    
    func loadFunctionality() {
        nibInitialization()
    }
    
    func nibInitialization() {
      //  sportsCollectionView.register(CellIdentifier.leagueNamesCollectionCell)
       
    }

}

/*extension HomePredictionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
        cell.leagueName.text = sportsArr[indexPath.row]
        return cell
    }
    
    
}*/
