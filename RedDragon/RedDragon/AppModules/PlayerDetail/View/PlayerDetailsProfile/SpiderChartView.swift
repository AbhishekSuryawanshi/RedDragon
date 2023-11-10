//
//  SpiderChartView.swift
//  RedDragon
//
//  Created by Ali on 11/2/23.
//

import UIKit
import DDSpiderChart

class SpiderChartView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var skillOverviewLbl: UILabel!
    @IBOutlet weak var spiderView: DDSpiderChartView!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("SpiderChartView", owner: self, options: nil)
           contentView.fixInView(self)
       }

}
