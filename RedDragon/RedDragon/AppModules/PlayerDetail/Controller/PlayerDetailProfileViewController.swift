//
//  PlayerDetailProfileViewController.swift
//  RedDragon
//
//  Created by Ali on 11/13/23.
//

import UIKit
import DDSpiderChart

class PlayerDetailProfileViewController: UIViewController {
    
    @IBOutlet weak var playerMediaDetails: MediaView!
    @IBOutlet weak var playerLastMatches: LastMatchesView!
    @IBOutlet weak var playerSkillView: SpiderChartView!
    @IBOutlet weak var playerStatsView: PlayerStatsView!
    @IBOutlet weak var playerTeamsView: TeamsView!
    @IBOutlet weak var playerDetailView: PlayerDetailView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chart()
    }
    

    func chart(){
        let spiderChartView = DDSpiderChartView(frame: CGRect(x: 10, y: 51, width: 373, height: 350)) // Replace with some frame or add constraints
        spiderChartView.axes = ["Defending", "Passing", "Attacking", "Aggressive", "Possessive"] // Set axes by giving their labels
        spiderChartView.addDataSet(values: [1.0, 0.5, 0.75, 0.6, 0.3], color: UIColor.yellow1 ) // Add first data set
      //  spiderChartView.addDataSet(values: [0.9, 0.7, 0.75, 0.7], color: .blue) // Add second data set
        playerSkillView.spiderView.backgroundColor = .clear
        playerSkillView.backgroundColor = .clear
        playerSkillView.addSubview(spiderChartView)
    }

}
