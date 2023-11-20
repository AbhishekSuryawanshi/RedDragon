//
//  MatchesListViewController.swift
//  RedDragon
//
//  Created by Qoo on 18/11/2023.
//

import UIKit

class MatchesListViewController: UIViewController {

    var matchesList : [Matches]?
    var isLive : Bool = false
    
   
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titLELABLE: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(CellIdentifier.betMatchTableVC)
    }
    



}

extension MatchesListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.betMatchTableVC) as! BetMatchTableVC
            cell.configureCell(match: matchesList![indexPath.row], isLive: isLive)
            return cell

        
        
    }
    
}
