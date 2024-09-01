//
//  DataManager.swift
//  TestToDoList
//
//  Created by Marat Fakhrizhanov on 01.09.2024.
//

import UIKit

class DataManager {
    
    static let shared = DataManager()
    private init() {}
    
    var tasks: [Task] = []
    
    func createFakeTasks(completion: @escaping([Task]) -> Void) {
        var taskList: [Task] = []
        NetworkManager.shared.fetchData { data in
            for fakeTask in data.todos {
                StorageManager.shared.save(taskName: fakeTask.todo) { task in
                    taskList.append(task)
                }
            }
            UserDefaults.standard.setValue(true, forKey: "firstTap")
            completion(taskList)
        }
    }
}
