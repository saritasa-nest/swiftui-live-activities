//
//  CompleteTaskIntent.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 28/02/2025.
//

import SwiftUI
import AppIntents
import SwiftData
import WidgetKit

struct CompleteTaskIntent: AppIntent {
    
    
    static var title = LocalizedStringResource("Complete Task")
    static var description = IntentDescription("Set task's status to complete.")
    
    @Parameter(title: "Todo task") var task: String
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        /// Updating todo status
        let context = try ModelContext(.init(for: Todo.self))
        /// Retrieving Respective Todo
        let descriptor = FetchDescriptor(predicate: #Predicate<Todo> {$0.task.localizedStandardContains(task)})
        guard let todo = try context.fetch(descriptor).first else {
            throw $task.needsValueError("Please enter a valid id.")
        }
            todo.isCompleted = true
            todo.lastUpdated = .now
            /// Saving Context
            try context.save()
            
        print("refreshing \(String(describing: task))")
            let manager = ActivityManager()
        manager.loadActivity(todo.id)
        await manager.finishTask(id: todo.id)
        
        // Manually update Widget
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result(dialog: "Task '\(todo.task)' completed successfully")
    }
}
