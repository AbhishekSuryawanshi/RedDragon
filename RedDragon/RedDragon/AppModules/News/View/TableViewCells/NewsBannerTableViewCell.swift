//
//  NewsBannerTableViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 06/12/2023.
//

import UIKit

final class NewsBannerTableViewCell: UITableViewCell {

    @IBOutlet weak var indicatorView3: UIView!
    @IBOutlet weak var indicatorView2: UIView!
    @IBOutlet weak var indicatorView1: UIView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    var viewModel: NewsTableCellViewModel? {
        didSet {
            guard let _ = viewModel else { return }
            
            bannerCollectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
     
        build()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with viewModel: NewsTableCellViewModel) {
        self.viewModel = viewModel
    }
    
}

private extension NewsBannerTableViewCell {
    
    func build() {
        bind()
        configureViews()
    }
    
    func bind() {
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.register(
            NewsBannerCollectionViewCell.nib_Name,
            forCellWithReuseIdentifier: NewsBannerCollectionViewCell.reuseIdentifier
        )
    }
    
    func configureViews() {
        
    }
    
}

extension NewsBannerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.model.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = bannerCollectionView.dequeueReusableCell(
            withReuseIdentifier: NewsBannerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? NewsBannerCollectionViewCell,
        let model = viewModel?.model[indexPath.row] else { return UICollectionViewCell() }
        
        cell.configureCell(with: NewsCollectionCellViewModel(model: model))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = viewModel?.model[indexPath.row] else { return }
        NotificationCenter.default.post(name: .moveToNewsDetail, object: nil, userInfo: ["NewsDetails": model])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}

extension NewsBannerTableViewCell: UIScrollViewDelegate {
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
