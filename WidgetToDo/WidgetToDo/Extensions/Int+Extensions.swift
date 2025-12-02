//
//  Int+Extensions.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 18/09/2024.
//

import Foundation

extension Int {
    var ordinal: String? {
        return ordinalFormatter.string(from: NSNumber(value: self))
    }
}

private var ordinalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter
}()
