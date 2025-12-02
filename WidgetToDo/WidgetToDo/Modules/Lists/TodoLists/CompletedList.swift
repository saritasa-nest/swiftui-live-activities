//
//  CompletedList.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import SwiftData

struct CompletedList: View {
    @Binding var showAll: Bool
    @Query private var completedList: [Todo]
    
    init(showAll: Binding<Bool>) {
        let predicate = #Predicate<Todo> { $0.isCompleted }
        let sort = [SortDescriptor(\Todo.startDate, order: .forward)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        if !showAll.wrappedValue {
            descriptor.fetchLimit = 5
        }
        
        _completedList = Query(descriptor, animation: .snappy)
        _showAll = showAll
    }
    
    var body: some View {
        Section {
            ForEach(completedList) { todo in
                TodoRowView(todo: todo)
            }
        } header: {
            HStack {
                Text("Completed")
                Spacer(minLength: 0)
                if showAll && !completedList.isEmpty {
                    Button("Show Recents") {
                        showAll = false
                    }
                }
            }
            .font(.caption)
        } footer: {
            if completedList.count == 5 && !showAll && !completedList.isEmpty {
                HStack {
                    Text("Showing Recent 15 Tasks")
                        .foregroundStyle(.gray)
                    
                    Spacer(minLength: 0)
                    Button("Show All") {
                        showAll = true
                    }
                }
                .font(.caption)
            }
        }
    }
}

#Preview {
    ContentView()
}
