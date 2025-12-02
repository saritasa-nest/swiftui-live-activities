//
//  ContentView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var activityManager: ActivityManager
    @StateObject var notificationDelegate: NotificationDelegate
    
    init() {
        let activityManager = ActivityManager()
        _activityManager = StateObject(wrappedValue: activityManager)
        _notificationDelegate = StateObject(wrappedValue: NotificationDelegate(activityManager: activityManager))
    }
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationTitle("Todo List")
                .environmentObject(activityManager)
                .environmentObject(notificationDelegate)
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            }
            UNUserNotificationCenter.current().delegate = notificationDelegate
        }
    }
}

#Preview {
    ContentView()
}
