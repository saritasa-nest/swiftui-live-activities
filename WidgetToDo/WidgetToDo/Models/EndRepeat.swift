//
//  EndRepeat.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import Foundation

enum EndRepeat: Codable, CaseIterable, Hashable, Identifiable {
    var id: Self {
           return self
       }
    
    static var allCases: [EndRepeat] {
        return [.repeatForever, .endRepeatDate(.now)]
    }
    
    case repeatForever
    case endRepeatDate(Date)
    
    var title: String {
        switch self {
        case .repeatForever:
            return "Repeat Forever"
        case .endRepeatDate:
            return "End Repeat Date"
        }
    }
    
    var description: String {
        switch self {
        case .repeatForever:
            return "Repeat Forever"
        case .endRepeatDate(let date):
            return DateHelper.Formatter.longDate.string(from: date)
        }
    }
    
}

extension EndRepeat {
    var date: Date {
        get {
            switch self {
            case let .endRepeatDate(date): return date
            case .repeatForever: return .now
            }
        }
        set {
            switch self {
            case .endRepeatDate: self = .endRepeatDate(newValue)
            case .repeatForever: self = .repeatForever
            }
        }
    }
}
