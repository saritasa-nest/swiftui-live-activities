//
//  DueTodayList.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import SwiftData

struct DueTodayList: View {
    @Query(todoDescriptor, animation: .snappy) private var dueTodayList: [Todo]
    
    var body: some View {
        Section {
            ForEach(filteredTodos) { todo in
                TodoRowView(todo: todo)
            }
        } header: {
            HStack {
                Text("Due Today")
            }
            .font(.caption)
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
        dueTodayList.filter({ $0.isDueToday })
    }
}

#Preview {
    DueTodayList()
}
