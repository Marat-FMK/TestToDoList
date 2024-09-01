//
//  TaskInfoViewController.swift
//  TestToDoList
//
//  Created by Marat Fakhrizhanov on 30.08.2024.
//

import UIKit

class TaskInfoViewController: UIViewController {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCell()
    }
    
    private func setCell() {
        titleLabel.text = task.title
        noteLabel.text = task.note
        dateLabel.text = task.date?.formatted()
        statusLabel.text = task.isDone ? "Выполненные" : "Текущие"
    }

}
