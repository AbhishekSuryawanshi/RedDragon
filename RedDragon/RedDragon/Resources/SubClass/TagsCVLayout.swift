//
//  TagsCVLayout.swift
//  RedDragon
//
//  Created by Qasr01 on 13/11/2023.
//

import UIKit

public enum ScrollDirection : Int {
    case vertical
    case horizontal
}
@objc public protocol LayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize
    @objc optional func headerHeight(indexPath: IndexPath) -> CGFloat
    @objc optional func headerWidth(indexPath: IndexPath) -> CGFloat
    @objc optional func footerHeight(indexPath: IndexPath) -> CGFloat
    @objc optional func footerWidth(indexPath: IndexPath) -> CGFloat
}

public struct ItemsPadding {
    public let horizontal: CGFloat
    public let vertical: CGFloat
    
    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    static var zero: ItemsPadding {
        return ItemsPadding()
    }
}

public class BaseLayout: UICollectionViewLayout {
    public var contentPadding: ItemsPadding = .zero
    public var cellsPadding: ItemsPadding = .zero

    public weak var delegate: LayoutDelegate?

    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    var contentSize: CGSize = .zero

    var contentWidthWithoutPadding: CGFloat {
        return contentSize.width - 2 * contentPadding.horizontal
    }

    // MARK: - UICollectionViewFlowLayout

    override public var collectionViewContentSize: CGSize {
        return contentSize
    }

    override public func prepare() {
        super.prepare()

        cachedAttributes.removeAll()
        calculateCollectionViewFrames()
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { $0.frame.intersects(rect) }
    }

    // MARK: - Methods for subclasses

    func calculateCollectionViewFrames() {
        fatalError("Method must be overriden")
    }

    func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        guard let delegate = delegate else {
            return
        }

        let indexPath = IndexPath(item: 0, section: section)
        var delegateHeight: CGFloat?
        var delegateWidth: CGFloat?

        if kind == UICollectionView.elementKindSectionHeader {
            delegateHeight = delegate.headerHeight?(indexPath: indexPath)
            delegateWidth = delegate.headerWidth?(indexPath: indexPath)
        } else if kind == UICollectionView.elementKindSectionFooter {
            delegateHeight = delegate.footerHeight?(indexPath: indexPath)
            delegateWidth = delegate.footerWidth?(indexPath: indexPath)
        }

        guard let height = delegateHeight, height > 0 else {
            return
        }

        let x = delegateWidth == nil ? contentPadding.horizontal : contentSize.width / 2 - delegateWidth! / 2
        let origin = CGPoint(x: x, y: yOffset)
        let width = delegateWidth ?? contentWidthWithoutPadding
        let size = CGSize(width: width, height: height)

        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        attributes.frame = CGRect(origin: origin, size: size)
        cachedAttributes.append(attributes)

        yOffset += height + cellsPadding.vertical
    }

    func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffsets: inout [CGFloat]) {
        addAttributesForSupplementaryView(ofKind: kind, section: section, yOffset: &yOffsets[0])

        let y = yOffsets[0]
        for index in 0..<yOffsets.count {
            yOffsets[index] = y
        }
    }
}

public enum ContentAlign {
    case left
    case right
}

public class ContentAlignableLayout: BaseLayout {
    public var contentAlign: ContentAlign = .left
}


public class TagsCVLayout: ContentAlignableLayout {
    public var scrollDirection = ScrollDirection.vertical

    // MARK: - ContentDynamicLayout

    override public func calculateCollectionViewFrames() {
        switch scrollDirection {
        case .vertical:
            calculateVerticalScrollDirection()
        case .horizontal:
            calculateHorizontalScrollDirection()
        }
    }

    // MARK: - Helpers

    func calculateVerticalScrollDirection() {
        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }

        contentSize.width = collectionView.frame.size.width

        var xOffset = contentAlign == .left
            ? contentPadding.horizontal
            : contentSize.width - contentPadding.horizontal

        var yOffset = contentPadding.vertical

        for section in 0..<collectionView.numberOfSections {
            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              section: section,
                                              yOffset: &yOffset)

            let itemsCount = collectionView.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let isLastItem = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let cellSize = delegate.cellSize(indexPath: indexPath)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                switch contentAlign {
                case .left:
                    if xOffset + cellSize.width + cellsPadding.vertical > contentSize.width {
                        xOffset = contentPadding.horizontal
                        yOffset += cellSize.height + cellsPadding.vertical
                    }

                    let origin = CGPoint(x: xOffset, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: cellSize)

                    xOffset += cellSize.width + cellsPadding.horizontal
                case .right:
                    if xOffset - cellSize.width - cellsPadding.horizontal < 0 {
                        xOffset = contentSize.width - contentPadding.horizontal
                        yOffset += cellSize.height + cellsPadding.vertical
                    }

                    let x = xOffset - cellSize.width
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: cellSize)

                    xOffset -= cellSize.width + cellsPadding.horizontal
                }

                cachedAttributes.append(attributes)

                if isLastItem {
                    yOffset += cellSize.height + cellsPadding.vertical
                    xOffset = contentAlign == .left
                        ? contentPadding.horizontal
                        : contentSize.width - contentPadding.horizontal
                }
            }

            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                              section: section,
                                              yOffset: &yOffset)
        }

        contentSize.height = yOffset - cellsPadding.vertical + contentPadding.vertical
    }

    func calculateHorizontalScrollDirection() {
        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }

        contentSize.height = collectionView.frame.size.height

        var xOffset = contentPadding.horizontal
        var yOffset = contentPadding.vertical

        for section in 0..<collectionView.numberOfSections {
            let itemsCount = collectionView.numberOfItems(inSection: section)

            var rowsCount = 0
            var xOffsets = [CGFloat]()

            for item in 0 ..< itemsCount {
                let isLastItem = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let cellSize = delegate.cellSize(indexPath: indexPath)

                if yOffset + cellSize.height + cellsPadding.vertical > contentSize.height {
                    yOffset = contentPadding.vertical
                    rowsCount = item
                }

                let isFirstColumn = rowsCount == 0
                let row = isFirstColumn ? 0 : item % rowsCount
                let isValidRow = row < xOffsets.count

                let x = isFirstColumn || !isValidRow ? xOffset : xOffsets[row]
                let origin = CGPoint(x: x, y: yOffset)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(origin: origin, size: cellSize)
                cachedAttributes.append(attributes)

                if isFirstColumn {
                    xOffsets.append(xOffset + cellSize.width + cellsPadding.horizontal)
                } else if isValidRow {
                    let x = xOffsets[row]
                    xOffsets[row] = x + cellSize.width + cellsPadding.horizontal
                }

                yOffset += cellSize.height + cellsPadding.vertical

                if isLastItem {
                    xOffset = xOffsets.max()!
                    yOffset = contentPadding.vertical

                    xOffsets.removeAll()
                    rowsCount = 0
                }
            }
        }

        contentSize.width = xOffset - cellsPadding.horizontal + contentPadding.horizontal
    }
}


