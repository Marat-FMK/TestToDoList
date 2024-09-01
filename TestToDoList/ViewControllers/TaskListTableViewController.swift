//
//  ViewController.swift
//  TestToDoList
//
//  Created by Marat Fakhrizhanov on 30.08.2024.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {

    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    
    private var taskList: [Task] = []
    private var sortByStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       createTaskList()
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        showAlert()
       }
    
    @IBAction func deleteAllTasks(_ sender: Any) {
        for task in taskList {
            StorageManager.shared.delete(task)
        }
        self.taskList.removeAll()
        self.tableView.reloadData()
    }
    
    @IBAction func sortTaskListByStatus(_ sender: UIBarButtonItem) {
        let completedTasks: [Task] = taskList.filter { $0.isDone }
        let currentTasks: [Task] = taskList.filter { !$0.isDone }
        
        if sortByStatus == 0 {
            taskList = completedTasks + currentTasks
            sortByStatus = 1
        } else {
            sortByStatus = 0
            taskList = currentTasks + completedTasks
        }
        tableView.reloadData()
    }
    
    private func createTaskList() {
        if UserDefaults.standard.bool(forKey: "firstStart") {
            fetchData()
        } else {
            DataManager.shared.createFakeTasks { fakeTasks in
                UserDefaults.standard.setValue(true, forKey: "firstStart")
                self.taskList += fakeTasks
                self.tableView.reloadData()
            }
        }
    }
    
    private func save(taskName: String, taskNote: String?) {
        StorageManager.shared.save(taskName: taskName, taskNote: taskNote) { task in
            self.taskList.append(task)
            let rowIndex = IndexPath(row: taskList.firstIndex(of: task) ?? 0, section: 0)
            self.tableView.insertRows(at: [rowIndex], with: .automatic)
        }
    }
    
    private func fetchData() {
       
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let tasks):
                self.taskList = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      "Заметки"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = taskList[indexPath.row]
        
        cell.configure(position: indexPath.row + 1, task: task)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "taskInfo" {
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                let task = taskList[indexPath.row]
                let taskInfoVC = segue.destination as! TaskInfoViewController
                taskInfoVC.task = task
            }
        }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = taskList[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            StorageManager.shared.delete(task)
            self.taskList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Редактировать") { _, _, isDone in
            self.showAlert(task: task) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneTitle = task.isDone ? "Редактировать" : "Выполнено"
        let doneAction = UIContextualAction(style: .normal, title: doneTitle) { _, _, isDone in
            StorageManager.shared.done(task: task)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.919551909, green: 0.5554075241, blue: 0.2589886487, alpha: 1)
        doneAction.backgroundColor = #colorLiteral(red: 0.2186376452, green: 0.6947699785, blue: 0.3461918533, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction,editAction,deleteAction])
    }
    
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task == nil ? "Новая заметка" : "Редактировать заметку"
        let alert = UIAlertController.createAlertController(withTitle: title)
        
        alert.action(task: task) { taskName, taskNote in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, newName: taskName, newNoteValue: taskNote)
                completion()
            } else {
                self.save(taskName: taskName, taskNote: taskNote)
            }
        }
        present(alert, animated: true)
    }
}

