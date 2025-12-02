//
//  HomeView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @State private var showAll: Bool = false
    @State private var isPresented: Bool = false
    var body: some View {
        List {
            DueTodayList()
            
            ActiveList()
            
            CompletedList(showAll: $showAll)
            
            //TODO: Add OngoingList?
            
            ExpiredList()
            
        }
        .sheet(isPresented: $isPresented) {
            AddTodoView()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    isPresented = true
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 42))
                })
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    ContentView()
}
