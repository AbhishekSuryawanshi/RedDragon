//
//  StreetMyMatchesViewController.swift
//  RedDragon
//
//  Created by Remya on 12/14/23.
//

import UIKit

class StreetMyMatchesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var matches:[StreetMatch]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    func registerCells(){
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.streetMatchTableViewCell)
    }
    
    func initialSettings(){
        registerCells()
    }
}


extension StreetMyMatchesViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchTableViewCell) as! StreetMatchTableViewCell
        cell.configureCell(obj: matches?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToViewController(StreetMatchesDetailsVC.self, storyboardName: StoryboardName.streetMatches) { vc in
            vc.matchID = self.matches?[indexPath.row].id
        }
    }
}
