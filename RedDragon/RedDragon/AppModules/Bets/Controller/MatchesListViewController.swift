//
//  MatchesListViewController.swift
//  RedDragon
//
//  Created by Qoo on 18/11/2023.
//

import UIKit

class MatchesListViewController: UIViewController {
    
    var matches : [Matches]?
    var matchesList : MatchesList?
    var isLive : Bool = false
    
    
    @IBOutlet var imgSports: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.register(CellIdentifier.betMatchTableVC)
        imgSports.image = UIImage(named: UserDefaults.standard.sport?.lowercased() ?? Sports.football.title.lowercased())
    }
    
    
}

extension MatchesListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betMatchTableVC) as! BetMatchTableVC
        cell.configureCell(match: matches![indexPath.row], isLive: isLive, league: matchesList)
        return cell
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLive{
            navigateToViewController(PlaceBetVc.self, storyboardName: StoryboardName.bets,  animationType: .autoReverse(presenting: .zoom), configure: { vc in
                vc.betItem = self.matches?[indexPath.row]
                vc.matchesList = self.matchesList
                vc.day = "day"
            })
        }else{
            if self.matches?[indexPath.row].matchState == "live" || self.matches?[indexPath.row].matchState == "notstarted" {
                navigateToViewController(PlaceBetVc.self, storyboardName: StoryboardName.bets,  animationType: .autoReverse(presenting: .zoom), configure: { vc in
                    vc.betItem = self.matches?[indexPath.row]
                    vc.matchesList = self.matchesList
                    vc.day = "tommorow"
                })
            }else{
                self.view.makeToast(ErrorMessage.onlyLiveMatches.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
}
