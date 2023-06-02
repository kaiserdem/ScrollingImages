//
//  CellAnimationMeasurement.swift
//  ScrollingImages
//
//  Created by kaiserdem  on 31.05.2023.
//

import UIKit

protocol CellAnimationMeasurement {
    var animatedCellIndex: Int { get set}
    var originalInsetAndContentOffset: (CGFloat, CGFloat) { get set}
    var animatedCellType: AnimatedCellType { get set }
}
