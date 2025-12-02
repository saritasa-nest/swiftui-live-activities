//
//  TodoList.swift
//  TodoList
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import WidgetKit
import SwiftUI
import SwiftData

struct TodoList: Widget {
    let kind: String = "TodoList"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            // Setting up SwiftData Container
                .modelContainer(for: Todo.self)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .configurationDisplayName("Tasks")
        .description("This is a Todo List")
    }
}

#Preview(as: .systemMedium) {
    TodoList()
} timeline: {
    SimpleEntry(date: .now)
}
