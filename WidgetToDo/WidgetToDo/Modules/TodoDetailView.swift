//
//  TodoDetailView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import WidgetKit

struct TodoDetailView: View {
    
    @State private var taskName: String = ""
    @State private var lastsAllDay: Bool = false
    @State private var startDate: Date = .now
    @State private var durationInSeconds: Int?
    @State private var priority: Priority = .normal
    @State private var completed: Bool = false
    @State private var repetition: Repetition = .never
    @State private var endRepeat: EndRepeat?
    @State private var customRepetition: CustomRepetition = .initialValue
    
    @EnvironmentObject private var delegate: NotificationDelegate
    
    var todo: Todo
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                FormView(
                    taskName: $taskName,
                    lastsAllDay: $lastsAllDay,
                    startDate: $startDate,
                    priority: $priority,
                    repetition: $repetition,
                    endRepeat: $endRepeat,
                    customRepetition: $customRepetition,
                    durationInSeconds: $durationInSeconds
                )
                
                Button(action: {
                    todo.isCompleted = true
                    todo.lastUpdated = .now
                    delegate.removePendingNotification(identifier: todo.id)
                    WidgetCenter.shared.reloadAllTimelines()
                    dismiss()
                }) {
                    Text("Complete Task")
                        .tint(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 50)
                        .background(todo.isCompleted ? .gray.opacity(0.3) : .blue, in: .capsule)
                        .padding(.horizontal)
                }
                .disabled(todo.isCompleted)
                
            }
            .navigationTitle("Todo Detail")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        todo.task = taskName
                        todo.lastsAllDay = lastsAllDay
                        todo.startDate = startDate
                        todo.durationInSeconds = durationInSeconds
                        todo.priority = priority
                        todo.repetition = repetition
                        todo.endRepeat = endRepeat
                        
                        do {
                            try context.save()
                            delegate.createNotification(for: todo)
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        // Manually update Widget
                        WidgetCenter.shared.reloadAllTimelines()
                        dismiss()
                    }.disabled(taskName.isEmpty)
                }
            }
            .onAppear {
                taskName = todo.task
                lastsAllDay = todo.lastsAllDay
                startDate = todo.startDate
                durationInSeconds = todo.durationInSeconds
                priority = todo.priority
                completed = todo.isCompleted
                repetition = todo.repetition
                endRepeat = todo.endRepeat
                // Show value for custom repetition
                //customRepetion = todo.customRepetion
            }
        }
    }
}

#Preview {
    TodoDetailView(todo: Todo.example)
}
