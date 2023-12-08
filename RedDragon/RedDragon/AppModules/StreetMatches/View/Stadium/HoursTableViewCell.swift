//
//  HoursTableViewCell.swift
//  Area Sports
//
//  Created by Remya on 9/30/23.
//

import UIKit
import Toast

class HoursTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    var isFrom = false
    var passTime:((String,Bool)->Void)?
    var callDelete:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtFrom.delegate = self
        txtTo.delegate = self
        txtFrom.placeholder = "From".localized
        txtTo.placeholder = "To".localized
    }
    
    func configureCell(obj:LocalTimings?){
        lblDay.text = obj?.day
        txtFrom.text = obj?.from
        txtTo.text = obj?.to
    }
    
    @IBAction func actionDelete(){
        txtFrom.text = ""
        txtTo.text = ""
        callDelete?()
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension HoursTableViewCell:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == txtFrom{
            isFrom = true
        }
        else{
            isFrom = false
        }
        pickTime()
        
    }
    
    func pickTime(){
        let vc = UIStoryboard(name: StoryboardName.streetMatches, bundle: nil).instantiateViewController(withIdentifier: "TimeViewController") as! TimeViewController
        vc.delg = self
        self.parentContainerViewController()!.present(vc, animated: true, completion: nil)
    }
}


extension HoursTableViewCell:TimeSelectionDelegate{
    func passTime(time:String){
        if !checkValidity(time:time){
            return
        }
        if isFrom{
            txtFrom.text = time
        }
        else{
            txtTo.text = time
        }
        passTime?(time,isFrom)
    }
    
}


extension HoursTableViewCell{
    
    func checkValidity(time:String)->Bool{
        if (txtFrom.text == "") && (txtTo.text == ""){
            return true
        }
        var time1 = ""
        var time2 = ""
        
        if isFrom{
            time1 = time
            time2 = txtTo.text ?? ""
        }
        else{
            time1 = txtFrom.text ?? ""
            time2 = time
        }
        if time1 == "" || time2 == ""{
            return true
        }
        if findDateDiff(time1Str: time1, time2Str: time2) <= 0{
            self.makeToast("Upper time range must be greater than lower time range".localized)
            return false
        }
        else{
            return true
        }
    }
    
    func findDateDiff(time1Str: String, time2Str: String) -> Int {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm a"
        
        guard let time1 = timeformatter.date(from: time1Str),
              let time2 = timeformatter.date(from: time2Str) else { return 0 }
        
        let interval = time2.timeIntervalSince(time1)
        return Int(interval)
        
    }
}
