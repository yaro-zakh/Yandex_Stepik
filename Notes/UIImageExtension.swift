//
//  UIImageExtension.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/18/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

extension UIImage {
    func cutImage(name: String, size: Int) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: size, height: size)).image { _ in
            UIImage(named: name)?.draw(in: CGRect(x: 0, y: 0, width: size, height: size))}
    }
}
