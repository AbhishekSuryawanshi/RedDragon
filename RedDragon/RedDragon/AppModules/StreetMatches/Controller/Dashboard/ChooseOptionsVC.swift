//
//  ChooseOptionsVC.swift
//  RedDragon
//
//  Created by Remya on 11/29/23.
//

import UIKit

class ChooseOptionsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
