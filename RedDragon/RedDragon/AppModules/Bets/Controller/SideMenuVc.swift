//
//  SideMenuVc.swift
//  RedDragon
//
//  Created by Qoo on 14/11/2023.
//

import UIKit

class SideMenuVc: UIViewController {
    
    var viewModel = BetMatchesHomeViewModel()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initial()
    }

    func initial(){
        lblTitle.text = "Choose Your Sport".localized
        tableView.register(CellIdentifier.menuItemTableVC)
        
        switch(UserDefaults.standard.sport?.lowercased() ?? Sports.football.title.lowercased()){
        case Sports.football.title.lowercased():
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        case Sports.basketball.title.lowercased():
            tableView.selectRow(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .none)
        case Sports.tennis.title.lowercased():
            tableView.selectRow(at: IndexPath(row: 2, section: 0), animated: true, scrollPosition: .none)
        case Sports.handball.title.lowercased():
            tableView.selectRow(at: IndexPath(row: 3, section: 0), animated: true, scrollPosition: .none)
        case Sports.hockey.title.lowercased():
            tableView.selectRow(at: IndexPath(row: 4, section: 0), animated: true, scrollPosition: .none)
        case Sports.volleyball.title.lowercased():
            tableView.selectRow(at: IndexPath(row: 5, section: 0), animated: true, scrollPosition: .none)
            
        default:
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        }
    }
}



extension SideMenuVc : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.menuItemTableVC, for: indexPath) as! MenuItemTableVC
        cell.titleLable.text = viewModel.sports[indexPath.row].title
        cell.imgItem.image = viewModel.sports[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.sport = viewModel.sports[indexPath.row].title.lowercased()
        NotificationCenter.default.post(name: .selectedSport, object: nil)
        self.dismiss(animated: true)
    }
    
}
