//
//  ToggleButtonIntent.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import AppIntents
import SwiftData

/// Button Intent which will update the todo status
struct ToggleButtonIntent: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggles Todo State")
    @Parameter(title: "Todo ID") var id: String
    
    init() {
    }
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        /// Updating todo status
        let context = try ModelContext(.init(for: Todo.self))
        /// Retrieving Respective Todo
        let descriptor = FetchDescriptor(predicate: #Predicate<Todo> {$0.id == id})
        if let todo = try context.fetch(descriptor).first {
            todo.isCompleted = true
            todo.lastUpdated = .now
            /// Saving Context
            try context.save()
        }
        return .result()
    }
}
