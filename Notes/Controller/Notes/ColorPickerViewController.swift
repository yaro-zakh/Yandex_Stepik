//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/18/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate {
    func getSelectedColorFromPicker(color: UIColor)
}

class ColorPickerViewController: UIViewController {
    @IBOutlet weak var colorPicker: ColorPicker!
    var delegate: ColorPickerDelegate?
    var colorFromEditView: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPicker.selectedColor.backgroundColor = colorFromEditView
        colorPicker.selectDone = { [weak self] color in
            guard let self = self else { return }
            self.delegate?.getSelectedColorFromPicker(color: color)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}
