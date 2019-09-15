//
//  ColorPicker.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/14/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPicker: UIView {
    @IBOutlet weak var HSBView: HSBView!
    @IBOutlet weak var selectedColor: UIView!
    @IBOutlet weak var hexColorLabel: UILabel!
    @IBOutlet weak var brightnessLevel: UISlider!
    
    var selectDone: ((_ color: UIColor) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupRecognizer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let color = selectedColor.backgroundColor {
            HSBView.color = color
        }
    }
    
    private func setupRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.selectColor(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        HSBView.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectColor(_:)))
        HSBView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupView() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPicker", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }

    @objc func selectColor(_ sender: UIGestureRecognizer) {
        let point = sender.location(in: HSBView)

        if (point.x <= HSBView.bounds.width && point.y <= HSBView.bounds.height && point.x >= 0 && point.y >= 0) {
            HSBView.targetImageView.center = CGPoint(x: point.x, y: point.y)
            selectedColor.backgroundColor = getColorFromTargetPosition()
            hexColorLabel.text = selectedColor.backgroundColor?.toHexString()
        }
    }
    
    private func getColorFromTargetPosition() -> UIColor {
        let point = HSBView.targetImageView.center
        return UIColor(hue: point.x / HSBView.bounds.width, saturation: point.y / HSBView.bounds.height, brightness: CGFloat(brightnessLevel!.value), alpha: 1.0)
    }
    
    @IBAction func sliderValue(_ sender: UISlider) {
        selectedColor.backgroundColor = getColorFromTargetPosition()
    }
    
    @IBAction func doneChoice(_ sender: UIButton) {
        selectedColor.backgroundColor = getColorFromTargetPosition()
        selectDone?(selectedColor.backgroundColor!)
    }
}
