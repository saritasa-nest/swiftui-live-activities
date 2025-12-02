//
//  TodoListBundle.swift
//  TodoList
//
//  Created by Nicolas Cobelo on 19/07/2024.
//

import WidgetKit
import SwiftUI

@main
struct TodoListBundle: WidgetBundle {
    var body: some Widget {
        TodoList()
        LiveActivityWidget()
    }
}
