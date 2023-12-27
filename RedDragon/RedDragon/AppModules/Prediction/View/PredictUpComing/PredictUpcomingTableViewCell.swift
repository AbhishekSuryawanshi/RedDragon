//
//  PredictUpcomingTableViewCell.swift
//  RedDragon
//
//  Created by Ali on 11/22/23.
//

import UIKit

class PredictUpcomingTableViewCell: UITableViewCell {

    @IBOutlet weak var predictBtn: UIButton!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var team1Lbl: UILabel!
    var match: PredictionMatch?
    var predictionData: PredictionData?
    var position = 0
    var selectedSports = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(predictionData: PredictionData?, row: Int, sport: String?){
        self.predictionData = predictionData
        self.team1Lbl.text = predictionData?.matches?[row].homeTeam
        self.team2Lbl.text = predictionData?.matches?[row].awayTeam
        self.dateTimeLbl.text = predictionData?.matches?[row].time
        match = predictionData?.matches?[row]
        position = row
        selectedSports = sport ?? "football"
    }
    
    @IBAction func predictBtnAction(_ sender: Any) {
        parentContainerViewController()?.navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction, animationType: .autoReverse(presenting: .zoom), configure: {vc in
            vc.selectedUpComingMatch = self.predictionData
            vc.selectedUpComingPosition = self.position
            vc.sport = self.selectedSports
        })
    }
}
