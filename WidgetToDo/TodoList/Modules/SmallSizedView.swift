//
//  SmallSizedView.swift
//  TodoListExtension
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import SwiftData

struct SmallSizedView: View {
    var entry: Provider.Entry
    // Query that will fetch only three active todos at a time
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]
    var body: some View {
        VStack {
            if let firstTodo = filteredTodos.first {
                WidgetRowView(todo: firstTodo)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if filteredTodos.isEmpty {
                Text("No Tasks due today 🎉🎉")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.startDate, order: .forward)]
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        return descriptor
    }
    
    /// Since date isn't yet available to be used on the #Predicate macro, in the meantime, the following workaround can be used:
    var filteredTodos: [Todo] {
        activeList.filter({ $0.isDueToday })
    }
}

#Preview {
    SmallSizedView(entry: .init(date: .now))
}
