//
//  ReusableView.swift
//  ScrollingImages
//
//  Created by kaiserdem  on 31.05.2023.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension HDCollectionViewCell: ReusableView {}
extension ThumbnailCollectionViewCell: ReusableView {}
