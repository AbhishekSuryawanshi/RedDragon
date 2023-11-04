//
//  SpiderChartView.swift
//  RedDragon
//
//  Created by Ali on 11/2/23.
//

import UIKit
import DDSpiderChart

class SpiderChartView: UIView {

    @IBOutlet weak var skillOverviewLbl: UILabel!
    
    @IBOutlet weak var spiderView: DDSpiderChartView!
    
    func chart(){
        let spiderChartView = DDSpiderChartView(frame: .zero) // Replace with some frame or add constraints
        spiderChartView.axes = ["Axis 1", "Axis 2", "Axis 3", "Axis 4"] // Set axes by giving their labels
        spiderChartView.addDataSet(values: [1.0, 0.5, 0.75, 0.6], color: .red) // Add first data set
        spiderChartView.addDataSet(values: [0.9, 0.7, 0.75, 0.7], color: .blue) // Add second data set
    }
    

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
