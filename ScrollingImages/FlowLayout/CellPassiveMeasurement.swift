//
//  CellPassiveMeasurement.swift
//  ScrollingImages
//
//  Created by kaiserdem  on 31.05.2023.
//

import UIKit

protocol CellPassiveMeasurement {
    var puppetCellIndex: Int { get set }
    var puppetFractionComplete: CGFloat { get set }
    var unitStepOfPuppet: CGFloat { get }
}
