//
//  LineupViewController.swift
//  RedDragon
//
//  Created by QASR02 on 07/11/2023.
//

import UIKit
import SDWebImage

class LineupViewController: UIViewController {
    
    @IBOutlet weak var gHomeStackView: UIStackView!
    @IBOutlet weak var dHomeStackView: UIStackView!
    @IBOutlet weak var mHomeStackView: UIStackView!
    @IBOutlet weak var fHomeStackView: UIStackView!
    
    @IBOutlet weak var gAwayStackView: UIStackView!
    @IBOutlet weak var dAwayStackView: UIStackView!
    @IBOutlet weak var mAwayStackView: UIStackView!
    @IBOutlet weak var fAwayStackView: UIStackView!
    
    @IBOutlet weak var substituteLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    private var homePlayer_substituteArray: [[String]]?
    private var awayPlayer_substituteArray: [[String]]?
    var stackHomeViews: [UIStackView] = []
    var stackAwayViews: [UIStackView] = []
    let positionIdentifiers = ["G", "D", "M", "F"]
    var homeLineUp: Lineup?
    var awayLineUp: Lineup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
        stackHomeViews = [gHomeStackView, dHomeStackView, mHomeStackView, fHomeStackView].compactMap { $0 }
        stackAwayViews = [gAwayStackView, dAwayStackView, mAwayStackView, fAwayStackView].compactMap { $0 }
        configureLineupView(lineup: homeLineUp, positionIdentifiers: positionIdentifiers, stackViews: stackHomeViews)
        configureLineupView(lineup: awayLineUp, positionIdentifiers: positionIdentifiers, stackViews: stackAwayViews)
    }
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.substituteTableCell)
    }

}

/// __Match Lineup data functionality

extension LineupViewController {
    func configureHomeLineupView(homeLineup: Lineup?) {
        guard let lineup = homeLineup?.playerMain else {
            return
        }
        
        
        //stackViews = [gHomeStackView, dHomeStackView, mHomeStackView, fHomeStackView].compactMap { $0 }
        
        if lineup.isEmpty {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.dataNotFound.localized, image: ImageConstants.alertImage)
        } else {
            homeLineUp = homeLineup
          //  configureLineupView(lineup: homeLineup, positionIdentifiers: positionIdentifiers, stackViews: stackViews)
        }
    }

    func configureAwayLineupView(awayLineup: Lineup?) {
        guard let lineup = awayLineup?.playerMain else {
            return
        }
        
        let positionIdentifiers = ["G", "D", "M", "F"]
        let stackViews: [UIStackView] = [gAwayStackView, dAwayStackView, mAwayStackView, fAwayStackView].compactMap { $0 }
        
        if lineup.isEmpty {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.dataNotFound.localized, image: ImageConstants.alertImage)
        } else {
            awayLineUp = awayLineup
         //   configureLineupView(lineup: awayLineup, positionIdentifiers: positionIdentifiers, stackViews: stackViews)
        }
    }

    func configureLineupView(lineup: Lineup?, positionIdentifiers: [String], stackViews: [UIStackView]) {
        guard let lineupData = lineup?.playerMain else { return }
        
        for (index, stackView) in stackViews.enumerated() {
            let positionIdentifier = positionIdentifiers[index]
            
            let filteredData = lineupData.filter { $0[4].contains(positionIdentifier) }
            let imageNames = filteredData.map { $0[2] }
            let slugs = filteredData.map{$0[1]}
            
            createViews(viewCount: filteredData.count, imageNames: imageNames, stackView: stackView, slugs: slugs)
        }
    }

    func createViews(viewCount: Int, imageNames: [String], stackView: UIStackView, slugs:[String]) {
        // Remove any existing views from the stack view
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        // Create and add new views with different images to the stack view
        for i in 0..<viewCount {
            let newView = UIView()
            newView.backgroundColor = UIColor.clear
            
            // Create UIImageView with different image and add it to the view
            let imageName = i < imageNames.count ? imageNames[i] : "defaultImage" // Use a default image if the array is shorter
            let imageView = UIImageView()
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            imageView.sd_setImage(with: URL(string: imageName))
            imageView.contentMode = .scaleAspectFit
            newView.addSubview(imageView)
            
            // Set fixed width and height constraints for the view
            newView.translatesAutoresizingMaskIntoConstraints = false
            newView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            newView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            // Set constraints for the UIImageView to fill the entire newView
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: newView.centerYAnchor).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            newView.setOnClickListener {
                self.navigateToViewController(PlayerDetailViewController.self, storyboardName: StoryboardName.playerDetail) { [self] vc in
                    vc.playerSlug = slugs[i]
                    
                }
               // self.presentToStoryboard("PlayerDetail", identifier: "PlayerDetailViewController")
            }
            
            // Add the new view to the stack view
            stackView.addArrangedSubview(newView)
        }
    }
}

/// __Match player substitute data  functionality

extension LineupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureSubstitutePlayer(homeSubstituteData: Lineup?, awaySubstituteData: Lineup?) {
        homePlayer_substituteArray = homeSubstituteData?.playerSubstitute
        awayPlayer_substituteArray = awaySubstituteData?.playerSubstitute
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return homePlayer_substituteArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.substituteTableCell, for: indexPath) as! SubstituteTableViewCell
        // Check if homePlayer_substituteArray is not nil and has elements
        if let homePlayerSubstituteArray = homePlayer_substituteArray,
           indexPath.row < homePlayerSubstituteArray.count {
            let player = homePlayerSubstituteArray[indexPath.row]
            
            // Check if the player's image URL is not nil
            if let imageURLString = player.indices.contains(2) ? player[2] : nil,
               let imageURL = URL(string: imageURLString) {
                cell.homePlayerImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.homePlayerImageView.sd_setImage(with: imageURL)
            }
            
            cell.homePlayerNameLabel.text = player[3]
            cell.homePlayerNumberLabel.text = "No \(player[0])"
        }
        
        // Check if awayPlayer_substituteArray is not nil and has elements
        if let awayPlayerSubstituteArray = awayPlayer_substituteArray,
           indexPath.row < awayPlayerSubstituteArray.count {
            let player = awayPlayerSubstituteArray[indexPath.row]
            
            // Check if the player's image URL is not nil
            if let imageURLString = player.indices.contains(2) ? player[2] : nil,
               let imageURL = URL(string: imageURLString) {
                cell.awayPlayerImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.awayPlayerImageView.sd_setImage(with: imageURL)
            }
            
            cell.awayPlayerNameLabel.text = player[3]
            cell.awayPlayerNumberLabel.text = "No \(player[0])"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animateTabelCell(tableView, willDisplay: cell, forRowAt: indexPath)
        tableViewHeight.constant = self.tableView.contentSize.height
    }
}
