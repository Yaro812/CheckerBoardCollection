//
//  CheckerBoardLayout.swift
//  CheckerBoardCollection
//
//  Created by Yaroslav Pasternak on 22/12/2016.
//  Copyright © 2016 Yaroslav Pasternak. All rights reserved.
//

import UIKit

protocol CheckerBoardLayoutDelegate: class {
    
}

class CheckerBoardLayout: UICollectionViewFlowLayout {
    weak var delegate: CheckerBoardLayoutDelegate?
    var shift: CGFloat = 0
    var columns: Int = 0
    
    fileprivate var sections = 0
    fileprivate var cells   = 0
    fileprivate var cellsPerLine = 0
    fileprivate var cellsInSections: [Int] = []
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        scrollDirection = .vertical
    }
    
    override func prepare() {
        super.prepare()
        // This layout is not developed to be used in horizontal direction yet
        // Obligatory setting scrollDirection to vertical
        scrollDirection = .vertical
        
        // If columns are set - automatically calculate cell size and shift
        if columns > 0, let collectionView = collectionView {
            let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
            let size = floor(availableWidth / CGFloat(columns) - minimumInteritemSpacing)
            itemSize = CGSize(width: size, height: size)
            shift = size / 2
        }
        
        sections = collectionView?.numberOfSections ?? 1
        var cellsInSections: [Int] = []
        cells = 0
        for section in 0..<sections {
            let count = collectionView?.numberOfItems(inSection: section) ?? 0
            cells += count
            cellsInSections.append(count)
        }
        self.cellsInSections = cellsInSections
        
        if scrollDirection == .vertical,
            let collectionView = collectionView {
            let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
            let widthForItem = itemSize.width + minimumInteritemSpacing
            cellsPerLine = Int(floor(availableWidth / widthForItem))
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        if scrollDirection == .horizontal {
            for i in 0..<sections {
                let cells = cellsInSections[i]
                width += itemSize.width * CGFloat(cells)
                width += minimumInteritemSpacing * CGFloat(cells - 1)
            }
            width += footerReferenceSize.width * CGFloat(sections)
            height = collectionView.bounds.height
        } else {
            for i in 0..<sections {
                let cells = CGFloat(cellsInSections[i]) / CGFloat(cellsPerLine)
                height += (itemSize.height + minimumLineSpacing) * cells
            }
            height += footerReferenceSize.height * CGFloat(sections)
            height += headerReferenceSize.height * CGFloat(sections)
            height += (sectionInset.top + sectionInset.bottom) * CGFloat(sections)
        }
        return CGSize(width: width, height: height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        
        let startIndex: Int!
        let endIndex: Int!
        if scrollDirection == .horizontal {
            let widthForItem = itemSize.width + minimumInteritemSpacing
            startIndex = Int(max(rect.minX / widthForItem, 0))
            endIndex = Int(min(rect.maxX / widthForItem, CGFloat(cells)))
        } else {
            let heightForItem = itemSize.height + minimumLineSpacing
            startIndex = Int(max(ceil(rect.minY / heightForItem) * CGFloat(cellsPerLine), 0))
            endIndex = Int(min(ceil(rect.maxY / heightForItem * CGFloat(cellsPerLine)), CGFloat(cells)))
        }
        
        var item = 0
        var section = 0
        for _ in 0..<startIndex {
            guard section < sections else { return attributes }
            
            if item == cellsInSections[section] - 1 {
                section += 1
                item = 0
            } else {
                item += 1
            }
        }
        
        for _ in startIndex..<endIndex {
            let indexPath = IndexPath(item: item, section: section)
            // Section header
            if item == 0 {
                if let attrs = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                    at: indexPath) {
                    attributes.append(attrs)
                }
            }
            
            if let attrs = layoutAttributesForItem(at: indexPath) {
                attributes.append(attrs)
            }
            
            if item >= cellsInSections[section] - 1 {
                section += 1
                item = 0
            } else {
                item += 1
            }
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath)?
            .copy() as? UICollectionViewLayoutAttributes else { return nil }
        
        attributes.center = CGPoint(x: centerX(forItemAt: indexPath), y: centerY(forItemAt: indexPath))
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard !(elementKind == UICollectionElementKindSectionHeader && headerReferenceSize == .zero)
            && !(elementKind == UICollectionElementKindSectionFooter && footerReferenceSize == .zero) else { return nil }
        guard let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?
            .copy() as? UICollectionViewLayoutAttributes else { return nil }
        
        attributes.center = CGPoint(x: centerX(forViewKind: elementKind, at: indexPath.section),
                                     y: centerY(forViewKind: elementKind, at: indexPath.section))
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attr = layoutAttributesForItem(at: itemIndexPath),
            let collectionView = collectionView else { return nil }
        
        attr.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        attr.center = CGPoint(x: attr.center.x, y: collectionView.bounds.midY)
        return attr
    }
    
    
    // Private
    
    private func centerX(forItemAt indexPath: IndexPath) -> CGFloat {
        var x: CGFloat = 0
        if scrollDirection == .horizontal {
            // To be implemented
        } else {
            let idxInLine = indexPath.item % cellsPerLine
            x = itemSize.width * CGFloat(idxInLine) + itemSize.width / 2
            x += minimumInteritemSpacing * CGFloat(idxInLine)
            x += sectionInset.left
        }
        return x
    }
    
    private func centerY(forItemAt indexPath: IndexPath) -> CGFloat {
        var y: CGFloat = 0
        if scrollDirection == .horizontal {
            // To be implemented
        } else {
            y += headerReferenceSize.height * CGFloat(indexPath.section + 1)
            y += sectionInset.top * CGFloat(indexPath.section + 1)
            for i in 0..<indexPath.section {
                y += cellsHeightFor(section: i)
            }
            let currentLine = Int(floor(Float(indexPath.item) / Float(cellsPerLine)))
            y += itemSize.height * CGFloat(currentLine) + itemSize.height / 2
            y += minimumLineSpacing * CGFloat(currentLine)
            y += sectionInset.bottom * CGFloat(indexPath.section)
            y += footerReferenceSize.height * CGFloat(indexPath.section)
            
            // и вот тут вся магия сдвига и происходит
            let indexInLine = indexPath.item % cellsPerLine
            y += indexInLine % 2 == 0 ? 0 : shift
        }
        return y
    }
    
    private func centerX(forViewKind: String, at section: Int) -> CGFloat {
        var x: CGFloat = 0
        if scrollDirection == .horizontal {
            // To be implemented
            if forViewKind == UICollectionElementKindSectionHeader {
                
            } else {
                
            }
        } else {
            if forViewKind == UICollectionElementKindSectionHeader {
                x = headerReferenceSize.width / 2
            } else {
                x = footerReferenceSize.width / 2
            }
        }
        return x
    }
    
    private func centerY(forViewKind: String, at section: Int) -> CGFloat {
        var y: CGFloat = 0
        if scrollDirection == .horizontal {
            // To be implemented
            if forViewKind == UICollectionElementKindSectionHeader {
                
            } else {
                
            }
        } else {
            y = centerY(forItemAt: IndexPath(item: 0, section: section))
            y -= itemSize.height / 2
            if forViewKind == UICollectionElementKindSectionHeader {
                y -= sectionInset.top
                y -= headerReferenceSize.height / 2
            } else {
                y += cellsHeightFor(section: section)
                y += sectionInset.bottom
                y += headerReferenceSize.height / 2
            }
        }
        return y
    }
    
    private func cellsHeightFor(section: Int) -> CGFloat {
        var height: CGFloat = 0
        if scrollDirection == .horizontal {
            height = collectionView?.bounds.height ?? 0
        } else {
            let cells = cellsInSections[section]
            let linesInSection = Int(ceil(CGFloat(cells) / CGFloat(cellsPerLine)))
            if cells == 0 { return 0 }
            if cells == 1 { return itemSize.height }
            if cells % cellsPerLine == 1 {
                height += CGFloat(linesInSection - 1) * itemSize.height
                height += itemSize.height
                height += minimumLineSpacing * CGFloat(linesInSection - 1)
            } else {
                height += CGFloat(linesInSection) * itemSize.height
                height += CGFloat(linesInSection - 1) * minimumLineSpacing
                height += shift
            }
        }
        return height
    }
    
    
}
