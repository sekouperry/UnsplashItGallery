//
//  PhotoBrowserCell.swift
//  UnsplashItGallery
//
//  Created by WangHong on 16/3/28.
//  Copyright © 2016年 WangHong. All rights reserved.
//

import UIKit
import Kingfisher


class PhotoBrowserCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView_full: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var progressView: ProgressView!
    
    var tempImageURL : URL?
    
    var imageURL : URL? {
        didSet {
            
            self.progressView.isHidden = false
            
            imageView_full.kf.setImage(with: imageURL!, placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
                DispatchQueue.main.async {
                    self.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
                }
            }) { (image, error, cacheType, imageURL) in
                DispatchQueue.main.async {
                    self.progressView.isHidden = true
                }
                if (error != nil && image == nil) {
                    self.imageView_full.kf.setImage(with: self.tempImageURL!)
                }
            }
            
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
}

extension PhotoBrowserCell : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView_full
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.frame
        var contentsFrame = self.imageView_full.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - scrollView.scrollIndicatorInsets.top - scrollView.scrollIndicatorInsets.bottom - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        self.imageView_full.frame = contentsFrame
    }
    
    func zoomInZoomOut(_ point: CGPoint!) {
        let newZoomScale = self.scrollView.zoomScale > (self.scrollView.maximumZoomScale/2) ? self.scrollView.minimumZoomScale : self.scrollView.maximumZoomScale
        
        let scrollViewSize = self.scrollView.bounds.size
        
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let x = point.x - (width / 2.0)
        let y = point.y - (height / 2.0)
        
        let rectToZoom = CGRect(x: x, y: y, width: width, height: height)
        
        self.scrollView.zoom(to: rectToZoom, animated: true)
    }
    
}
