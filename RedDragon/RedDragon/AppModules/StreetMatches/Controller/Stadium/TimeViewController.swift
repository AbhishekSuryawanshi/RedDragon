//
//  ViewController.swift
//  TimeSelector
//
//  Created by Chris Galzerano on 12/18/18.
//  Copyright © 2018 chrisgalz. All rights reserved.
//

import UIKit

protocol TimeSelectionDelegate{
    //func setSelectedTime(index:Int)
    func passTime(time:String)
}

class TimeViewController: UIViewController {
    
    var delg:TimeSelectionDelegate?
    var index:Int?
    var turn = 0

    override func viewDidLoad() {
        super.viewDidLoad()
       
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPicker()
    }
    
    @objc func showPicker() {
        let timeSelector = TimeSelector()
        timeSelector.timeSelected = {
            (timeSelector) in
            self.setLabelFromDate(timeSelector.date)
        }
        
        timeSelector.timeCancelled = {
            self.dismiss(animated: true, completion: nil)
        }
        timeSelector.overlayAlpha = 0.8
        timeSelector.clockTint = timeSelector_rgb(0, 230, 0)
        
//        testing time
//        let dtestate = Utility.getToday(with: .HHMMWithTime)
//        test finished
        
//
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm:ss aa"
        let Date12 = getToday(with: .hhmmssa)
        let strArr = Date12.components(separatedBy: ":")
        let am = strArr.last?.components(separatedBy: " ").last
        
        let hours = Int(strArr[0]) ?? 0
        let minutes = Int(strArr[1]) ?? 0
        timeSelector.minutes = minutes
        timeSelector.hours = hours
        print("My am::\(am ?? "")")
        if am == "AM"{
            timeSelector.isAm = true
        }
        else{
            timeSelector.isAm = false
        }
        timeSelector.presentOnView(view: self.view)
    }
    
    func setLabelFromDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        let time = formatter.string(from: date)
        delg?.passTime(time: time)
       self.dismiss(animated: true, completion: nil)
       
    }
    
     func getToday(with outputFormat: dateFormat)-> String
    {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = outputFormat.rawValue
        return dateFormatter.string(from: date)
    }
      

}

