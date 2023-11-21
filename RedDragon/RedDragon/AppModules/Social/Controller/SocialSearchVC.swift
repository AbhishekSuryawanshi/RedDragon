//
//  SocialSearchVC.swift
//  RedDragon
//
//  Created by Qasr01 on 10/11/2023.
//

import UIKit
import Combine

class SocialSearchVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerSubLabel: UILabel!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoShadowView: UIView!
    @IBOutlet weak var matchView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var matchTitleLabel: UILabel!
    @IBOutlet weak var matchTableView: UITableView!
    @IBOutlet weak var postsContainerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var matchHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeAllButton: UIButton!
    
    var cancellable = Set<AnyCancellable>()
    var allMatchArray: [SocialMatch] = []
    var matchArray: [SocialMatch] = []
    var leagueModel = SocialLeague()
    var teamModel = SocialTeam()
    var showMatches = false
    var searchEnable = true
    var searchDataDict:[String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPage()
    }
    
    func refreshPage() {
        Loader.activityIndicator.startAnimating()
        seeAllButton.isHidden = matchArray.count == 0 ? true : false
    }
    
    func initialSettings() {
        nibInitialization()
        self.view.addSubview(Loader.activityIndicator)
        
        fetchSocialViewModel()
        /// Add hashtag for header label
        headerLabel.text = searchDataDict["text"] as? String ?? ""
        if headerLabel.text?.first != "#" {
            headerLabel.text = "#" + headerLabel.text!
        }
        
        logoView.isHidden = !showMatches
        matchView.isHidden = !showMatches
        logoShadowView.applyShadow(radius: 3, opacity: 0.9, offset: CGSize(width: 1 , height: 1))
        if showMatches {
            if teamModel.id == "" {
                logoImageView.setImage(imageStr: leagueModel.logoURL, placeholder: .placeholderTeam)
            } else {
                logoImageView.setImage(imageStr: teamModel.logoURL, placeholder: .placeholderLeague)
            }
            titleLabel.text = teamModel.id == "" ? (UserDefaults.standard.language == "en" ? leagueModel.enName : leagueModel.cnName) : (UserDefaults.standard.language == "en" ? teamModel.enName : teamModel.cnName)
            matchTitleLabel.text = "Top Matches in " + (teamModel.id == "" ? "Leage" : "Team")
            SocialMatchVM.shared.fetchMatchListAsyncCall(leagueId: leagueModel.id, teamId: teamModel.id)
        } else {
            loadPostsView()
        }
    }
    
    func nibInitialization() {
        matchTableView.register(CellIdentifier.matchTableViewCell)
    }
    
    func loadPostsView() {
        ViewEmbedder.embed(withIdentifier: "PostListVC", storyboard: UIStoryboard(name: StoryboardName.social, bundle: nil)
                           , parent: self, container: postsContainerView) { vc in
            let vc = vc as! PostListVC
            vc.delegate = self
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        if matchArray.count > 3 {
            matchArray = Array(allMatchArray.prefix(3))
            seeAllButton.setImage(.downArrow2, for: .normal)
        } else {
            matchArray = allMatchArray
            seeAllButton.setImage(.upArrow, for: .normal)
        }
        
        matchTableView.reloadData()
    }
}

// MARK: - API Services
extension SocialSearchVC {
    func fetchSocialViewModel() {
        ///fetch match list
        SocialMatchVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        
        SocialMatchVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.allMatchArray = response?.data ?? []
                print("load..... match \(Date())")
                self?.matchArray = Array(self?.allMatchArray.prefix(3) ?? [])
                self?.matchTableView.reloadData()
                self?.loadPostsView()
                self?.seeAllButton.isHidden = self?.matchArray.count == 0 ? true : false
                self?.seeAllButton.setImage(.downArrow2, for: .normal)
                if self?.matchArray.count == 0 {
                    self?.matchTableView.setEmptyMessage(ErrorMessage.matchEmptyAlert)
                } else {
                    self?.matchTableView.restore()
                }
            })
            .store(in: &cancellable)
    }
}

// MARK: - TableView Delegate
extension SocialSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchHeightConstraint.constant = matchArray.count == 0 ? 300 : (CGFloat(matchArray.count * 83) + 50)
        return matchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.matchTableViewCell, for: indexPath) as! MatchTableViewCell
        cell.setCellValues(model: matchArray[indexPath.row])
        return cell
    }
}

extension SocialSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}

// MARK: - Custom Delegate
extension SocialSearchVC: PostListVCDelegate {
    func postList(height: CGFloat, count: Int) {
        headerSubLabel.text = "\(count) " + (count < 2 ? "Post" : "Posts")
        containerHeightConstraint.constant = height
        print("load..... post \(Date())")
        if searchEnable {
            searchEnable = false
            NotificationCenter.default.post(name: NSNotification.socialSearchEnable, object: nil, userInfo: searchDataDict)
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            print("load..... post loader \(Date())")
            Loader.activityIndicator.stopAnimating()
        }
    }
}
