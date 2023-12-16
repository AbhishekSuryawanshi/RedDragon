//
//  GossipSearchVC.swift
//  RedDragon
//
//  Created by Qasr01 on 16/12/2023.
//

import UIKit

class GossipSearchVC: UIViewController {

    @IBOutlet weak var logoShadowView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    var leagueModel = SocialLeague()
    var gossipsArray: [Gossip] = []
    var sportType: SportsType = .football
    var newsSource = "thehindu"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }

    func initialSettings() {
        nibInitialization()
        logoImageView.setImage(imageStr: leagueModel.logoURL, placeholder: .placeholderTeam)
        titleLabel.text = UserDefaults.standard.language == "en" ? leagueModel.enName : leagueModel.cnName
        logoShadowView.applyShadow(radius: 3, opacity: 0.9, offset: CGSize(width: 1 , height: 1))
    }
    
    func nibInitialization() {
        listTableView.register(CellIdentifier.newsTableViewCell)
    }
}

// MARK: - TableView Delegates
extension GossipSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gossipsArray.count == 0 {
            tableView.setEmptyMessage(ErrorMessage.dataNotFound)
        } else {
            tableView.restore()
        }
        return gossipsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newsTableViewCell, for: indexPath) as! NewsTableViewCell
        cell.configureGossipCell(model: gossipsArray[indexPath.row])

        
        
        
        
        

    }
}

extension GossipSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToViewController(GossipDetailVC.self, storyboardName: StoryboardName.gossip, animationType: .autoReverse(presenting: .zoom)) { vc in
            vc.commentSectionID = self.sportType == .eSports ? "eSportsID:-\(self.gossipsArray[indexPath.row].id ?? 0)" : "gossipNewsID:-\(self.gossipsArray[indexPath.row].slug ?? "")"
            vc.gossipModel = self.gossipsArray[indexPath.row]
            vc.sportType = self.sportType
            vc.newsSource = self.newsSource
            
        }
    }
}
