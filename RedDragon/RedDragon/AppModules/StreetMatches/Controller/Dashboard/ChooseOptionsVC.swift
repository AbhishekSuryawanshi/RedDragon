//
//  ChooseOptionsVC.swift
//  RedDragon
//
//  Created by Remya on 11/29/23.
//

import UIKit

class ChooseOptionsVC: UIViewController {
    
    @IBOutlet weak var fixedLblScheduleMatch: UILabel!
    @IBOutlet weak var fixedLblLookingTeams: UILabel!
    @IBOutlet weak var fixedLblCreatePost: UILabel!
    @IBOutlet weak var fixedLblCreateMatch: UILabel!
    @IBOutlet weak var fixedLblLookingPlayers: UILabel!
    @IBOutlet weak var fixedLblCreateTeam: UILabel!
    @IBOutlet weak var fixedLblCreateStadium: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalisation()
    }
    
    func setupLocalisation(){
        fixedLblScheduleMatch.text = "Schedule a match".localized
        fixedLblLookingTeams.text = "Looking for Teams".localized
        fixedLblCreatePost.text = "Create Post".localized
        fixedLblCreateMatch.text = "Create a Match".localized
        fixedLblLookingPlayers.text = "Looking for Players".localized
        fixedLblCreateTeam.text = "Create a Team".localized
        fixedLblCreateStadium.text = "Create a Stadium".localized
    }
   
    @IBAction func actionTapCreateStadium(_ sender: Any) {
         let nav = self.presentingViewController as? UINavigationController
        let vc = UIStoryboard(name: StoryboardName.streetMatches, bundle: nil).instantiateViewController(withIdentifier: "CreateStadiumVC")
        nav?.pushViewController(vc, animated: true)
        self.dismiss(animated: false)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionTapTeam(_ sender: UITapGestureRecognizer) {
        let nav = self.presentingViewController as? UINavigationController
       let vc = UIStoryboard(name: StoryboardName.streetMatches, bundle: nil).instantiateViewController(withIdentifier: "CreateStreetTeamVC")
       nav?.pushViewController(vc, animated: true)
        self.dismiss(animated: false)
    }
    
    
    @IBAction func actionTapCreateMatch(_ sender: Any) {
        let nav = self.presentingViewController as? UINavigationController
       let vc = UIStoryboard(name: StoryboardName.streetMatches, bundle: nil).instantiateViewController(withIdentifier: "CreateStreetMatchVC")
       nav?.pushViewController(vc, animated: true)
        self.dismiss(animated: false)
    }
    
    //StreetCreateEventsVC
    
    @IBAction func actionTapPlayers(_ sender: Any) {
        let nav = self.presentingViewController as? UINavigationController
       let vc = UIStoryboard(name: StoryboardName.streetMatches, bundle: nil).instantiateViewController(withIdentifier: "StreetCreateEventsVC") as! StreetCreateEventsVC
        vc.feedType = .searchPlayer
        vc.titleStr = "Looking for Players".localized
       nav?.pushViewController(vc, animated: true)
        self.dismiss(animated: false)
    }
    
    
    @IBAction func actionTapTeams(_ sender: Any) {
        let nav = self.presentingViewController as? UINavigationController
       let vc = UIStoryboard(name: StoryboardName.streetMatches, bundle: nil).instantiateViewController(withIdentifier: "StreetCreateEventsVC") as! StreetCreateEventsVC
        vc.feedType = .searchTeam
        vc.titleStr = "Looking for Teams".localized
       nav?.pushViewController(vc, animated: true)
        self.dismiss(animated: false)
    }
    
   
    @IBAction func actionTapMatches(_ sender: Any) {
        
        let nav = self.presentingViewController as? UINavigationController
       let vc = UIStoryboard(name: StoryboardName.streetMatches, bundle: nil).instantiateViewController(withIdentifier: "StreetCreateEventsVC") as! StreetCreateEventsVC
        vc.feedType = .challengeTeam
        vc.titleStr = "Schedule a match".localized
       nav?.pushViewController(vc, animated: true)
        self.dismiss(animated: false)
    }
}
