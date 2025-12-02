//
//  TodoRowView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import WidgetKit
import SwiftData
import ActivityKit
import UserNotifications

struct TodoRowView: View {
    @Bindable var todo: Todo
    @Query private var todoList: [Todo]
    /// View Properties

    @EnvironmentObject private var manager: ActivityManager
    @EnvironmentObject private var delegate: NotificationDelegate
    
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    @State private var showDetail = false
    @State private var showDeleteAlert = false
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                todo.isCompleted.toggle()
                todo.lastUpdated = .now
                WidgetCenter.shared.reloadAllTimelines()
                try? context.save()
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .padding(3)
                    .contentShape(.rect)
                    .foregroundStyle(todo.isCompleted ? .gray : .accentColor)
                    .contentTransition(.symbolEffect(.replace))
            }
            .opacity(todo.isExpired ? 0 : 1)
            .disabled(todo.isExpired)
            .buttonStyle(.borderless)
            
            VStack(alignment: .leading) {
                Text(todo.task)
                    .font(.title3)
                    .foregroundStyle(textColor)
                Text(dueDate)
                    .font(.caption)
                    .foregroundStyle(textColor)
            }
            .strikethrough(todo.isCompleted)
            .containerShape(.rect)
            .onTapGesture {
                showDetail = true
            }
            
            Spacer()
            // Priority Menu for Button for updating
            if !todo.isExpired {
                Menu {
                    ForEach(Priority.allCases, id: \.rawValue) { priority in
                        Button(action: { 
                            todo.priority = priority
                            WidgetCenter.shared.reloadAllTimelines()
                        }) {
                            HStack {
                                Text(priority.rawValue.capitalized)
                                
                                if todo.priority == priority { Image(systemName: "checkmark") }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.priority.color.gradient)
                }
            }
        }
        .sheet(isPresented: $showDetail) {
            TodoDetailView(todo: todo)
        }
        .alert("Are you sure you want to delete this task? This is a recurring task.", isPresented: $showDeleteAlert) {
            Button("Delete this task only", role: .destructive) { deleteTask() }
            Button("Delete all future tasks", role: .destructive) { deleteAllRelatedTasks() }
                    Button("Cancel", role: .cancel) { }
                }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("", systemImage: "trash") {
                if todo.repetition != .never {
                    showDeleteAlert = true
                } else {
                    deleteTask()
                }
            }
            .tint(.red)
            if !todo.isCompleted {
                Button("", systemImage: "clock") {
                    startTask()
                }
                .tint(.green)
            }
        }
    }
    
    func startTask() {
        let target = Target(id: todo.id, name: todo.task, startTime: todo.startDate, duration: todo.durationInSeconds)
        manager.startActivity(for: target)
    }
    
    private var textColor: Color {
        if todo.isCompleted {
            return .gray
        } else if todo.isExpired {
            return .red
        } else {
            return .primary
        }
    }
    
    private var dueDate: String {
        if todo.lastsAllDay {
            return DateHelper.Formatter.longDate.string(from: todo.startDate)
        } else {
            return DateHelper.Formatter.longDateWithTime.string(from: todo.startDate)
        }
    }
    private func deleteTask() {
        context.delete(todo)
        delegate.removePendingNotification(identifier: todo.id)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func deleteAllRelatedTasks() {
        for todoItem in todoList {
            if todoItem.task == todo.task, todoItem.startDate >= todo.startDate {
                context.delete(todoItem)
                delegate.removePendingNotification(identifier: todoItem.id)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}

#Preview {
    ContentView()
}
