//
//  LeaderboardViewController.swift
//  RedDragon
//
//  Created by QASR02 on 28/11/2023.
//

import UIKit
import Combine
import SDWebImage

class LeaderboardViewController: UIViewController {
    
    var leaderboardVM: LeaderboardViewModel?
    var cancellable = Set<AnyCancellable>()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstUserImage: UIImageView!
    @IBOutlet weak var firstUserNameLabel: UILabel!
    @IBOutlet weak var firstUserScoreLabel: UILabel!
    @IBOutlet weak var firstUserBalanceLabel: UILabel!
    
    @IBOutlet weak var secondUserImage: UIImageView!
    @IBOutlet weak var secondUserNameLabel: UILabel!
    @IBOutlet weak var secondUserScoreLabel: UILabel!
    @IBOutlet weak var secondUserBalanceLabel: UILabel!
    
    @IBOutlet weak var thirdUserImage: UIImageView!
    @IBOutlet weak var thirdUserNameLabel: UILabel!
    @IBOutlet weak var thirdUserScoreLabel: UILabel!
    @IBOutlet weak var thirdUserBalanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
        loadFunctionality()
    }
    
    func nibInitialization() {
        tableView.register(CellIdentifier.leaderboardCell)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func playerButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func teamButton(_ sender: Any) {
        presentToViewController(CardGameMyTeamVC.self, storyboardName: StoryboardName.cardGame)
    }
    
    func loadFunctionality() {
        addActivityIndicator()
        fetchLeaderBoardViewModel()
    }
    
    private func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    private func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }

}

/// __Make network call and fetch view model
extension LeaderboardViewController {
    private func fetchLeaderBoardViewModel() {
        leaderboardVM = LeaderboardViewModel()
        leaderboardVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        leaderboardVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        leaderboardVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                print(data as Any)
                self?.tableView.reloadData()
                self?.firstThreeUsersData(data: data)
            })
            .store(in: &cancellable)
        
        makeNetworkCall()
    }
    
    private func makeNetworkCall() {
        leaderboardVM?.fetchLeaderboardListAsyncCall()
    }
    
    private func firstThreeUsersData(data: Leaderboard?) {
        guard let leader = data else {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.dataNotFound.localized, image: ImageConstants.alertImage)
            return
        }
        let sortedLeaderboard = leader.sorted { $0.score > $1.score }
        guard sortedLeaderboard.count >= 3 else {
            return
        }
        
        firstUserImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        firstUserImage.sd_setImage(with: URL(string: sortedLeaderboard[0].imgURL))
        firstUserNameLabel.text = sortedLeaderboard[0].name
        firstUserScoreLabel.text = "\(StringConstants.score.localized) \(sortedLeaderboard[0].score)"
        firstUserBalanceLabel.text = formatNumber(Double(sortedLeaderboard[0].budget))
        
        secondUserImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        secondUserImage.sd_setImage(with: URL(string: sortedLeaderboard[1].imgURL))
        secondUserNameLabel.text = sortedLeaderboard[1].name
        secondUserScoreLabel.text = "\(StringConstants.score.localized) \(sortedLeaderboard[1].score)"
        secondUserBalanceLabel.text = formatNumber(Double(sortedLeaderboard[1].budget))
        
        thirdUserImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        thirdUserImage.sd_setImage(with: URL(string: sortedLeaderboard[2].imgURL))
        thirdUserNameLabel.text = sortedLeaderboard[2].name
        thirdUserScoreLabel.text = "\(StringConstants.score.localized) \(sortedLeaderboard[2].score)"
        thirdUserBalanceLabel.text = formatNumber(Double(sortedLeaderboard[2].budget))
    }
}

/// __Load Tableview data
extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardVM?.responseData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = leaderboardVM?.responseData else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.leaderboardCell, for: indexPath) as! LeaderboardTableViewCell
        cell.configuaration(data[indexPath.row])
        cell.levelNumberLabel.text = formatNumber(Double(data[indexPath.row].budget))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        navigateToViewController(LeaderboardDetailViewController.self, storyboardName: Storyboard.leaderboard) { [self] vc in
//            vc.userID = leaderboardViewModel?.filteredLeader[indexPath.row].id ?? leaderboardViewModel?.leaderboardData?[indexPath.row].id ?? 0
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
