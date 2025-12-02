//
//  AddTaskIntent.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 28/02/2025.
//

import SwiftUI
import AppIntents
import SwiftData
import WidgetKit

struct AddTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Task"
    
    @Parameter(title: "Task") var name: String
    @Parameter(title: "Date") var date: Date?
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let date else {
            throw $date.needsValueError("When is this task due?")
        }
        let container = try ModelContainer(for: Todo.self)
        let context = ModelContext(container)
        
        let todo = Todo(
            task: name,
            lastsAllDay: false,
            startDate: date,
            durationInSeconds: nil,
            priority: .normal,
            repetition: .never,
            endRepeat: nil
        )
        context.insert(todo)

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        // Manually update Widget
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result(dialog: "Task added successfully!")
    }
}
