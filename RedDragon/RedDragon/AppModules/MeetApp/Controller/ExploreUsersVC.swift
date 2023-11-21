//
//  ExploreUserVC.swift
//  RedDragon
//
//  Created by iOS Dev on 21/11/2023.
//

import UIKit

class ExploreUsersVC: UIViewController {
    
    var users = [MeetUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func configureUsers(users: [MeetUser]) {
        self.users = users
    }
}
