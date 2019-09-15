//
//  MainView.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/14/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

@IBDesignable
class HSBView: UIView {
    var color: UIColor?
    var targetImageView = UIImageView(image: UIImage().cutImage(name: "target", size: 25))
    
    override func draw(_ rect: CGRect) {
        drawGradientView(rect)
        if color != nil {
            self.addSubview(targetImageView)
            getPointFromColor(color!)
        }
    }
    
    fileprivate func drawGradientView(_ rect: CGRect) {
        let elementSize: CGFloat = 1.0
        let height = rect.size.height
        let width = rect.size.width
        
        for y : CGFloat in stride(from: 0.0, to: height, by: elementSize) {
            let saturation = y / height
            for x : CGFloat in stride(from: 0.0, to: width, by: elementSize) {
                let hue = x / width
                let color = UIColor(
                    hue: hue,
                    saturation: saturation,
                    brightness: 1.0,
                    alpha: 1.0
                )
                let path = UIBezierPath(rect: CGRect(x: x, y: y, width: elementSize, height: elementSize))
                color.setFill()
                path.fill()
            }
        }
    }
    
    func getPointFromColor(_ color: UIColor) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        let viewSize = self.bounds.size
                
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        //brightnessLevel.value = Float(brightness)
        
        let y = saturation * viewSize.height
        let x = hue * viewSize.width
        targetImageView.center = CGPoint(x: x, y: y)
    }
}
