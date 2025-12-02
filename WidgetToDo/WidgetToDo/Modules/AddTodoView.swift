//
//  AddTodoView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import WidgetKit
import UserNotifications

struct AddTodoView: View {
    
    @State private var taskName: String = ""
    @State private var lastsAllDay: Bool = false
    @State private var startDate: Date = .now
    @State private var durationInSeconds: Int?
    @State private var priority: Priority = .normal
    @State private var repetition: Repetition = .never
    @State private var endRepeat: EndRepeat?
    @State private var customRepetition: CustomRepetition = .initialValue
    
    @EnvironmentObject private var delegate: NotificationDelegate
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Add todo item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let dueDates = generateDates()
                        
                        for date in dueDates {
                            let todo = Todo(
                                task: taskName,
                                lastsAllDay: lastsAllDay,
                                startDate: date,
                                durationInSeconds: durationInSeconds,
                                priority: priority,
                                repetition: repetition,
                                endRepeat: endRepeat
                            )
                            context.insert(todo)
                            delegate.createNotification(for: todo)
                        }
                        
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        // Manually update Widget
                        WidgetCenter.shared.reloadAllTimelines()
                        dismiss()
                    }.disabled(taskName.isEmpty)
                }
                
                
            }
        }
    }
    
    private func generateDates() -> [Date] {
        // TODO:  We need to somehow include EndDate in the array of dates
        // Maybe we could get the original range substracting endDate from startDate
        // And then, for each new item in the array of dates, we use that range to create a new endDate based on the currentDay
        guard let component = repetition.addToDate.component, let value = repetition.addToDate.value else { return [startDate] }
        
        var currentDay = startDate
        var finalDay: Date?
        
        var dates: [Date] = [startDate]
        
        switch endRepeat {
        case .repeatForever:
            finalDay = Calendar.current.date(byAdding: .year, value: 50, to: currentDay)!
        case .endRepeatDate(let date):
            finalDay = date
        default:
            finalDay = nil
        }
        
        guard let finalDay else {
            return [startDate]
        }
        let calendar = Calendar.current
        
        // Start date has already been set,
        // Now we would have to add a value to get (for example) the mondays of each week, or the Februaries of each year
        // So we can repeat a task every week on Mondays, or every year in February
        if let dateComponents = getDateComponents(from: component) {
            // The user can select to have a task repeated.
            // For explaining purposes, let's assume they decided to repeat the task every week on mondays and wednesdays,
            // so we are going to first get the monday of each week until the findal day,
            // and then we would get the wednesday of each week until the final day.
            for dateComponent in dateComponents {
                // Set the startDate to its initial value
                currentDay = startDate
                
                // In order to get the mondays of each week, first we have to get the first monday of the array
                if let nextDay = calendar.nextDate(after: currentDay, matching: dateComponent, matchingPolicy: .strict) {
                    currentDay = nextDay
                    dates.append(currentDay)
                    
                    // After getting the first monday, we then add a week to it, to retrieve the second monday of the array
                    while currentDay < finalDay {
                        currentDay = calendar.date(byAdding: component, value: value, to: currentDay)!
                        if currentDay < finalDay {
                            dates.append(newDate(basedOn: currentDay, dueDate: finalDay))
                        }
                    }
                }
            }
        } else {
            // If the user didn't select the custom repetition, we simply get the dates repeated the way the user chose
            while currentDay < finalDay {
                currentDay = Calendar.current.date(byAdding: component, value: value, to: currentDay)!
                if currentDay < finalDay {
                    dates.append(currentDay)
                }
            }
        }
        return dates
    }
}


// MARK: - Custom selection Logic
extension AddTodoView {
    /// Returns a date based on the user's decision to select a specific day of the week
    /// E.g.: the second Thursday of the month
    private func newDate(basedOn currentDate: Date, dueDate: Date) -> Date {
        var date = currentDate
        if currentDate < dueDate {
            if customRepetition.isDayOfWeekSelected {
                let componenets = Calendar.current.dateComponents([.hour, .minute], from: dueDate)
                let dateComponents = DateComponents(
                    hour: componenets.hour,
                    minute: componenets.minute,
                    weekday: DateHelper.weekdayInt(from: customRepetition.weekday),
                    weekdayOrdinal: customRepetition.ordinal.rawValue
                )
                // We set the currentDate to the first day of the month,
                // so that we can fetch the desired day of the selected week using Calendar.current.nextDate
                if let updatedDate = Calendar.current.nextDate(after: currentDate.startOfMonth, matching: dateComponents, matchingPolicy: .strict) {
                    date = updatedDate
                }
            }
        }
        return date
    }
    
    /// If custom repetition is chosen, the user can select on which day the task should be repeated
    /// E.g. Repeat weekly on Wednesdays.
    /// So in that example,  we would need to fetch the first Wednesday after the startDate
    private func getDateComponents(from component: Calendar.Component) -> [DateComponents]? {
        guard case .custom = repetition else { return nil }

        switch component {
        case .year:
            return getYearlyDateComponents()
        case .month:
            return getMonthlyDateComponents()
        case .weekOfYear:
            return getWeeklyDateComponents()
        default:
            return nil
        }
    }
    
    /// Handles the logic for retrieving the date componenets for the weekly custom selection
    private func getWeeklyDateComponents() -> [DateComponents] {
        var dateComponents = [DateComponents]()
        let componenets = Calendar.current.dateComponents([.hour, .minute], from: startDate)
        for dayOfWeek in customRepetition.selectedDaysOfWeek {
            let weekdayInt = DateComponents(
                hour: componenets.hour,
                minute: componenets.minute,
                weekday: DateHelper.weekdayInt(from: dayOfWeek)
            )
            dateComponents.append(weekdayInt)
        }
        return dateComponents
    }
    
    /// Handles the logic for retrieving the date componenets for the monthly custom selection
    private func getMonthlyDateComponents() -> [DateComponents] {
        var dateComponents = [DateComponents]()
        let componenets = Calendar.current.dateComponents([.hour, .minute], from: startDate)

        // Enter monthly logic
        if customRepetition.isDayOfWeekSelected {
            let dayComponents = DateComponents(
                hour: componenets.hour,
                minute: componenets.minute,
                weekday: DateHelper.weekdayInt(from: customRepetition.weekday),
                weekdayOrdinal: customRepetition.ordinal.rawValue
            )
            dateComponents.append(dayComponents)
        } else {
            for day in customRepetition.selectedDaysOfMonth {
                let dayComponents = DateComponents(
                    day: day,
                    hour: componenets.hour,
                    minute: componenets.minute
                )
                dateComponents.append(dayComponents)
            }
        }

        return dateComponents
    }
    
    /// Handles the logic for retrieving the date componenets for the yearly custom selection
    private func getYearlyDateComponents() -> [DateComponents] {
        var dateComponents = [DateComponents]()
        var monthComponents: DateComponents
        for month in customRepetition.selectedMonthsOfYear {
            monthComponents = getMonthComponents(for: month)
            dateComponents.append(monthComponents)
        }
        return dateComponents
    }
    
    /// Fetches the necessary components to get the desired date in the selected month
    private func getMonthComponents(for month: String) -> DateComponents {
        let componenets = Calendar.current.dateComponents([.day, .hour, .minute], from: startDate)
        // If the user selected a specific day of the week
        // E.g: the second Thursday of the month
        if customRepetition.isDayOfWeekSelected {
            return DateComponents(
                month: DateHelper.monthInt(from: month),
                hour: componenets.hour,
                minute: componenets.minute,
                weekday: DateHelper.weekdayInt(from: customRepetition.weekday),
                weekdayOrdinal: customRepetition.ordinal.rawValue
            )
        } else {
            // We simply fetch the same day of the month for every year
            // E.g. Every October 2nd
            return DateComponents(
                month: DateHelper.monthInt(from: month),
                day: componenets.day,
                hour: componenets.hour,
                minute: componenets.minute
            )
        }
    }
}


#Preview {
    AddTodoView()
}
