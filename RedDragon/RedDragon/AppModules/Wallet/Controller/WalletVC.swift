//
//  WalletVC.swift
//  RedDragon
//
//  Created by Qasr01 on 18/12/2023.
//

import UIKit

class WalletVC: UIViewController {
    
    @IBOutlet weak var heatPointTitleLabel: UILabel!
    @IBOutlet weak var heatPointLabel: UILabel!
    @IBOutlet weak var recentTrasactionLabel: UILabel!
    @IBOutlet weak var transactionSeeAllButton: UIButton!
    @IBOutlet weak var subscriptionTableview: UITableView!
    @IBOutlet weak var subscriptionTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var saveUptoLabel: UILabel!
    @IBOutlet weak var firstPointsLabel: UILabel!
    @IBOutlet weak var firstPriceLabel: UILabel!
    @IBOutlet weak var secondPonitsLabel: UILabel!
    @IBOutlet weak var secondPriceLabel: UILabel!
    @IBOutlet weak var thirdPointsLabel: UILabel!
    @IBOutlet weak var thirdPriceLabel: UILabel!
    @IBOutlet weak var fourthPointsLabel: UILabel!
    @IBOutlet weak var fourthPriceLabel: UILabel!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshView()
    }
    
    func refreshView() {
        
    }
}

// MARK: - TableView Delegates
extension WalletVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subscriptionTableHeightConstraint.constant = (5 * 55) + 60
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.subscriptionTableViewCell, for: indexPath) as! SubscriptionTableViewCell
        
        return cell
    }
}

extension WalletVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

