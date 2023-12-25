//
//  PointsItemTableVC.swift
//  RedDragon
//
//  Created by Qoo on 20/11/2023.
//

import UIKit

class PointsItemTableVC: UITableViewCell {
    
    
    @IBOutlet var statusLable: UILabel!
    @IBOutlet var amountLable: UILabel!
    @IBOutlet var dateLable: UILabel!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var imgStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(transaction : Transaction?){
        titleLable.text = transaction?.message
        guard var amount = Double(transaction?.amount ?? "0") else { return }
        
        if  amount > 1 {
            imgStatus.image = .doubleArrowDown
            amountLable.text = "\(amount)"
        }else{
            imgStatus.image = .doubleArrowUp
            amountLable.text = "\(amount)"
        }
        
        let dateFormats = DateFormatter()
        dateFormats.dateFormat = dateFormat.yyyyMMddHHmmss.rawValue
        dateLable.text = dateFormats.date(from: transaction?.created ?? "")!.formatDate(outputFormat: dateFormat.ddMMyyyyHHmm)
        
    }
    
}
