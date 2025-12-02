//
//  Todo.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import SwiftUI
import SwiftData

@Model
class Todo {
    
    ///Used to update the to-do state of the widgets
    private(set) var id: String = UUID().uuidString
    var task: String
    var isCompleted: Bool = false
    var lastsAllDay: Bool = false
    var startDate: Date = Date.now
    var durationInSeconds: Int?
    var priority: Priority = Priority.normal
    var repetition: Repetition = Repetition.never
    var endRepeat: EndRepeat?
    var lastUpdated: Date = Date.now
    
    init(
        task: String,
        lastsAllDay: Bool,
        startDate: Date,
        durationInSeconds: Int?,
        priority: Priority,
        repetition: Repetition,
        endRepeat: EndRepeat? = nil
    ) {
        self.task = task
        self.lastsAllDay = lastsAllDay
        self.startDate = startDate
        self.durationInSeconds = durationInSeconds
        self.priority = priority
        self.repetition = repetition
        self.endRepeat = endRepeat
    }
    
    var isDueToday: Bool {
        let dateRange = Date.now ... Date.now.endOfDay
        return dateRange.contains(startDate)
    }
    
    
    var isExpired: Bool {
        startDate < .now
    }
}

extension Todo {
    static let example = Todo(
        task: "Brush teeth",
        lastsAllDay: false,
        startDate: .now,
        durationInSeconds: 60,
        priority: .normal,
        repetition: .never
    )
}
