//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/18/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var note: Note! {
        didSet {
            colorView.backgroundColor = note.color
            titleLabel.text = note.title
            contentLabel.text = note.content
        }
    }
    
}
