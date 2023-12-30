//
//  GetPointsVC.swift
//  RedDragon
//
//  Created by Qasr01 on 29/12/2023.
//

import UIKit

enum PointsType {
    case bet
    case heat
}

class GetPointsVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var currentPointLabel: UILabel!
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pointsTableView: UITableView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pointsTableHeightConstraint: NSLayoutConstraint!
    
    var pointType: PointsType = .bet
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialSettings()
    }
    
    func initialSettings() {
        headerLabel.text = pointType == .bet ? "Get Bet Points".localized : "Get Heat Points".localized
        currentPointLabel.text = pointType == .bet ? "\("Current Heat Points".localized): \(UserDefaults.standard.user?.wallet ?? 0)" : "\("Current Bet Points".localized): \(UserDefaults.standard.points ?? "0")"
        descriptionLabel.text = pointType == .bet ? "Convert Heat Points to Bet Points and unleash your inner champion! Choose your package:".localized : "Convert Bet Points to Heat Points and unleash your inner champion! Choose your package:".localized
        cancelButton.setTitle(StringConstants.cancel.localized, for: .normal)
        convertButton.setTitle("Convert Now".localized, for: .normal)
    }
    
    // MARK: - Button Actions
    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        
    }
}

// MARK: - TableView Delegates
extension GetPointsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ///betsarray and heats array has equal count
        pointsTableHeightConstraint.constant = CGFloat(WalletVM.shared.betsArray.count * 50) + 20
        return WalletVM.shared.betsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.pointTableViewCell, for: indexPath) as! PointTableViewCell
        var boldText = NSMutableAttributedString().semiBold(pointType == .bet ? "Bet Points".localized : "Heat Points".localized, size: 14)
        var formatedText = NSMutableAttributedString()
        if pointType == .bet {
            cell.titleLabel.attributedText = formatedText.semiBold("\(WalletVM.shared.betsArray[indexPath.row])", size: 15).regular(" ", size: 15).semiBold("Bet Points".localized, size: 15).regular(" ", size: 15).regular("for".localized, size: 15).regular(" ", size: 15).regular("\(WalletVM.shared.heatsArray[indexPath.row])", size: 15).regular(" ", size: 15).regular("Heat Points".localized, size: 15)
        } else {
            cell.titleLabel.attributedText = formatedText.semiBold("\(WalletVM.shared.heatsArray[indexPath.row])", size: 15).regular(" ", size: 15).semiBold("Heat Points".localized, size: 15).regular(" ", size: 15).regular("for".localized, size: 15).regular(" ", size: 15).regular("\(WalletVM.shared.betsArray[indexPath.row])", size: 15).regular(" ", size: 15).regular("Bet Points".localized, size: 15)
        }
        cell.bgView.borderWidth = selectedIndex == indexPath.row ? 1 : 0
        cell.leftImageView.image = selectedIndex == indexPath.row ? .radioButtonSelected : .radioButton
        return cell
    }
    
}

extension GetPointsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
