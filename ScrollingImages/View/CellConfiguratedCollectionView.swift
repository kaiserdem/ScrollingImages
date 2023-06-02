//
//  CellConfiguratedCollectionView.swift
//  ScrollingImages
//
//  Created by kaiserdem  on 31.05.2023.
//

import UIKit

protocol CellConfiguration {
    var cellMaximumWidth: CGFloat! { get set }
    var cellNormalWidth: CGFloat! { get set }
    var cellFullSpacing: CGFloat! { get set }
    var cellNormalSpacing: CGFloat! { get set }
    var cellHeight: CGFloat! { get set }
    func cellSize(for indexPath:IndexPath) -> CGSize?
}

protocol CollectionViewCellSize: AnyObject {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize?
}

class CellConfiguratedCollectionView: UICollectionView, CellConfiguration {
    
    weak var cellSize: CollectionViewCellSize?
    
    func cellSize(for indexPath: IndexPath) -> CGSize? {
        return cellSize?.collectionView(self, sizeForItemAt: indexPath)
    }
    
    var cellMaximumWidth: CGFloat!
    var cellNormalWidth: CGFloat!
    var cellFullSpacing: CGFloat!
    var cellNormalSpacing: CGFloat!
    var cellHeight: CGFloat!
}
