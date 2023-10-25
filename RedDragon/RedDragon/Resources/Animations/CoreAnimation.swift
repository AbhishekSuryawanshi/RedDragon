//
//  CoreAnimation.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import UIKit

extension UIViewController {
    
    ///UITableView willDisplayCell method animation
    func animateTabelCell(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
        UIView.animate(withDuration: 0.8, delay: 0.05*Double(indexPath.row), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
        })
    }
    
    ///UICollectionView willDisplayCell method animation
    func animateCollectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath, animateDuration duration: Double) {
        cell.alpha = 0.1
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: duration) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        }
    }
    
}
