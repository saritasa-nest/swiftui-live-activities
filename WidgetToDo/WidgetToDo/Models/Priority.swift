//
//  Priority.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import SwiftUI

enum Priority: String, Codable, CaseIterable {
    case normal, medium, high
    
    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
}
