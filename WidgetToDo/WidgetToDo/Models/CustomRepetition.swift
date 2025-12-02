//
//  CustomRepetition.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 29/08/2024.
//

import Foundation


struct CustomRepetition: Codable, Equatable {
    var frequency: Frequency {
        didSet {
            isDayOfWeekSelected = false
        }
    }
    var every: Int
    var selectedDaysOfWeek: [String]
    var selectedDaysOfMonth: [Int]
    var selectedMonthsOfYear: [String]
    var isDayOfWeekSelected: Bool
    var ordinal: Ordinal
    var weekday: String
    
    var valuePickerUnit: String {
        var text = ""
        switch frequency {
        case .daily: text = "day"
        case .hourly: text = "hour"
        case .monthly: text = "month"
        case .weekly: text = "week"
        case .yearly: text = "year"
        }
        
        if every > 1 {
            return "\(text)s"
        } else {
            return text
        }
    }
    
    var description: String {
        var text: String
        if every != 1 {
            text = "Task will be repeated every \(every) \(valuePickerUnit)"
        } else {
            text = "Task will be repeated every \(valuePickerUnit)"
        }
        
        switch frequency {
        case .weekly:
            text += " on \(selectedDaysOfWeek.formatted())"
        case .monthly:
            if isDayOfWeekSelected {
                text += " on the \(ordinal.title) \(weekday) of the month"
            } else {
                text += " on the \(selectedDaysOfMonth.compactMap({$0.ordinal}).formatted())"
            }
        case .yearly:
            let months = selectedMonthsOfYear.compactMap { DateHelper.monthSymbol(from: $0)}
            text += " in \(months.formatted())"
            if isDayOfWeekSelected {
                text += " on the \(ordinal.title) \(weekday) of the month"
            }
        default: break
        }
        return text
    }
}

extension CustomRepetition {
    enum Frequency: String, Codable, CaseIterable {
        case hourly
        case daily
        case weekly
        case monthly
        case yearly
    }
    
    enum Ordinal: Int, Codable, CaseIterable {
        case first = 1
        case second
        case third
        case fourth
        case fifth
        case last
        
        var title: String {
            switch self {
            case .first: return "first"
            case .second: return "second"
            case .third: return "third"
            case .fourth: return "fourth"
            case .fifth: return "fifth"
            case .last: return "last"
            }
        }
    }
}

extension CustomRepetition {
    static var initialValue = CustomRepetition(
        frequency: .daily,
        every: 1,
        selectedDaysOfWeek: [DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: .now) - 1]],
        selectedDaysOfMonth: [Calendar.current.component(.day, from: .now)],
        selectedMonthsOfYear: [DateFormatter().shortMonthSymbols[Calendar.current.component(.month, from: .now) - 1]],
        isDayOfWeekSelected: false,
        ordinal: .first,
        weekday: DateFormatter().weekdaySymbols.first!
    )
}
