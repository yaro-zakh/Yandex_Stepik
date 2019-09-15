//
//  ViewController.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 6/30/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, ColorPickerDelegate {
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var choiceColorView: ChoiceColor!
    
    @IBOutlet weak var datePickerHeigth: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    var switchOn = false
    var colorFromPicker: UIColor?
    var editedNote: Note?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButton()
        setupView()
        setupEditNoteIfNeeded()
        initDatePicker()
        
        choiceColorView.multiColorPressed = { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "colorPickerViewController", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ColorPickerViewController, segue.identifier == "colorPickerViewController" {
            controller.delegate = self
            controller.colorFromEditView = colorFromPicker ?? UIColor.white
            //controller.colorPicker.hexColorLabel.text = colorFromPicker?.toHexString() ?? UIColor.white.toHexString()
        }
    }
    
    func getSelectedColorFromPicker(color: UIColor) {
        for item in self.choiceColorView.buttonColor! {
            item.subviews.first?.isHidden = true
        }
        if let item = self.choiceColorView.buttonColor?.last {
            colorFromPicker = color
            item.backgroundColor = color
            item.subviews.last?.isHidden = true
            item.subviews.first?.isHidden = false
            item.tag = 5
        }
    }
    
    func setupBarButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addNewNote))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        contentTextView.inputAccessoryView = toolBar
    }
    
    func setupEditNoteIfNeeded() {
        if editedNote == nil { return }
        titleText.text = editedNote?.title
        contentTextView.text = editedNote?.content
    }
    
    func initDatePicker() {
        destroyDatePicker.isHidden = true
        datePickerHeigth.constant = 0
        destroyDatePicker.minimumDate = Date()
    }
    
    @objc func doneClicked() {
        contentTextView.resignFirstResponder()
    }
    
    @objc func addNewNote() {
        let destroyDate = switchOn ? destroyDatePicker.date : nil
        if titleText.text!.isEmpty {
            alertMessage(title: "Error", message: "You can not save note without title")
            return
        }
        if let selectedColor = getSelectedColor(buttons: choiceColorView.buttonColor!) {
            let uid = editedNote?.uid ?? UUID().uuidString
            let note = Note(uid: uid, title: titleText.text!, content: contentTextView.text, color: selectedColor, priority: Importance.regular, destroyDate: destroyDate)
            FileNotebook.shared.add(note)
        } else {
            FileNotebook.shared.add(Note(title: titleText.text!, content: contentTextView.text, priority: Importance.regular, destroyDate: destroyDate))
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        UIView.animate(withDuration: 1.0, animations: {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboard.height, right: 0)
        })
    }
    
    func getSelectedColor(buttons: [UIButton]) -> UIColor? {
        var color = editedNote?.color ?? nil
        for item in buttons {
            if item.tag == 5 {
                color = item.backgroundColor!
            }
        }
        return color
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func destroyDateSwitch(_ sender: UISwitch) {
        switchOn.toggle()
        UIView.animate(withDuration: 0.50) {
            if self.switchOn {
                self.datePickerHeigth.constant = 200
                self.destroyDatePicker.isHidden = false
            } else {
                self.datePickerHeigth.constant = 0
                self.destroyDatePicker.isHidden = true
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension EditNoteViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
