//
//  FullViewPhotoViewController.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/21/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

class FullViewPhotoViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images = [UIImageView]()
    var selectedIndex = 0
    var screenRotation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, imageView) in images.enumerated() {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        
        let contentWidth = scrollView.frame.width * CGFloat(images.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
        
        let point = CGPoint(x: scrollView.frame.width * CGFloat(selectedIndex), y: 0)
        scrollView.setContentOffset(point, animated: false)
        screenRotation = true
    }
    
    fileprivate func setupImages() {
        for item in images {
            item.contentMode = .scaleAspectFit
            scrollView.addSubview(item)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRotation = false
    }
}

extension FullViewPhotoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if screenRotation {
            let pageIndex = scrollView.contentOffset.x / scrollView.frame.width
            let roundedPageIndex = Int(pageIndex.rounded())
            selectedIndex = roundedPageIndex
        }
    }
}
