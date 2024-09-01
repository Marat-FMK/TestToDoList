//
//  Extension + UITableViewCell.swift
//  TestToDoList
//
//  Created by Marat Fakhrizhanov on 31.08.2024.
//

import UIKit

extension UITableViewCell {
    func configure(position: Int, task: Task) {
      
        var content = defaultContentConfiguration()
        
        guard let taskTitle = task.title else { return }
        
        var fullTitle: String {
            String(position) + ". " + taskTitle
        }
        
        content.text = fullTitle
        content.secondaryText = task.note
        if task.isDone {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }

        contentConfiguration = content
    }
}
