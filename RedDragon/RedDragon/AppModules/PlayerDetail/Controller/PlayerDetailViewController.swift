//
//  PlayerDetailViewController.swift
//  RedDragon
//
//  Created by Ali on 11/1/23.
//

import UIKit
import DDSpiderChart

class PlayerDetailViewController: UIViewController {

    @IBOutlet weak var playerSkillView: SpiderChartView!
    @IBOutlet weak var playerStatsView: PlayerStatsView!
    @IBOutlet weak var playerTeamsView: TeamsView!
    @IBOutlet weak var playerDetailView: PlayerDetailView!
    @IBOutlet weak var playerProfileView: PlayerProfileTopView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
