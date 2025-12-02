//
//  ActivityManager.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 01/11/2024.
//

import SwiftUI
import ActivityKit

class ActivityManager: ObservableObject {
    struct ActivityStatus: Sendable, Hashable, Identifiable {
        var id: String
        var activityState: ActivityState
        var target: Target
        var contentState: TodoAttributes.ContentState
        
        init(id: String, activityState: ActivityState, target: Target, contentState: TodoAttributes.ContentState) {
            self.id = id
            self.activityState = activityState
            self.target = target
            self.contentState = contentState
        }
        
        init(activity: Activity<TodoAttributes>) {
            self.id = activity.id
            self.activityState = activity.activityState
            self.target = activity.attributes.target
            self.contentState = activity.content.state
        }
    }
    
    // current Activity
    @Published var activityStatus: ActivityStatus? = nil
    private var observationTaskSingle: Task<Void, Error>?
        
    @Published var statusList: [ActivityStatus] = []
    private var observationTaskMulti: Task<Void, Error>?
    private var activityList: [Activity<TodoAttributes>] = [] {
        didSet {
            DispatchQueue.main.async {
                self.statusList = self.activityList.map({ActivityStatus(activity: $0)})
            }
        }
    }
    
    func getLiveActivity(for recordID: String) -> Activity<TodoAttributes>?{
        Activity<TodoAttributes>.activities.first(where: {$0.attributes.target.id == recordID})
    }
    
    func loadActivity(_ activityId: String?) {
        guard let activityId else {
            return
        }
        
        guard let activity = self.activityList.first(where: {$0.id == activityId}) else {
            print("No Activity Found for current Target!")
            return
        }
        if activity.activityState == .ended || activity.activityState == .dismissed {
            print("Activity ended! Please start a new one!")
            return
        }
        
    }
    
    func startActivity(for target: Target){
        let activityData: TodoAttributes = .init(target: target)
        let contentState: TodoAttributes.ContentState = .init(status: .inProgress, lastUpdated: .now)
                do {
                    let activity = try Activity<TodoAttributes>.request(attributes: activityData, content: .init(state: contentState, staleDate: Date(timeIntervalSinceNow: 10)))
                    print("Activity Added: \(activity)")
                } catch {
                    print(error.localizedDescription)
                }
    }
    
    func updateActivity(id: String, status: TodoAttributes.Status) async {
        guard let currentActivity = getLiveActivity(for: id) else {
            print("Start a New activity or load an existing one before update.")
            return
        }

        let contentState = TodoAttributes.ContentState(status: status, lastUpdated: .now)

        await currentActivity.update(
            ActivityContent<TodoAttributes.ContentState>(
                state: contentState,
                staleDate: nil
            )
        )
        if status == .completed {
            await self.endActivity(id: id, dismissalPolicy: .default)
        }
    }
    
    func endActivity(id: String, dismissalPolicy: ActivityUIDismissalPolicy) async {
        guard let currentActivity = getLiveActivity(for: id) else {
            print("Start a New activity or load an existing one before ending it.")
            return
        }

        await currentActivity.end(nil, dismissalPolicy: dismissalPolicy)
    }
}

// Helper functions for Intent actions
extension ActivityManager {
    
    func finishTask(id: String) async {
        await self.updateActivity(id: id, status: .completed)
       
    }
}
