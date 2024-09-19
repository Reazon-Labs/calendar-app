import Foundation

struct TaskModel {
    var title: String
    var project: String
    var deadline: Date?
    var estimatedTime: Int = 30
    var priority: TaskPriority = .None
    var doDateInterval: DateInterval?
    var body: String?
    var isProject: Bool = false
    var subtasks: [TaskModel]?
    var done: Bool = false
}

enum TaskPriority {
    case None
    case Low
    case Medium
    case High
}
