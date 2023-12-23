//
//  ForYouLiveMatchTableViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 21/12/2023.
//

import UIKit

class ForYouLiveMatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayImageView: UIImageView!
    @IBOutlet weak var awayNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeYellowCountLabel: UILabel!
    @IBOutlet weak var awayYellowCountLabel: UILabel!
    @IBOutlet weak var cornerLabel: UILabel!
    @IBOutlet weak var winDrawLabel: UILabel!
    @IBOutlet weak var halfTimeLabel: UILabel!
    @IBOutlet weak var oddsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeYellowCard: UIView!
    @IBOutlet weak var awayYellowCard: UIView!
    @IBOutlet weak var dateTimeViewWeight: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.borderColor = UIColor(red: 216/255, green: 194/255, blue: 190/255, alpha: 1)
        backView.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
        
}
