//
//  ExploreUserVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit
import SDWebImage

class ExploreUsersVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var users = [MeetUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }

    // MARK: - Methods
    func performInitialSetup() {
        nibInitialization()
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.meetUserTableViewCell)
    }
    
    func configureUsers(users: [MeetUser]) {
        self.users = users
    }
}

extension ExploreUsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCell(indexPath: indexPath)
    }
    
}

extension ExploreUsersVC {
    private func tableCell(indexPath:IndexPath) -> MeetUserTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.meetUserTableViewCell, for: indexPath) as! MeetUserTableViewCell
        cell.nameLabel.text = users[indexPath.row].name ?? ""
        cell.locationLabel.text = users[indexPath.row].location ?? ""
        cell.profileImageView.sd_setImage(with: URL(string: users[indexPath.row].profileImg ?? ""), placeholderImage: UIImage(named: "placeholderUser"))
        cell.detailButton.addTarget(self, action: #selector(detailButtonTapped(sender:)), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)
        cell.dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func detailButtonTapped(sender: UIButton) {
        
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        
    }
    
    @objc func dislikeButtonTapped(sender: UIButton) {
        
    }
}
