//
//  TaskSiriShortcuts.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 28/02/2025.
//

import AppIntents

struct TaskSiriShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(
            intent: AddTaskIntent(),
            phrases: [
                "Add new task in \(.applicationName)",
                "Create new task in \(.applicationName)",
            ],
            shortTitle: LocalizedStringResource(stringLiteral: "Add new task to list"),
            systemImageName: "plus"
        ),
        AppShortcut(
            intent: CompleteTaskIntent(),
            phrases: [
                "Complete task in \(.applicationName)",
                "Set task status to completed in \(.applicationName)",
            ],
            shortTitle: LocalizedStringResource(stringLiteral: "Complete task"),
            systemImageName: "slider.horizontal.3"
        )
    ]
}
