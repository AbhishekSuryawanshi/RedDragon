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
    
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var trendingTopicLabel: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagCVHeightConstraint: NSLayoutConstraint!
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
    var tagsArray: [String] = []
    var leagueArray: [SocialLeague] = []
    var teamArray: [SocialTeam] = []
    var refreshLeagueList = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPage()
    }
    
    func initialSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHashTagView(notification:)), name: .refreshHashTags, object: nil)
        nibInitialization()
        fetchSocialViewModel()
        let tagLayout: BaseLayout = TagsCVLayout()
        tagLayout.delegate = self
        tagLayout.contentPadding = ItemsPadding(horizontal: 5, vertical: 5)
        tagLayout.cellsPadding = ItemsPadding(horizontal: 5, vertical: 5)
        tagCollectionView.collectionViewLayout = tagLayout
    }
    
    func refreshPage() {
        self.tabBarController?.tabBar.isHidden = false
        headerCollectionView.reloadData()
        headerCVLeadingConstraint.constant = 60
        loadFunctionality()
        trendingTopicLabel.text = "Trending Topics".localized
        leagueLabel.text = "Leagues".localized
        teamLabel.text = "Teams".localized
        createPostButton.setTitle("Create a Post".localized, for: .normal)
        searchTextField.placeholder = "Search".localized
    }
    
    func loadFunctionality() {
        tagView.isHidden = true
        startLoader()
        ViewEmbedder.embed(withIdentifier: "PostListVC", storyboard: UIStoryboard(name: StoryboardName.social, bundle: nil)
                           , parent: self, container: postContainerView) { vc in
            let vc = vc as! PostListVC
            vc.delegate = self
        }
       
        if refreshLeagueList {
            refreshLeagueList = false
            if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
                SocialLeagueVM.shared.fetchLeagueListAsyncCall()
            } else {
                SocialPublicLeagueVM.shared.fetchLeagueListAsyncCall()
            }
        } else {
            leagueCollectionView.reloadData()
            teamsCollectionView.reloadData()
        }
    }
    
    func nibInitialization() {
        tagCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        headerCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        leagueCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
        teamsCollectionView.register(CellIdentifier.iconNameCollectionViewCell)
    }
    
    @objc func refreshHashTagView(notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            let hashTags = dict["data"] as? [String] ?? []
            tagsArray = hashTags
            tagCollectionView.reloadData()
            tagCollectionView.layoutIfNeeded()
            tagCVHeightConstraint.constant = tagCollectionView.contentSize.height
            tagView.isHidden = tagsArray.count == 0
            if tagCVHeightConstraint.constant > 150.0 {
                tagCVHeightConstraint.constant = 150.0
            }
        }
    }
    
    func searchData(text: String) {
        if text.count > 0 {
            let dataDict:[String: Any] = ["status": true,
                                          "text": searchTextField.text!]
            NotificationCenter.default.post(name: .socialSearch, object: nil, userInfo: dataDict)
            
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
    
    // MARK: - Button Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        tagView.isHidden = true
        
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
        /// search filter page is only for loggined user
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            tagView.isHidden = false
        }
        
        // UIView.transition(with: searchTextField, duration: 3, options: .transitionFlipFromLeft) {
        UIView.animate(withDuration: 3) {
            self.headerCVLeadingConstraint.constant = 60
        }
        searchTextField.text = ""
        let dataDict:[String: Any] = ["status": false]
        NotificationCenter.default.post(name: .socialSearch, object: nil, userInfo: dataDict)
        
        leagueView.isHidden = false
        teamView.isHidden = false
        
        leagueArray = SocialLeagueVM.shared.leagueArray
        leagueCollectionView.reloadData()
        
        teamArray = SocialTeamVM.shared.teamArray
        teamsCollectionView.reloadData()
    }
    
    @IBAction func createPostButtonTapped(_ sender: UIButton) {
        ///This action only for verified logined user
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            navigateToViewController(PostCreateVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom))
        } else {
            self.customAlertView_2Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                /// Show login page to login/register new user
                /// hide tabbar before presenting a viewcontroller
                /// show tabbar while dismissing a presented viewcontroller in delegate
                self.tabBarController?.tabBar.isHidden = true
                self.presentOverViewController(LoginVC.self, storyboardName: StoryboardName.login) { vc in
                    vc.delegate = self
                }
            }
        }
    }
}

// MARK: - API Services
extension SocialVC {
    
    func fetchSocialViewModel() {
        ///fetch league list
        SocialLeagueVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        SocialLeagueVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onLeagueResponseData(response)
            })
            .store(in: &cancellable)
        
        ///fetch public league list
        SocialPublicLeagueVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        SocialPublicLeagueVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                SocialLeagueVM.shared.leagueArray = response ?? []
                self?.leagueArray = SocialLeagueVM.shared.leagueArray
                self?.leagueCollectionView.reloadData()
                SocialPublicTeamVM.shared.fetchTeamListAsyncCall()
            })
            .store(in: &cancellable)
        
        ///fetch team list
        SocialTeamVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        SocialTeamVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onTeamResponseData(response)
            })
            .store(in: &cancellable)
        
        ///fetch public team list
        SocialPublicTeamVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        SocialPublicTeamVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                SocialTeamVM.shared.teamArray = response ?? []
                self?.teamArray = SocialTeamVM.shared.teamArray
                self?.teamsCollectionView.reloadData()
            })
            .store(in: &cancellable)
    }
    
    func execute_onLeagueResponseData(_ response: SocialLeagueResponse?) {
        if let dataResponse = response?.response {
            SocialLeagueVM.shared.leagueArray = dataResponse.data ?? []
            self.leagueArray = dataResponse.data ?? []
            SocialTeamVM.shared.fetchTeamListAsyncCall()
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
        leagueCollectionView.reloadData()
    }
    
    func execute_onTeamResponseData(_ response: SocialTeamResponse?) {
        
        if let dataResponse = response?.response {
            SocialTeamVM.shared.teamArray = dataResponse.data ?? []
            self.teamArray = dataResponse.data ?? []
            self.teamsCollectionView.reloadData()
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
    }
}

// MARK: - CollectionView Delegates
extension SocialVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return tagsArray.count
        } else if collectionView == headerCollectionView {
            return socialHeaderSegment.allCases.count
        } else if collectionView == leagueCollectionView {
            if leagueArray.count == 0 {
                collectionView.setEmptyMessage(ErrorMessage.leaguesEmptyAlert)
            } else {
                collectionView.restore()
            }
            return leagueArray.count
        } else if collectionView == teamsCollectionView {
            if teamArray.count == 0 {
                collectionView.setEmptyMessage(ErrorMessage.teamEmptyAlert)
            } else {
                collectionView.restore()
            }
            return teamArray.count
        } else {
            return socialHeaderSegment.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
            cell.configureTagCell(title: tagsArray[indexPath.row])
            return cell
        } else if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
            cell.configureUnderLineCell(title: socialHeaderSegment.allCases[indexPath.row].rawValue.localized, selected: selectedSegment == socialHeaderSegment.allCases[indexPath.row])
            return cell
        } else if collectionView == leagueCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let model = leagueArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, bgViewCornerRadius: 30, iconCornerRadius: 30, placeHolderImage: .placeholderLeague)
            return cell
        } else if collectionView == teamsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.iconNameCollectionViewCell, for: indexPath) as! IconNameCollectionViewCell
            let model = teamArray[indexPath.row]
            cell.configure(title: UserDefaults.standard.language == "en" ? model.enName : model.cnName, iconName: model.logoURL, imageWidth: (0.7 * 60), bgViewCornerRadius: 30, iconCornerRadius: (0.7 * 60) / 2, placeHolderImage: .placeholderTeam)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerBottom_1CollectionViewCell, for: indexPath) as! HeaderBottom_1CollectionViewCell
            cell.configure(title: socialHeaderSegment.allCases[indexPath.row].rawValue.localized, selected: selectedSegment == socialHeaderSegment.allCases[indexPath.row])
            return cell
        }
    }
}

extension SocialVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView || collectionView == leagueCollectionView || collectionView == teamsCollectionView {
            ///This action only for verified logined user
            if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
                /// Filter post based on search item
                var dataDict:[String: Any] = [:]
                switch collectionView {
                case tagCollectionView:
                    dataDict = ["status": true,
                                "text": tagsArray[indexPath.row]]
                case leagueCollectionView:
                    dataDict = ["status": true,
                                "text": leagueArray[indexPath.row].enName,
                                "text2": leagueArray[indexPath.row].cnName]
                case teamsCollectionView:
                    dataDict = ["status": true,
                                "text": teamArray[indexPath.row].enName,
                                "text2": teamArray[indexPath.row].cnName]
                default:
                    return
                }
                
                self.navigateToViewController(SocialSearchVC.self, storyboardName: StoryboardName.social, animationType: .autoReverse(presenting: .zoom)) { vc in
                    vc.showMatches = collectionView != self.tagCollectionView
                    vc.leagueModel = collectionView == self.leagueCollectionView ? self.leagueArray[indexPath.row] : SocialLeague()
                    vc.teamModel = collectionView == self.teamsCollectionView ? self.teamArray[indexPath.row] : SocialTeam()
                    vc.searchDataDict = dataDict
                }
            } else {
                self.customAlertView_2Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                    /// Show login page to login/register new user
                    /// hide tabbar before presenting a viewcontroller
                    /// show tabbar while dismissing a presented viewcontroller in delegate
                    self.tabBarController?.tabBar.isHidden = true
                    self.presentOverViewController(LoginVC.self, storyboardName: StoryboardName.login) { vc in
                        vc.delegate = self
                    }
                }
            }
        } else {
            selectedSegment = socialHeaderSegment.allCases[indexPath.row]
            collectionView.reloadData()
        }
    }
}

extension SocialVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            let width = tagsArray[indexPath.row].size(OfFont: fontRegular(13)).width
            return CGSize(width: width + 10, height: 26)
        } else if collectionView == headerCollectionView {
            let selected = selectedSegment == socialHeaderSegment.allCases[indexPath.row]
            return CGSize(width: socialHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : selected ? fontBold(17) : fontRegular(17)]).width + 40, height: 50)
        } else if collectionView == leagueCollectionView {
            return CGSize(width: 80, height: 112)
        } else if collectionView == teamsCollectionView {
            return CGSize(width: 80, height: 112)
        } else {
            let selected = selectedSegment == socialHeaderSegment.allCases[indexPath.row]
            return CGSize(width: socialHeaderSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : fontSemiBold(14)]).width + 70, height: 40)
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

// MARK: - Custom Delegates
/// PostListVCDelegate to set the height of view
extension SocialVC: PostListVCDelegate {
    func postList(height: CGFloat, count: Int) {
        containerHeightConstraint.constant = height
        stopLoader()
    }
}
/// LayoutDelegate to set the width of hashtags in its collectionview
extension SocialVC: LayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        let width = tagsArray[indexPath.row].size(OfFont: fontRegular(13)).width
        return CGSize(width: width + 10, height: 26)
    }
}
/// LoginVCDelegate to show hided tabbar and refresh postlist vc
extension SocialVC: LoginVCDelegate {
    func viewControllerDismissed() {
        refreshLeagueList = true
        refreshPage()
    }
}
