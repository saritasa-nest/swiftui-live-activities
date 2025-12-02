//
//  WidgetRowView.swift
//  TodoListExtension
//
//  Created by Nicolas Cobelo on 31/07/2024.
//

import SwiftUI

struct WidgetRowView: View {
    @Environment(\.widgetFamily) var widgetFamily
    let todo: Todo
    var body: some View {
        HStack(spacing: isWidgetSmall ? 3 : 10) {
            // Intent Action Button
            Button(intent: ToggleButtonIntent(id: todo.id)) {
                Image(systemName: "circle")
            }
            .font(isWidgetSmall ? .caption : .callout)
            .tint(todo.priority.color.gradient)
            .buttonBorderShape(.circle)
            
            Text(todo.task)
                .font(.callout)
                .lineLimit(isWidgetSmall ? 2 : 1)
            
            Spacer(minLength: 0)
            
            if !isWidgetSmall {
                Text("Today, \(DateHelper.Formatter.shortTime.string(from: todo.startDate))")
                    .font(.caption)
            }
        }
    }
    
    var isWidgetSmall: Bool {
        widgetFamily == .systemSmall
    }
}

#Preview {
    WidgetRowView(todo: .example)
}
