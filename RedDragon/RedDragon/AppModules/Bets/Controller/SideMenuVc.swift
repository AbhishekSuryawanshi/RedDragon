//
//  SideMenuVc.swift
//  RedDragon
//
//  Created by Qoo on 14/11/2023.
//

import UIKit

class SideMenuVc: UIViewController {
    
    var viewModel = BetsHomeViewModel()
    
    @IBOutlet var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initial()

    }

    func initial(){
        tableView.register(CellIdentifier.menuItemTableVC)
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
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
    
    
    
}
