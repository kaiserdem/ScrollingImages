//
//  ViewController.swift
//  ScrollingImages
//
//  Created by kaiserdem  on 31.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var debug: Bool = true
    
    var showAdditionalItems = false
    var hdPhotoModel: PhotoModel!
    var thumbnailPhotoModel: PhotoModel!
    var flowLayoutSyncManager: FlowLayoutSyncManager!
    
    var hdCollectionViewRatio: CGFloat = 0
    var thumbnailCollectionViewThinnestRatio: CGFloat = 0
    var thumbnailCollectionViewThickestRatio: CGFloat = 0
    let thumbnailMaximumWidth: CGFloat = 160
    
    let imagesArray = ["pic2","pic8", "pic3", "pic4", "pic9", "pic5", "pic6", "pic7"]
    
    @IBOutlet weak var hdCollectionView: CellConfiguratedCollectionView!
    @IBOutlet weak var thumbnailCollectionView: CellConfiguratedCollectionView!
    @IBOutlet weak var numberOfPages: UILabel!
    @IBOutlet weak var exitButton: UIButton!

    override func loadView() {
        super.loadView()
        
        hdPhotoModel = PhotoCollection(photos: imagesArray)
        
        thumbnailPhotoModel = PhotoCollection(photos: imagesArray)
        flowLayoutSyncManager = FlowLayoutSyncManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        
        hdCollectionView.addGestureRecognizer(tap)
        
        setupHDCollectionView()
        setupThumbnailCollectionView()
        flowLayoutSyncManager.register(hdCollectionView)
        flowLayoutSyncManager.register(thumbnailCollectionView)
        updateNumbers()
    }
    
    func updateNumbers() {
        numberOfPages.text = "\(flowLayoutSyncManager.currentIndex) from \(String(imagesArray.count))"
    }
    
    @objc func didTap() {
        showAdditionalItems.toggle()
//        if showAdditionalItems {
//            print("1")
//            exitButton.animShow(fromTop: false)
//            numberOfPages.animShow(fromTop: false)
//            thumbnailCollectionView.animShow()
//
//        } else {
//            print("2")
//            exitButton.animHide(fromBottom: false)
//            numberOfPages.animHide(fromBottom: false)
//            thumbnailCollectionView.animHide()
//        }
//        view.layoutSubviews()
        
        exitButton.isHidden = showAdditionalItems
        numberOfPages.isHidden = showAdditionalItems
        thumbnailCollectionView.isHidden = showAdditionalItems
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let layout = thumbnailCollectionView.collectionViewLayout as? ThumbnailFlowLayoutDraggingBehavior {
            layout.unfoldCurrentCell()
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupHDCollectionViewMeasurement()
        hdCollectionView.collectionViewLayout.invalidateLayout()
        setupThumbnailCollectionViewMeasurement()
        thumbnailCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    fileprivate func setupHDCollectionView() {
        hdCollectionView!.cellSize = self
        hdCollectionView.dataSource = self
        hdCollectionView.delegate = self
        hdCollectionView!.isPagingEnabled = true
        hdCollectionView!.decelerationRate = UIScrollView.DecelerationRate.normal
        let layout = HDFlowLayout()
        layout.flowLayoutSyncManager = flowLayoutSyncManager
        hdCollectionView!.collectionViewLayout = layout
    }
    
    fileprivate func setupThumbnailCollectionView() {
        thumbnailCollectionView!.dataSource = self
        thumbnailCollectionView!.delegate = self
        thumbnailCollectionView!.cellSize = self
        thumbnailCollectionView!.alwaysBounceHorizontal = true
        thumbnailCollectionView!.collectionViewLayout = ThumbnailSlaveFlowLayout()
    }
    
    fileprivate func setupHDCollectionViewMeasurement() {
        hdCollectionView.cellFullSpacing = 100
        hdCollectionView.cellNormalWidth = hdCollectionView!.bounds.size.width - hdCollectionView.cellFullSpacing
        hdCollectionView.cellMaximumWidth = hdCollectionView!.bounds.size.width
        hdCollectionView.cellNormalSpacing = 0
        hdCollectionView.cellHeight = hdCollectionView.bounds.size.height
        hdCollectionViewRatio = hdCollectionView.frame.size.height / hdCollectionView.frame.size.width
        if var layout = hdCollectionView.collectionViewLayout as? FlowLayoutInvalidateBehavior {
            layout.shouldLayoutEverything = true
        }
    }
    
    fileprivate func setupThumbnailCollectionViewMeasurement() {
        thumbnailCollectionView.cellNormalWidth = 30
        thumbnailCollectionView.cellFullSpacing = 15
        thumbnailCollectionView.cellNormalSpacing = 2
        thumbnailCollectionView.cellHeight = thumbnailCollectionView.frame.size.height
        thumbnailCollectionView.cellMaximumWidth = thumbnailMaximumWidth
        thumbnailCollectionViewThinnestRatio = thumbnailCollectionView.cellHeight / thumbnailCollectionView.cellNormalWidth
        thumbnailCollectionViewThickestRatio = thumbnailCollectionView.cellHeight / thumbnailMaximumWidth
        if var layout = hdCollectionView.collectionViewLayout as? FlowLayoutInvalidateBehavior {
            layout.shouldLayoutEverything = true
        }
    }
}

//MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case hdCollectionView:
            return hdPhotoModel.numberOfPhotos()
        case thumbnailCollectionView:
            return thumbnailPhotoModel.numberOfPhotos()
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case thumbnailCollectionView:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ThumbnailCollectionViewCell
            if let image = thumbnailPhotoModel.photo(at: indexPath.row, debug: debug),
                let size = self.collectionView(thumbnailCollectionView, sizeForItemAt: indexPath) {
                cell.photoViewWidthConstraint.constant = size.width
                cell.clipsToBounds = true
                cell.photoView?.contentMode = .scaleAspectFill
                cell.photoView?.image = image
            }
            
            return cell
        case hdCollectionView:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as HDCollectionViewCell
            if let image = hdPhotoModel.photo(at: indexPath.item, debug:debug),
                let size = self.collectionView(hdCollectionView, sizeForItemAt: indexPath)  {
                cell.photoViewWidthConstraint.constant = size.width
                cell.photoViewHeightConstraint.constant = size.height
                cell.clipsToBounds = true
                cell.photoView?.contentMode = .scaleAspectFill
                cell.photoView?.image = image
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK：- CollectionView Delegate
extension ViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            flowLayoutSyncManager.masterCollectionView = collectionView
            if let layout = collectionView.collectionViewLayout as? ThumbnailFlowLayoutDraggingBehavior {
                layout.foldCurrentCell()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? ThumbnailFlowLayoutDraggingBehavior{
            layout.unfoldCurrentCell()
        }
        
        updateNumbers()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate,
            let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? ThumbnailFlowLayoutDraggingBehavior{
            layout.unfoldCurrentCell()
        }
        updateNumbers()
    }
}

//MARK: - CollectionViewCellSize Protocol
extension ViewController: CollectionViewCellSize {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize? {
        switch collectionView {
        case hdCollectionView:
            if let size = hdPhotoModel.photoSize(at: indexPath.row) {
                return cellSize(forHDImage: size)
            }
        case thumbnailCollectionView:
            if let size = thumbnailPhotoModel.photoSize(at: indexPath.row) {
                return cellSize(forThumbImage: size)
            }
        default:
            return nil
        }
        return nil
    }
    
    fileprivate func cellSize(forHDImage size: CGSize) -> CGSize? {
        let ratio = size.height / size.width
        if (ratio < hdCollectionViewRatio) {
            return CGSize(width: hdCollectionView.frame.size.width, height: hdCollectionView.frame.size.width * ratio)
        } else {
            return CGSize(width: hdCollectionView.frame.size.height / ratio, height: hdCollectionView.frame.size.height)
        }
    }
    
    fileprivate func cellSize(forThumbImage size: CGSize) -> CGSize? {
        let ratio = size.height / size.width
        if (ratio > thumbnailCollectionViewThinnestRatio) {
            return CGSize(width: thumbnailCollectionView.cellNormalWidth, height: thumbnailCollectionView.cellHeight)
        } else if ratio < thumbnailCollectionViewThickestRatio {
            return CGSize(width: thumbnailCollectionView.cellMaximumWidth, height: thumbnailCollectionView.cellHeight)
        } else {
            return CGSize(width: thumbnailCollectionView.frame.size.height / ratio, height: thumbnailCollectionView.frame.size.height)
        }
    }
}

//extension UIView {
//    func animShow(fromTop: Bool = true){
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
//                       animations: {
//
//            if fromTop {
//                self.center.y -= self.bounds.height
//            } else {
//                self.center.y += self.bounds.height
//            }
//                        //self.center.y -= self.bounds.height
//                        self.layoutIfNeeded()
//        }, completion: nil)
//        self.isHidden = false
//    }
//    func animHide(fromBottom: Bool = true) {
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
//                       animations: {
//            if fromBottom {
//                self.center.y += self.bounds.height
//            } else {
//                self.center.y -= self.bounds.height
//            }
//                        //self.center.y += self.bounds.height
//                        self.layoutIfNeeded()
//
//        },  completion: {(_ completed: Bool) -> Void in
//        self.isHidden = true
//            })
//    }
//}
