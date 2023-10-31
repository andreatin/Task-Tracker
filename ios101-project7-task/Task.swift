//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {
    
    static var taskKey: String {
        return "Task"
    }


    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task], forKey key: String) {

        let defaults = UserDefaults.standard
        
        let encodedData = try! JSONEncoder().encode(tasks)
        defaults.set(encodedData, forKey: key)
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks(forKey key: String) -> [Task] {
        
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key) {
            let decodedData = try! JSONDecoder().decode([Task].self, from: data)
            return decodedData
        } else {
            return []
        }

    }

    // Add a new task or update an existing task with the current task.
    func save() {

        var savedTasks = Task.getTasks(forKey: Task.taskKey)
 
        if let existingTask = savedTasks.firstIndex(where: { $0.id == self.id} ) {
            savedTasks.remove(at: existingTask)
            savedTasks.insert(self, at: existingTask)
        } else {
            savedTasks.append(self)
        }
        
        Task.save(savedTasks, forKey: Task.taskKey)
     
    }
}
