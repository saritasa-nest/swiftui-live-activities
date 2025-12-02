//
//  Repetition.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import Foundation

enum Repetition: Codable {
    case never
    case hourly
    case daily
    case weekly
    case biweekly
    case monthly
    case every3Months
    case every6Months
    case yearly
    case custom(frequency: CustomRepetition.Frequency, every: Int)
    
    static var mainCases: [Repetition] {
        return [.never, .hourly, .daily, .weekly, .biweekly, .monthly, .every3Months, .every6Months, .yearly]
    }
    
    var description: String {
        switch self {
        case .never: return "Never"
        case .hourly: return "Hourly"
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .biweekly: return "Biweekly"
        case .monthly: return "Monthly"
        case .every3Months: return "Every 3 months"
        case .every6Months: return "Every 6 months"
        case .yearly: return "Yearly"
        case .custom: return "Custom"
        }
    }
    var addToDate: (component: Calendar.Component?, value: Int?) {
        switch self {
        case .never: return (nil, nil)
        case .hourly: return (.hour, 1)
        case .daily: return (.day, 1)
        case .weekly: return (.weekOfYear, 1)
        case .biweekly: return (.weekOfYear, 2)
        case .monthly: return (.month, 1)
        case .every3Months: return (.month, 3)
        case .every6Months: return (.month, 6)
        case .yearly: return (.year, 1)
        case .custom(let frequency, let every):
            return (frequencyMapper(using: frequency), every)
        }
    }
    
    private func frequencyMapper(using frequency: CustomRepetition.Frequency) -> Calendar.Component {
        switch frequency {
        case .hourly: return .hour
        case .daily: return .day
        case .weekly: return .weekOfYear
        case .monthly: return .month
        case .yearly: return .year
        }
    }
    
    func isEqualToCustom() -> Bool {
        switch self {
        case .custom: return true
        default: return false
        }
    }
     
}

extension Repetition: Hashable {
    var id: Int { hashValue }
}
