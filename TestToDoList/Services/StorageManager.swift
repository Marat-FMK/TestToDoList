//
//  StorageManager.swift
//  TestToDoList
//
//  Created by Marat Fakhrizhanov on 30.08.2024.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TestToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    
    func fetchData(completion: (Result<[Task],Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func save(taskName: String, taskNote: String? = nil, status: Bool? = false, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskName
        task.date = Date()
        task.note = taskNote
        task.isDone = status ?? false
        completion(task)
        saveContext()
    }
    
    func edit(_ task: Task, newName: String, newNoteValue: String?) {
        task.title = newName
        task.note = newNoteValue
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    func done(task: Task) {
        task.isDone.toggle()
        saveContext()
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            }catch  {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
