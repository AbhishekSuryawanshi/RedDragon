//
//  BetMatchTableVC.swift
//  RedDragon
//
//  Created by Qoo on 15/11/2023.
//

import UIKit

class BetMatchTableVC: UITableViewCell {
    
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
    
    func configurCell(match: MatchesList){
        
        leagueLable.text = match.league
        homeName.text = match.matches?.first?.homeTeam
        awayName.text = match.matches?.first?.awayTeam
        oddsLable1.text = match.matches?.first?.odds1Value ?? "0"
        oddsLable2.text = match.matches?.first?.odds2Value ?? "0"
        oddsLable3.text = match.matches?.first?.odds3Value ?? "0"
       // score.text = match.matches?.first?.homeScore ?? "0" + (match.matches?.first?.awayScore ?? "0")
        
        dateLable.text = getDate(slug: (match.matches?.first?.slug)!, time: (match.matches?.first?.time)!)
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
