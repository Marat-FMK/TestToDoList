//
//  Extension + UIAlertController.swift
//  TestToDoList
//
//  Created by Marat Fakhrizhanov on 31.08.2024.
//

import UIKit

extension UIAlertController {
    
    static func createAlertController(withTitle title: String) -> UIAlertController {
        UIAlertController(title: title, message: " What do you want to do ?", preferredStyle: .alert)
    }
    
    func action(task: Task?, completion: @escaping (String,String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            
            guard let newNote = self.textFields?.last?.text else { return }
            
            completion(newValue, newNote)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = task?.title
        }
        addTextField {textField in
            textField.placeholder = "Note"
            textField.text = task?.note
        }
    }
}
