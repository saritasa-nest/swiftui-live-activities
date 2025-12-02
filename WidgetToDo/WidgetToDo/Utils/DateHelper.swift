//
//  DateHelper.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import Foundation

/// Static struct for date formatting and helper functions
struct DateHelper {
    /// Namespace enum containing static lazy DateFormatter instances
    enum Formatter {
        
        /// Formats dates in medium format with time, e.g. `19 Jul 2022`
        static let longDate: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter
            }()
        
        /// Formats dates in medium format with time, e.g. `19 Jul 2022 at 21:54`
        static let longDateWithTime: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                return formatter
            }()
        
        /// Formats dates in short  time, e.g. `21:54`
        static let shortTime: DateFormatter = {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                return formatter
            }()
    }
    
    static func monthSymbol(from shortMonthSymbol: String) -> String? {
        let formatter1 = DateFormatter()
        formatter1.setLocalizedDateFormatFromTemplate("MMM")
        
        guard let monthDate = formatter1.date(from: shortMonthSymbol) else { return nil}
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MMMM"
        return formatter2.string(from: monthDate)
    }
    
    static func weekdayInt(from weekdaySymbol: String?) -> Int {
        let calendar = Calendar.current
        if let dayIndex = calendar.weekdaySymbols.firstIndex(where: { $0 == weekdaySymbol}) {
            return dayIndex + 1
        }
        return 0
    }
    
    static func monthInt(from shortMonthSymbol: String?) -> Int {
        let calendar = Calendar.current
        if let monthIndex = calendar.shortMonthSymbols.firstIndex(where: { $0 == shortMonthSymbol}) {
            return monthIndex + 1
        }
        return 0
    }
    
    static func datesOfCurrentMonth(with weekday: Int) -> [Date] {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .weekdayOrdinal], from: Date())
        components.weekday = weekday
        var result = [Date]()

        for ordinal in 1..<6 { // maximum 5 occurrences
            components.weekdayOrdinal = ordinal
            let date = calendar.date(from: components)!
            if calendar.component(.month, from: date) != components.month! { break }
            result.append(calendar.date(from: components)!)
        }
        return result
    }
}

