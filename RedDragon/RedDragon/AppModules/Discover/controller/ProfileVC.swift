//
//  ProfileVC.swift
//  RedDragon
//
//  Created by Qasr01 on 22/12/2023.
//

import UIKit

class ProfileVC: UIViewController {

    var profileArray: [SettingType] = [.name, .userName, .email, .phone, .password, .gender, .dob, .location]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        return cell
    }
}

extension ProfileVC: UITableViewDelegate {
    
}
