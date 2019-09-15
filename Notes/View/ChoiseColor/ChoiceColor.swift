//
//  ChoiseColor.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/13/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

@IBDesignable
class ChoiceColor: UIView {
    @IBOutlet var buttonColor: [UIButton]?
    
    var multiColorPressed: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        
        for item in buttonColor! {
            item.layer.borderColor = UIColor.black.cgColor
            item.layer.borderWidth = 1
            let gradientView = HSBView()
            let customView = CheckUIView()
            customView.isHidden = true
            item.addSubview(customView)
            addCustomConstraint(childView: customView, parentView: item, multiplier: 0.3)
            if item.tag == 1 {
                gradientView.isUserInteractionEnabled = false
                item.addSubview(gradientView)
                addCustomConstraint(childView: gradientView, parentView: item, multiplier: 1)
            }
        }
    }
    
    private func addCustomConstraint(childView: UIView, parentView: UIView, multiplier: CGFloat) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        childView.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: multiplier).isActive = true
        childView.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: multiplier).isActive = true
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ChoiceColor", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    @IBAction func selectColor(_ sender: UIButton) {
        if sender.tag == 1 { return }
        for item in buttonColor! {
            item.subviews.first?.isHidden = true
            if item.tag != 1 {
                item.tag = 0
            }
        }
        sender.subviews.first?.isHidden = false
        sender.tag = 5
    }
    
    @IBAction func choiceMultiColor(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            multiColorPressed?()
        }
    }
}
