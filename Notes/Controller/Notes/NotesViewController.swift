//
//  NotesViewController.swift
//  Notes
//
//  Created by Yaroslav Zakharchuk on 7/18/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var editNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(FileNotebook.shared.getSortedArray())
        tableView.reloadData()
    }
    
    @IBAction func editTable(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
    }
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editNoteVIewController", sender: nil)
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FileNotebook.shared.getSortedArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        cell.note = FileNotebook.shared.getSortedArray()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editNote = FileNotebook.shared.getSortedArray()[indexPath.row]
        performSegue(withIdentifier: "editNoteVIewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditNoteViewController, segue.identifier == "editNoteVIewController" {
            controller.editedNote = editNote
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            let deleteNoteUid = FileNotebook.shared.getSortedArray()[indexPath.row].uid
            FileNotebook.shared.remove(with: deleteNoteUid)
            tableView.deleteRows(at: [indexPath], with: .left)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
