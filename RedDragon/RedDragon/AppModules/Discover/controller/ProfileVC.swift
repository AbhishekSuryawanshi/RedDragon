//
//  ProfileVC.swift
//  RedDragon
//
//  Created by Qasr01 on 22/12/2023.
//

import UIKit
import Combine

class ProfileVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var historicalTagCollectionView: UICollectionView!
    
    private var cancellable = Set<AnyCancellable>()
    var imageData: Data?
    var user = UserDefaults.standard.user
    var profileArray: [SettingType] = [.name, .userName, .email, .phone, .password, .gender, .dob, .location]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user = UserDefaults.standard.user
        headerLabel.text = "Profile".localized
        photoImageView.setImage(imageStr: user?.profileImg ?? "", placeholder: .placeholderUser)
        nameLabel.text = user?.name ?? ""
        listTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func initialSettings() {
        nibInitialization()
        fetchProfileViewModel()
    }

    func nibInitialization() {
        tagsCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
        historicalTagCollectionView.register(CellIdentifier.headerTopCollectionViewCell)
    }
    
    private func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
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
        showNewImageActionSheet(sourceView: sender)
    }
}

// MARK: - API Services
extension ProfileVC {
    func fetchProfileViewModel() {
        EditProfileVM.shared.showError = { [weak self] error in
            self?.view.makeToast(error, duration: 2.0, position: .center)
        }
        EditProfileVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        EditProfileVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ response: LoginResponse?) {
        if let dataResponse = response?.response {
            if let user = dataResponse.data {
                photoImageView.setImage(imageStr: user.profileImg, placeholder: .placeholderUser)
                UserDefaults.standard.user = user
                UserDefaults.standard.token = user.token
                UserDefaults.standard.budget = Int(user.affAppData?.sportCard?.budget ?? "200000000")
                UserDefaults.standard.score = Int(user.affAppData?.sportCard?.score ?? "0")
            }
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
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
        navigateToViewController(EditProfileVC.self, storyboardName: StoryboardName.discover, animationType: .autoReverse(presenting: .zoom)) { vc in
            vc.settingType = self.profileArray[indexPath.row]
        }
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

//MARK: - ImagePicker Delegate
extension ProfileVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() {}
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        EditProfileVM.shared.updateProfileAsyncCall(parameter: nil, imageName: imageName, imageData: imageData)
    }
}

