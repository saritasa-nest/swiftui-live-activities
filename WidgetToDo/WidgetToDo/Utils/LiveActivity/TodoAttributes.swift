//
//  TodoAttributes.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 01/11/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TodoAttributes: ActivityAttributes {
    
    enum Status: Codable, Hashable {
        case pending
        case inProgress
        case completed
        
        var text: String {
            switch self {
            case .pending: return "Pending"
            case .inProgress: return "In Progress"
            case .completed: return "Completed"
            }
        }
    }
    
    // Dynamic data
    public struct ContentState: Codable, Hashable {
        var status: Status
        var lastUpdated: Date
    }
    
    // Static data
    let target: Target
}

struct Target: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var startTime: Date
    var duration: Int?
}

extension Target {
    static var testTarget = Target(id: "130", name: "Review project", startTime: .now, duration: 60)
}

extension TodoAttributes {
    static var preview: TodoAttributes {
        TodoAttributes(target: Target.testTarget)
    }
}
