//
//  FeedCVLayout.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit

/// To show image grid for post images
/// maximum 5 images
class FeedCVLayout: UICollectionViewLayout {
    var height = Int(screenWidth - 30)
    // 2
    var layoutType = 0
    fileprivate var cellPadding: CGFloat = 7
    
    // 3
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    // 4
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        //let insets = collectionView.contentInset
        return CGFloat(height)//screenWidth - 50
    }
    
    // 5
    override var collectionViewContentSize: CGSize {
        return CGSize(width: height, height: height) //CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        contentHeight = CGFloat(height)
        
        // 1
        cache = []
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        // 2
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            var frame = CGRect()
            
            switch layoutType{
            case 1:
                frame = CGRect(x: 0, y: 0, width: Int(contentWidth), height: height)
            case 2:
                if indexPath.row == 0{
                    frame = CGRect(x: 0, y: 0, width: Int(contentWidth/2), height: height)
                }else{
                    frame = CGRect(x: Int(contentWidth/2), y: 0, width: Int(contentWidth/2), height: height)
                }
            case 3:
                switch indexPath.row{
                case 0:
                    frame = CGRect(x: 0, y: 0, width: Int(contentWidth), height: height/2)
                case 1:
                    frame = CGRect(x: 0, y: (height/2), width: (Int(contentWidth) / 2), height: height/2)
                case 2:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: (height/2), width: Int(contentWidth) / 2, height: (height/2))
                default:
                    break
                }
            case 4:
                switch indexPath.row{
                case 0:
                    frame = CGRect(x: 0, y: 0, width: (Int(contentWidth) / 2), height: (height/2) )
                case 1:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: 0, width: (Int(contentWidth) / 2), height: (height/2))
                case 2:
                    frame = CGRect(x: 0, y: (height/2), width: (Int(contentWidth) / 2), height: (height/2))
                case 3:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: (height/2), width: (Int(contentWidth) / 2), height: (height/2))
                default:
                    break
                }
            case 5:
                switch indexPath.row{
                case 0:
                    frame = CGRect(x: 0, y: 0, width: Int(contentWidth) / 2, height: (height/2) )
                case 1:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: 0, width: Int(contentWidth) / 2, height: (height/3))
                case 2:
                    frame = CGRect(x: 0, y: (height/2), width: Int(contentWidth) / 2, height: (height/2))
                case 3:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: (height/3), width: Int(contentWidth) / 2, height: (height/3))
                case 4:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: (height/3)*2, width: Int(contentWidth) / 2, height: (height/3))
                default:
                    break
                }
            default:
                
                break
            }
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

/// Use this funtion to make image grid for images
/// This will show grid of maximum 5 images
/// pass collection view and image count
func setfeedImageCVLayout(collectionview: UICollectionView, imageCount: Int) {
    var imagesCount = imageCount
    if imageCount > 5 {
        imagesCount = 5
    }
    if let layout = collectionview.collectionViewLayout as? FeedCVLayout {
        switch imagesCount {
        case 1:
            layout.layoutType = 1
            break
        case 2:
            layout.layoutType = 2
            break
        case 3:
            layout.layoutType = 3
            break
        case 4:
            layout.layoutType = 4
            break
        case 5:
            layout.layoutType = 5
            break
        default:
            layout.layoutType = 5
            break
        }
    }
}
