//
//  ProfileVC.swift
//  RedDragon
//
//  Created by Qasr01 on 22/12/2023.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var historicalTagCollectionView: UICollectionView!
    
    let user = UserDefaults.standard.user
    var profileArray: [SettingType] = [.name, .userName, .email, .phone, .password, .gender, .dob, .location]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerLabel.text = "Profile".localized
       // listTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func initialSettings() {
        nibInitialization()
        photoImageView.setImage(imageStr: user?.profileImg ?? "", placeholder: .placeholderUser)
        nameLabel.text = user?.name ?? ""
    }

    func nibInitialization() {
        tagsCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        historicalTagCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
    }
    
    func getProfileValue(type: SettingType) -> String {
        switch type {
        case .name:
            return user?.name ?? ""
        case .userName:
            return user?.username ?? ""
        case .email:
            return user?.email ?? ""
        case .phone:
            return user?.phoneNumber ?? ""
        case .gender:
            return user?.gender ?? ""
        case .dob:
            return user?.dob ?? ""
        case .location:
            return user?.locationName ?? ""
        default:
            return ""
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        
    }
}

// MARK: - TableView Delegates
extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.profileTableViewCell, for: indexPath) as! ProfileTableViewCell
        cell.titleLabel.text = profileArray[indexPath.row].rawValue.localized
        cell.valueLabel.text = getProfileValue(type: profileArray[indexPath.row])
        return cell
    }
}

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - CollectionView Delegates
extension ProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tagsCollectionView.isHidden = (user?.tags.count ?? 0) == 0
        historicalTagCollectionView.isHidden = (user?.historicTags.count ?? 0) == 0
        return collectionView == tagsCollectionView ? user?.tags.count ?? 0 : user?.historicTags.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerTopCollectionViewCell, for: indexPath) as! HeaderTopCollectionViewCell
        let text = collectionView == tagsCollectionView ? user?.tags[indexPath.row] ?? "" : user?.historicTags[indexPath.row] ?? ""
        cell.configureTagCell(title: text.capitalized, textColor: collectionView == tagsCollectionView ? .base : .blue2)
        cell.bgView.backgroundColor = collectionView == tagsCollectionView ? .wheat1 : .blue1
        cell.bgView.borderColor = collectionView == tagsCollectionView ? .base : .blue2
        cell.bgView.borderWidth = 1
        cell.bgView.cornerRadius = 13
        return cell
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = collectionView == tagsCollectionView ? user?.tags[indexPath.row] ?? "" : user?.historicTags[indexPath.row] ?? ""
        let TextWidth = text.size(OfFont: fontRegular(13)).width
        return CGSize(width: TextWidth + 20, height: 26)
    }
}
