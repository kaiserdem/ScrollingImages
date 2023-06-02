//
//  HDCollectionViewCell.swift
//  ScrollingImages
//
//  Created by kaiserdem  on 31.05.2023.
//

import UIKit

class HDCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoViewWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoView.isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender:)))
        photoView.addGestureRecognizer(pinchGesture)
    }
    
    
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {
        
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
            guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
            sender.view?.transform = scale
            sender.scale = 1
    }
}
