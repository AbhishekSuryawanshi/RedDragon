//
//  SocialVC.swift
//  RedDragon
//
//  Created by Qasr01 on 26/10/2023.
//

import UIKit
import Combine

enum socialHeaderSegment: String, CaseIterable {
    case followed = "Followed"
    case recommend = "Recommended"
    case new = "Newest"
}

class SocialVC: UIViewController {
    
    @IBOutlet weak var leagueView: UIView!
    @IBOutlet weak var teamView: UIView!
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerCVLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    
    var selectedSegment: socialHeaderSegment = .followed
    var cancellable = Set<AnyCancellable>()
    var leagueArray: [SocialLeague] = []
    var teamArray: [SocialTeam] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshForLocalization()
    }
    
    func loadFunctionality() {
        //Test User
        var user = User()
        user.id = 4
        user.firstName = "Joe"
        user.lastName = "Titto"
        user.email = "joe@mailinator.com"
        user.image = "http://45.76.178.21:6040/profile-images/99087FBB-6FB9-4B2B-B7D2-3BF4DD51F73320231012100148.png"
        user.token = "70|6ts3zlgn0fjtLYbooHxQniqM6I33vSc5CGXrO5K4"
        UserDefaults.standard.user = user
        UserDefaults.standard.token = user.token
        
        ViewEmbedder.embed(withIdentifier: "PostListVC", storyboard: UIStoryboard(name: StoryboardName.social, bundle: nil)
                           , parent: self, container: postContainerView) { vc in
            let vc = vc as! PostListVC
            vc.delegate = self
        }
        
        self.view.addSubview(Loader.activityIndicator)
        
        nibInitialization()
        fetchSocialViewModel()
        makeNetworkCall()
    }
    
    func refreshForLocalization() {
        headerCVLeadingConstraint.constant = 60
        Loader.activityIndicator.startAnimating()
        self.tabBarController?.tabBar.isHidden = false
        leagueLabel.text = "Leagues".localized
        teamLabel.text = "Teams".localized
        createPostButton.setTitle("Create a Post".localized, for: .normal)
        searchTextField.placeholder = "Search".localized
    }
    
    func nibInitialization() {
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        leagueCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        teamsCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
    }
    
    // MARK: - Button Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if headerCVLeadingConstraint.constant == 60 {
            UIView.animate(withDuration: 3) {
                self.headerCVLeadingConstraint.constant = screenWidth
            }
        } else {
            guard !searchTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            searchTextField.endEditing(true)
            searchData(text: searchTextField.text!)
        }
    }
    @IBAction func searchCloseButtonTapped(_ sender: UIButton) {
        // UIView.transition(with: searchTextField, duration: 3, options: .transitionFlipFromLeft) {
        UIView.animate(withDuration: 3) {
            self.headerCVLeadingConstraint.constant = 60
        }
        searchTextField.text = ""
        let dataDict:[String: Any] = ["status": false]
        NotificationCenter.default.post(name: NSNotification.socialSearchEnable, object: nil, userInfo: dataDict)
        
        leagueView.isHidden = false
        teamView.isHidden = false
        
        leagueArray = SocialLeagueVM.shared.leagueArray
        leagueCollectionView.reloadData()
        
        teamArray = SocialTeamVM.shared.teamArray
        teamsCollectionView.reloadData()
    }
    
    @IBAction func createPostButtonTapped(_ sender: UIButton) {
        
        guard let token = UserDefaults.standard.token else {
            self.customAlertView_2Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                //ToDo
                // self.logoutAndRootToLoginVC()
            }
            return
        }
        navigateToViewController(PostCreateVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom))
    }
}

// MARK: - API Services
extension SocialVC {
    func makeNetworkCall() {
        //        guard Reachability.isConnectedToNetwork() else {
        //            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.networkAlert.localized, image: ImageConstants.alertImage)
        //            return
        //        }
        
        SocialLeagueVM.shared.fetchLeagueListAsyncCall()
    }
    
    func fetchSocialViewModel() {
        ///fetch league list
        SocialLeagueVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialLeagueVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] leagueData in
                SocialLeagueVM.shared.leagueArray = leagueData ?? []
                self?.leagueArray = leagueData ?? []
                self?.leagueCollectionView.reloadData()
                SocialTeamVM.shared.fetchTeamListAsyncCall()
            })
            .store(in: &cancellable)
        
        ///fetch team list
        SocialTeamVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        SocialTeamVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] teamData in
                SocialTeamVM.shared.teamArray = teamData ?? []
                self?.teamArray = teamData ?? []
                self?.teamsCollectionView.reloadData()
            })
            .store(in: &cancellable)
    }
    
    func searchData(text: String) {
        if text.count > 0 {
            let dataDict:[String: Any] = ["status": true,
                                          "text": searchTextField.text!]
            NotificationCenter.default.post(name: NSNotification.socialSearchEnable, object: nil, userInfo: dataDict)
            
            leagueArray = SocialLeagueVM.shared.leagueArray
            leagueArray = leagueArray.filter({(item: SocialLeague) -> Bool in
                if item.enName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                if item.cnName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                return false
            })
            leagueView.isHidden = leagueArray.count == 0 ? true : false
            leagueCollectionView.reloadData()
            
            teamArray = SocialTeamVM.shared.teamArray
            teamArray = teamArray.filter({(item: SocialTeam) -> Bool in
                if item.enName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                if item.cnName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                return false
            })
            teamView.isHidden = teamArray.count == 0 ? true : false
            teamsCollectionView.reloadData()
        }
    }
}

// MARK: - CollectionView Delegates
extension SocialVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return socialHeaderSegment.allCases.count
        } else if collectionView == leagueCollectionView {
            return leagueArray.count
        } else if collectionView == teamsCollectionView {
            return teamArray.count
        } else {
            return socialHeaderSegment.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
            cell.configure(title: socialHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == socialHeaderSegment.allCases[indexPath.row])
            return cell
        } else if collectionView == leagueCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let model = leagueArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, style: .league)
            return cell
        } else if collectionView == teamsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let model = teamArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, style: .team)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerBottom_1CollectionViewCell, for: indexPath) as! HeaderBottom_1CollectionViewCell
            cell.configure(title: socialHeaderSegment.allCases[indexPath.row].rawValue, selected: selectedSegment == socialHeaderSegment.allCases[indexPath.row])
            return cell
        }
    }
}

extension SocialVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == leagueCollectionView || collectionView == teamsCollectionView {
        } else {
            selectedSegment = socialHeaderSegment.allCases[indexPath.row]
            collectionView.reloadData()
        }
    }
}

extension SocialVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            let selected = selectedSegment == socialHeaderSegment.allCases[indexPath.row]
            return CGSize(width: socialHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 40, height: 50)
        } else if collectionView == leagueCollectionView {
            return CGSize(width: 75, height: 112)
        } else if collectionView == teamsCollectionView {
            return CGSize(width: 75, height: 112)
        } else {
            let selected = selectedSegment == socialHeaderSegment.allCases[indexPath.row]
            return CGSize(width: socialHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : fontMedium(15)]).width + 70, height: 40)
        }
    }
}

// MARK: - Custom Delegate
extension SocialVC: PostListVCDelegate {
    func postList(height: CGFloat) {
        containerHeightConstraint.constant = height
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            Loader.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - TextField Delegate
extension SocialVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let searchText = text.replacingCharacters(in: textRange,with: string)
            print("searchText  \(searchText)")
            //  searchData(text: searchText)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //searchData(text: searchTextField.text!)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        //searchData(text: searchTextField.text!)
        return true
    }
}
