//
//  PlayerDetailMatchesViewController.swift
//  RedDragon
//
//  Created by Ali on 11/7/23.
//

import UIKit

class PlayerDetailMatchesViewController: UIViewController {

    @IBOutlet weak var matchesTableView: UITableView!{
        didSet{
            self.matchesTableView.register("MatchesTableViewCell")
        }
    }
    
    var playerDetailViewModel: PlayerDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configureView() {
        self.matchesTableView.reloadData()
        
    }
    
    
}

extension PlayerDetailMatchesViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchesTableViewCell", for: indexPath)
        return cell
    }
    
    
}
