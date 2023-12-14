//
//  TrendingNewsParentTableViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 09/12/2023.
//

import UIKit

final class TrendingNewsParentTableViewCell: UITableViewCell {

    @IBOutlet weak var indicatorView3: UIView!
    @IBOutlet weak var indicatorView2: UIView!
    @IBOutlet weak var indicatorView1: UIView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    var viewModel: TrendingCollectionCellViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            
            newsCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        build()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with viewModel: TrendingCollectionCellViewModel) {
        self.viewModel = viewModel
    }
    
}

private extension TrendingNewsParentTableViewCell {
    
    func build() {
        bind()
        configureViews()
    }
    
    func bind() {
        newsCollectionView.dataSource = self
        newsCollectionView.delegate = self
        newsCollectionView.register(
            TrendingCollectionViewCell.nib_Name,
            forCellWithReuseIdentifier: TrendingCollectionViewCell.reuseIdentifier
        )
    }
    
    func configureViews() {
        
    }
    
}

extension TrendingNewsParentTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.section.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = newsCollectionView.dequeueReusableCell(
            withReuseIdentifier: TrendingCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrendingCollectionViewCell,
              let section = viewModel?.section[indexPath.item] else { return UICollectionViewCell() }
        
        cell.configureCell(with: section)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: newsCollectionView.frame.width, height: newsCollectionView.frame.height)
    }
}

extension TrendingNewsParentTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        print("Page no: \(page)")
        switch page {
        case 0:
            indicatorView1.backgroundColor = UIColor(named: "Red_Dark")
            indicatorView2.backgroundColor = UIColor(named: "Red_Pale")
            indicatorView3.backgroundColor = UIColor(named: "Red_Pale")
            break
            
        case 1:
            indicatorView1.backgroundColor = UIColor(named: "Red_Pale")
            indicatorView2.backgroundColor = UIColor(named: "Red_Dark")
            indicatorView3.backgroundColor = UIColor(named: "Red_Pale")
            break
            
        case 2:
            indicatorView1.backgroundColor = UIColor(named: "Red_Pale")
            indicatorView2.backgroundColor = UIColor(named: "Red_Pale")
            indicatorView3.backgroundColor = UIColor(named: "Red_Dark")
            break
            
        default:
            break
        }
    }
}
