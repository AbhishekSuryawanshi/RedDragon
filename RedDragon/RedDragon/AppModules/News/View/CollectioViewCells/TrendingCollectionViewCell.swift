//
//  TrendingCollectionViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 09/12/2023.
//

import UIKit

final class TrendingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var trendingTableView: UITableView!
    
    var model: TrendingCollectionSection? {
        didSet {
            guard let model = self.model else { return }
            
            trendingTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        build()
    }
    
    func configureCell(with model: TrendingCollectionSection) {
        self.model = model
    }

}

private extension TrendingCollectionViewCell {

    func build() {
        bind()
        configureViews()
    }
    
    func bind() {
        trendingTableView.dataSource = self
        trendingTableView.delegate = self
        trendingTableView.register(
            TrendingNewsChildTableViewCell.nib_Name,
            forCellReuseIdentifier: TrendingNewsChildTableViewCell.reuseIdentifier
        )
    }
    
    func configureViews() {
        
    }
}

extension TrendingCollectionViewCell: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = trendingTableView.dequeueReusableCell(
            withIdentifier: TrendingNewsChildTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrendingNewsChildTableViewCell,
              let details = model?.data[indexPath.row] else { return UITableViewCell() }
        
        cell.configureCell(with: TrendingChildCellViewModel(model: details))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = model?.data[indexPath.row] else { return }
        NotificationCenter.default.post(name: .moveToNewsDetail, object: nil, userInfo: ["NewsDetails": model])
    }
    
}
