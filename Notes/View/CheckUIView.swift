//
//  CheckUIView.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/13/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

@IBDesignable
class CheckUIView: UIView {    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        drawCircle(in: rect)
        drawLine(in: rect)
    }
    
    private func drawCircle(in rect: CGRect) {
        let centerPoint = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = rect.width / 2 - rect.width / 12
        let path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
        path.lineWidth = rect.width / 12
        UIColor.black.setStroke()
        path.stroke()
    }
    
    private func drawLine(in rect: CGRect) {
        let path = UIBezierPath()
        let point1 = CGPoint(x: rect.width / 6, y: rect.height / 2)
        let point2 = CGPoint(x: rect.width / 1.85, y: rect.height / 1.2)
        let point3 = CGPoint(x: rect.width / 1.2, y: rect.height / 4)
        let point4 = CGPoint(x: rect.width / 2, y: rect.height / 1.5)
        
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        
        UIColor.black.setFill()
        path.fill()
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 18 }
}
