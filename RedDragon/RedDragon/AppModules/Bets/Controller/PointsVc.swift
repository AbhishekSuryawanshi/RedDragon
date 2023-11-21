//
//  PointsVc.swift
//  RedDragon
//
//  Created by Qoo on 20/11/2023.
//

import UIKit

class PointsVc: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var amountLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(CellIdentifier.pointsItemTableVC)
    }
    

}

extension PointsVc : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.pointsItemTableVC) as! PointsItemTableVC
        
        return cell
    }
    
    
}
