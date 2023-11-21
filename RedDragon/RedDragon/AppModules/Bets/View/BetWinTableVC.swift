//
//  BetWinTableVC.swift
//  RedDragon
//
//  Created by Qoo on 16/11/2023.
//

import UIKit

class BetWinTableVC: UITableViewCell {

    @IBOutlet var winLoseAmount: UILabel!
    @IBOutlet var winningLable: UILabel!
    @IBOutlet var oddsLable: UILabel!
    @IBOutlet var valueLable: UILabel!
    @IBOutlet var awayName: UILabel!
    @IBOutlet var homeName: UILabel!
    @IBOutlet var sportLable: UILabel!
    @IBOutlet var dateLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item : BetItem?){
        homeName.text = item?.homeTeam
        awayName.text = item?.awayTeam
        sportLable.text = item?.sport?.capitalized.localized ?? "NA"
        

        guard let betAmountString = item?.betAmount, let betAmount = Float(betAmountString), let oddValueString = item?.betOddValue, let betOddValue = Float(oddValueString) else { return }
        valueLable.text = "\(betAmount)"
        oddsLable.text = "x\(betOddValue)"
        winningLable.text = "\(betAmount * betOddValue)"
        
       
        dateLable.text = item?.betDatetime?.getFormattedDate(from:  dateFormat.yyyyMMddHHmm.rawValue, andConvertTo: dateFormat.mmmdhm.rawValue)
        winLoseAmount.text = "\(item?.betAmount ?? "0")"
  
        
    }
    
}
