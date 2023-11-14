//
//  PlayerDetailProfileViewController.swift
//  RedDragon
//
//  Created by Ali on 11/13/23.
//

import UIKit
import DDSpiderChart
import SDWebImage

class PlayerDetailProfileViewController: UIViewController {
    
    @IBOutlet weak var playerMediaDetails: MediaView!
    @IBOutlet weak var playerLastMatches: LastMatchesView!
    @IBOutlet weak var playerSkillView: SpiderChartView!
    @IBOutlet weak var playerStatsView: PlayerStatsView!
    @IBOutlet weak var playerTeamsView: TeamsView!
    @IBOutlet weak var playerDetailView: PlayerDetailView!
    
    var playerDetailViewModel: PlayerDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configureView() {
        chart()
        configurePlayerDetailView()
        configurePlayerTeamDetailView()
        
    }
    
    func configurePlayerDetailView(){
        playerDetailView.playerDetailTxtView.text = playerDetailViewModel?.responseData?.data?.about
       
    }
    
    func configurePlayerTeamDetailView(){
        playerTeamsView.team1Lbl.text = playerDetailViewModel?.responseData?.data?.playerCountry
        playerTeamsView.team1ImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
       // playerTeamsView.team1ImgView.sd_setImage(with: URL(string: playerDetailViewModel?.responseData?.data?.playerPhoto ?? ""))
        for i in 0 ..< (playerDetailViewModel?.responseData?.data?.indicators?.count ?? 0){
            if playerDetailViewModel?.responseData?.data?.indicators?[i].key == "Player number"{
                playerTeamsView.team1RankLbl.text = playerDetailViewModel?.responseData?.data?.indicators?[i].value
                playerTeamsView.team2RankLbl.text = playerDetailViewModel?.responseData?.data?.indicators?[i].value
            }
            if playerDetailViewModel?.responseData?.data?.indicators?[i].key == "Age"{
                playerStatsView.lbl1.text = (playerDetailViewModel?.responseData?.data?.indicators?[i].value ?? "") + " Years"
            }
            if playerDetailViewModel?.responseData?.data?.indicators?[i].key == "Date of birth"{
                playerStatsView.lbl2.text = playerDetailViewModel?.responseData?.data?.indicators?[i].value
            }
            if playerDetailViewModel?.responseData?.data?.indicators?[i].key == "Height"{
                playerStatsView.lbl3.text = playerDetailViewModel?.responseData?.data?.indicators?[i].value
                playerStatsView.lbl4.text = playerDetailViewModel?.responseData?.data?.indicators?[i].key
                
            }
            if playerDetailViewModel?.responseData?.data?.indicators?[i].key == "Preferred foot"{
                playerStatsView.lbl5.text = playerDetailViewModel?.responseData?.data?.indicators?[i].value
                playerStatsView.lbl6.text = playerDetailViewModel?.responseData?.data?.indicators?[i].key
                
            }
            if playerDetailViewModel?.responseData?.data?.indicators?[i].key == "Market price"{
                playerStatsView.lbl7.text = playerDetailViewModel?.responseData?.data?.indicators?[i].value
                playerStatsView.lbl8.text = playerDetailViewModel?.responseData?.data?.indicators?[i].key
                
            }
            
        }
        
        playerTeamsView.team2ImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        playerTeamsView.team2ImgView.sd_setImage(with: URL(string: playerDetailViewModel?.responseData?.data?.teamPhoto ?? ""))
        playerTeamsView.team2Lbl.text = playerDetailViewModel?.responseData?.data?.teamName
    }
    
   

    func chart(){
        let spiderChartView = DDSpiderChartView(frame: CGRect(x: 10, y: 51, width: 373, height: 350)) // Replace with some frame or add constraints
        spiderChartView.axes = ["Defending", "Passing", "Attacking", "Aggressive", "Possessive"] // Set axes by giving their labels
        spiderChartView.addDataSet(values: [1.0, 0.5, 0.75, 0.6, 0.3], color: UIColor.yellow1 ) // Add first data set
      
        playerSkillView.spiderView.backgroundColor = .clear
        playerSkillView.backgroundColor = .clear
        playerSkillView.addSubview(spiderChartView)
    }

}
