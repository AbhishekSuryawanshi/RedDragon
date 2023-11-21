//
//  PlaceBetVc.swift
//  RedDragon
//
//  Created by Qoo on 20/11/2023.
//

import UIKit

class PlaceBetVc: UIViewController {
    
    @IBOutlet var estWinAmount: UILabel!
    @IBOutlet var amountPlaced: UILabel!
    @IBOutlet var etAmount: UITextField!
    @IBOutlet var imgLeague: UIImageView!
    @IBOutlet var oddsLable3: UILabel!
    @IBOutlet var oddsLable2: UILabel!
    @IBOutlet var oddsLable1: UILabel!
    @IBOutlet var awayName: UILabel!
    @IBOutlet var homeName: UILabel!
    @IBOutlet var imgHome: UIImageView!
    @IBOutlet var imgAway: UIImageView!
    @IBOutlet var score: UILabel!
    @IBOutlet var leagueLable: UILabel!
    
    var betItem : Matches?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setValues()
    }
    

    func setValues(){
        
        guard let match = betItem else{
            return
        }
        leagueLable.text = match.matchState
        homeName.text = match.homeTeam
        awayName.text = match.awayTeam
        if (match.odds1Value!.isEmpty) {
            oddsLable1.text = "1"
        }else{
            oddsLable1.text = match.odds1Value ?? "1"
        }
        
        if (match.odds2Value!.isEmpty){
            oddsLable2.text = "1"
        }else{
            oddsLable2.text = match.odds2Value ?? "1"
        }
        
        if (match.odds3Value!.isEmpty){
            oddsLable3.text = "1"
        }else{
            oddsLable3.text = match.odds3Value ?? "1"
        }
        score.text = "\(match.homeScore ?? "0") : \(match.awayScore ?? "0")"
      
        
    }
   
    @IBAction func placeBet(_ sender: Any) {
        
    }
    
}
