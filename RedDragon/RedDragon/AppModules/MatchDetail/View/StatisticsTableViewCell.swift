//
//  StatisticsTableViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 15/11/2023.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var homeProgressView: UIProgressView!
    @IBOutlet weak var awayProgressView: UIProgressView!
    @IBOutlet weak var homeValueLabel: UILabel!
    @IBOutlet weak var awayValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configuration(statics: StatisticDatum) {
        keyLabel.text = statics.key
        homeValueLabel.text = statics.homeValue
        awayValueLabel.text = statics.awayValue
        homeProgressView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        homeProgressView.progressTintColor = .systemBlue
        homeProgressView.trackTintColor = UIColor(red: 198/255, green: 231/255, blue: 255/255, alpha: 1)
        awayProgressView.trackTintColor = UIColor(red: 255/255, green: 218/255, blue: 213/255, alpha: 1)
        homeProgressView.setProgress(Float(statics.homePercent) / 100.0, animated: true)
        awayProgressView.setProgress(Float(statics.awayPercent) / 100.0, animated: true)
    }
    
}
