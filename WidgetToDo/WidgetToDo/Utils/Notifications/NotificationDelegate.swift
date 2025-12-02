//
//  NotificationDelegate.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 13/11/2024.
//

import SwiftUI

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {

    private let notificationCenter = UNUserNotificationCenter.current()
    
    @Published var activityManager: ActivityManager
    
    init(activityManager: ActivityManager) {
        self.activityManager = activityManager
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let taskId = userInfo["id"] as? String ,
              let taskName = userInfo["task"] as? String,
              let starTime = userInfo["startTime"] as? Date,
              let duration = userInfo["duration"] as? Int
        else {
            completionHandler()
            return
        }
        switch response.actionIdentifier {
        case Constants.startActionIdentifier:
            removeAllNotifications()
            let target = Target(id: taskId, name: taskName, startTime: starTime, duration: duration)
            start(task: target)
            break
        case Constants.rescheduleActionIdentifier:
            removeAllNotifications()
            rescheduleNotification()
            break
            
        case Constants.dismissActionIdentifier:
            removeAllNotifications()
            break
            
        case UNNotificationDefaultActionIdentifier,
        UNNotificationDismissActionIdentifier:
            break
            
        default:
            break
        }
        completionHandler()
    }

}

extension NotificationDelegate {
    
    /// Create notification for task
    func createNotification(for task: Todo) {
        
        // Remove any existing notifications for this task if there are any
        removePendingNotification(identifier: task.id)
        
        let content = UNMutableNotificationContent()
        content.title = task.task.capitalized
        content.subtitle =  "It's time to complete your task!"
        content.userInfo = [
            "id": task.id,
            "task": task.task,
            "startTime": task.startDate,
            "duration": task.durationInSeconds ?? 0
        ]
        content.categoryIdentifier = Constants.timerActionableIdentifier
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.startDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        registerNotificationRequest(identifier: task.id, content: content, trigger: trigger)
    }
    
    ///  Show the notification in 5 minutes
    private func rescheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "task.task.capitalized"
        content.subtitle =  "It's time to complete your task!"
        content.categoryIdentifier = Constants.timerActionableIdentifier
        
        // reminder notification in 5 minutes
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 * 60, repeats: false)
        registerNotificationRequest(identifier: "task.id", content: content, trigger: trigger)
    }
    
    /// Registers the notification with its corresponding actions
    private func registerNotificationRequest(identifier: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let startAction = UNNotificationAction(identifier: Constants.startActionIdentifier,
                                               title: "Start task",
                                               options: .foreground)
        let rescheduleAction = UNNotificationAction(identifier: Constants.rescheduleActionIdentifier,
                                                    title: "Remind me in 5 minutes",
                                                    options: .foreground)
        let dismissAction = UNNotificationAction(identifier: Constants.dismissActionIdentifier,
                                                 title: "Dismiss",
                                                 options: .destructive)
        
        let category = UNNotificationCategory(identifier: Constants.timerActionableIdentifier, actions: [startAction, rescheduleAction, dismissAction], intentIdentifiers: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func removeAllNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func removePendingNotification(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    /// Creates the Live Activity View for the corresponding task
    private func start(task: Target) {
        activityManager.startActivity(for: task)
    }
}

extension NotificationDelegate {
    private enum Constants {
        static let timerActionableIdentifier = "TIMER_ACTION"
        static let startActionIdentifier = "START_ACTION"
        static let rescheduleActionIdentifier = "RESCHEDULE_ACTION"
        static let dismissActionIdentifier = "DISMISS_ACTION"
    }
}
