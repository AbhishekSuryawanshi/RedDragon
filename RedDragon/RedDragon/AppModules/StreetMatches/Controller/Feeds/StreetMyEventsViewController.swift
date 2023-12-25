//
//  StreetMyEventsViewController.swift
//  RedDragon
//
//  Created by Remya on 12/15/23.
//

import UIKit

class StreetMyEventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var events:[StreetEvent]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    
    func initialSettings(){
        defineTableViewNibCell(tableView: tableView, cellName: CellIdentifier.feedsTableViewCell)
    }

}

extension StreetMyEventsViewController{
    func didFinishFetch() {
        tableView.reloadData()
    }
}

extension StreetMyEventsViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.feedsTableViewCell) as! FeedsTableViewCell
        cell.configureCell(obj: events?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToViewController(StreetEventDetailsViewController.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.details = self.events?[indexPath.row]
        }
           
        }
    }
    
    
    
