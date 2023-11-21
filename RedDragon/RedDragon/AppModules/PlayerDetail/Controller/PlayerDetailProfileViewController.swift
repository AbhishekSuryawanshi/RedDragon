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
    
    var skillArr:[String?] = []
    var skillVal:[String?] = []
    var skillNum: [Float] = []
    
    var playerDetailViewModel: PlayerDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configureView() {
        configurePlayerDetailView()
        configurePlayerTeamDetailView()
        configureChartsView()
        configureLastMatchesView()
        configureMediaView()
        
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
    
    func configureChartsView(){
        for i in 0 ..< (playerDetailViewModel?.responseData?.data?.rating?.count ?? 0){
            skillArr.append("\(playerDetailViewModel?.responseData?.data?.rating?[i].value ?? "") " + "\(playerDetailViewModel?.responseData?.data?.rating?[i].key ?? "")")
            skillVal.append(playerDetailViewModel?.responseData?.data?.rating?[i].value)
        }
       chart()
    }
    
    func chart(){
        let spiderChartView = DDSpiderChartView(frame: CGRect(x: 10, y: 50, width: screenWidth - 20, height: 350)) // Replace with some frame or add constraints
        spiderChartView.axes = skillArr.map{
            attributedAxisLabel($0 ?? "")} // Set axes by giving their labels
        spiderChartView.addDataSet(values: removeCharacterFromString(valArr: skillVal), color: UIColor.yellow1, animated: true) // Add first data set
        spiderChartView.backgroundColor = .white
        playerSkillView.spiderView.color = .gray
        playerSkillView.backgroundColor = .white
        playerSkillView.addSubview(spiderChartView)
    }
    
    func attributedAxisLabel(_ label: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: label, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 14)!]))
        
        return attributedString
    }
    
    @objc func seeAllMatches(){
        navigateToViewController(PlayerDetailMatchesViewController.self, storyboardName: StoryboardName.playerDetail, animationType: .autoReverse(presenting: .zoom))
    }
    
    func configureLastMatchesView(){
        playerLastMatches.seeAllBtn.addTarget(self, action: #selector(seeAllMatches), for: .touchUpInside)
        for var j in 0 ..< (playerDetailViewModel?.responseData?.data?.events?[0].matches?.count ?? 0){
            if j < 1{
                playerLastMatches.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
                playerLastMatches.leagueImgView.sd_setImage(with: URL(string: playerDetailViewModel?.responseData?.data?.events?[0].leagueLogo ?? ""))
                playerLastMatches.leagueNameLbl.text = playerDetailViewModel?.responseData?.data?.events?[0].leagueName
                playerLastMatches.roundLbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].round
                playerLastMatches.team1Lbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].homeName
                playerLastMatches.team2Lbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].awayName
                playerLastMatches.team1ScoreLbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].homeScore
                playerLastMatches.team2ScoreLbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].awayScore
                playerLastMatches.dateLbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].date
                j = j+1
                playerLastMatches.league2ImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
                playerLastMatches.league2ImgView.sd_setImage(with: URL(string: playerDetailViewModel?.responseData?.data?.events?[0].leagueLogo ?? ""))
                playerLastMatches.leagueName2Lbl.text = playerDetailViewModel?.responseData?.data?.events?[0].leagueName
                playerLastMatches.round2Lbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].round
                playerLastMatches.team1Lbl2.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].homeName
                playerLastMatches.team2Lbl2.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].awayName
                playerLastMatches.team1Score2Lbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].homeScore
                playerLastMatches.team2Score2Lbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].awayScore
                playerLastMatches.date2Lbl.text = playerDetailViewModel?.responseData?.data?.events?[0].matches?[j].date
                }
            }
    }
    
    @objc func seeAllMedia(){
        navigateToViewController(PlayerDetailMediaViewController.self, storyboardName: StoryboardName.playerDetail, animationType: .autoReverse(presenting: .zoom))
    }
    
    func configureMediaView(){
        playerMediaDetails.seeAllBtn.addTarget(self, action: #selector(seeAllMedia), for: .touchUpInside)
        for i in 0 ..< (playerDetailViewModel?.responseData?.data?.medias?.count ?? 0){
            playerMediaDetails.mediaImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
            playerMediaDetails.mediaImgView.sd_setImage(with: URL(string: playerDetailViewModel?.responseData?.data?.medias?[i].preview ?? ""))
            playerMediaDetails.dateLbl.text = playerDetailViewModel?.responseData?.data?.medias?[i].date
            playerMediaDetails.mediaDetailTitleLbl.text = playerDetailViewModel?.responseData?.data?.medias?[i].title
            playerMediaDetails.mediaDetailTxtView.text = playerDetailViewModel?.responseData?.data?.medias?[i].subtitle
        }
    }
    
    func removeCharacterFromString(valArr: [String?]) -> [Float]{
        var val = ""
        for i in 0 ..< valArr.count{
            val = valArr[i]?.replacingOccurrences(of: "%", with: "") ?? ""
            skillNum.append(((Float(val) ?? 0.0)/100.0))
        }
        return skillNum

    }

}
