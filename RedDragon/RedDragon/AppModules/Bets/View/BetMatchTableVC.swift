//
//  BetMatchTableVC.swift
//  RedDragon
//
//  Created by Qoo on 15/11/2023.
//

import UIKit

class BetMatchTableVC: UITableViewCell {
    
    @IBOutlet var imgLeague: UIImageView!
    @IBOutlet var oddsLable3: UILabel!
    @IBOutlet var oddsLable2: UILabel!
    @IBOutlet var oddsLable1: UILabel!
    @IBOutlet var awayName: UILabel!
    @IBOutlet var homeName: UILabel!
    @IBOutlet var imgHome: UIImageView!
    @IBOutlet var imgAway: UIImageView!
    @IBOutlet var score: UILabel!
    @IBOutlet var dateLable: UILabel!
    @IBOutlet var leagueLable: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // for all match
    func configurCell(match: MatchesList, isLive : Bool){
        
        leagueLable.text = match.league
        imgLeague.setImage(imageStr: match.logo ?? "", placeholder: UIImage(named: ImageConstants.placeHolderTeam))
        homeName.text = match.matches?.first?.homeTeam
        awayName.text = match.matches?.first?.awayTeam
        guard let matchs = match.matches?.first else{
            return
        }
        if (matchs.odds1Value ?? "" == "") {
            oddsLable1.text = "1"
        }else{
            oddsLable1.text = matchs.odds1Value ?? "1"
        }
        
        if (matchs.odds2Value ?? "" == "") {
            oddsLable2.text = "1"
        }else{
            oddsLable2.text = matchs.odds2Value ?? "1"
        }
        
        if (matchs.odds3Value ?? "" == "") {
            oddsLable3.text = "1"
        }else{
            oddsLable3.text = matchs.odds3Value ?? "1"
        }
        
        if isLive{
            dateLable.text = "Live".localized
            score.text = "\(matchs.homeScore ?? "0") : \(matchs.awayScore ?? "0")"
        }else{
            dateLable.text = getDate(slug: (matchs.slug)!, time: (matchs.time)!)
        }
    }
    
    // for live matches
    func configureCell(match: Matches, isLive : Bool, league : MatchesList?){
        imgLeague.setImage(imageStr: league?.logo ?? "", placeholder: UIImage(named: ImageConstants.placeHolderTeam))
        leagueLable.text = league?.league
        homeName.text = match.homeTeam
        awayName.text = match.awayTeam
        if (match.odds1Value ?? "" == "") {
            oddsLable1.text = "1"
        }else{
            oddsLable1.text = match.odds1Value ?? "1"
        }
        
        if (match.odds2Value ?? "" == ""){
            oddsLable2.text = "1"
        }else{
            oddsLable2.text = match.odds2Value ?? "1"
        }
        
        if (match.odds3Value ?? "" == ""){
            oddsLable3.text = "1"
        }else{
            oddsLable3.text = match.odds3Value ?? "1"
        }

        if isLive{
            dateLable.text = match.matchState
            score.text = "\(match.homeScore ?? "0") : \(match.awayScore ?? "0")"
        }else{
            dateLable.text = getDate(slug: (match.slug)!, time: (match.time)!)
        }
    }
    
    
    func getDate(slug : String, time : String) ->  String{
        var date = ""
     
        let result = slug.split(separator: "-")
        date = "\(result[0])-\(result[1])-\(result[2])"
        
        date = "\(date) \(time)"
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = dateFormat.yyyyMMddHHmm.rawValue
        date = formatDate(date: dateFormate.date(from: date), with: dateFormat.edmmmHHmm)
        return date
    }
}
