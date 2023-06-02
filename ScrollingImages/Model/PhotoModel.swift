//
//  PhotoModel.swift
//  ScrollingImages
//
//  Created by kaiserdem  on 31.05.2023.
//

import UIKit

protocol PhotoModel {
    func numberOfPhotos() -> Int
    func photoName(at index: Int) -> String?
    mutating func photoSize(at index: Int) -> CGSize?
    mutating func photo(at index: Int, debug: Bool) -> UIImage?
    mutating func photo(at index: Int) -> UIImage?
    var currentIndex: Int { get }

}

struct PhotoCollection: PhotoModel {
    
    let photoNames: [String]
    var photoSizes: [String:CGSize] = [:]
    var currentIndex = 0
    
    init(photos: [String]) {
        photoNames = photos
    }
    
    func numberOfPhotos() -> Int {
        return photoNames.count
    }
    
    func photoName(at index: Int) -> String? {
        guard index < photoNames.count else {
            return nil
        }
        return photoNames[index]
    }
    
    mutating func photoSize(at index: Int) -> CGSize? {
        guard let name = photoName(at: index), name != "" else {
            return nil
        }
        if let size = photoSizes[name] {
            return size
        } else {
            photoSizes[name] = photo(at: index)?.size
            return photoSizes[name]
        }
    }
    
    mutating func photo(at index: Int) -> UIImage? {
        return photo(at: index, debug: false)
    }
    
    mutating func photo(at index: Int, debug: Bool) -> UIImage? {
        guard let name = photoName(at: index), name != "" else {
            return nil
        }
        //if debug {
            print("index: \(index)")
            let i = index + 1
//            return UIImage.stamp(image: UIImage(named: name)!, with: "\(i)")
//
//        } else {
            self.currentIndex = i
            return UIImage(named: name)
        //}
    }
}
