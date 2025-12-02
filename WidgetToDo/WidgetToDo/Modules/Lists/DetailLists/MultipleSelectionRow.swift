//
//  MultipleSelectionRow.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import SwiftUI

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        HStack {
            Text(self.title)
            Spacer()
            Image(systemName: "checkmark")
                .foregroundStyle(.blue)
                .opacity(isSelected ? 1 : 0)
        }
        .contentShape(.rect)
        .onTapGesture { action() }
    }
}

#Preview {
    MultipleSelectionRow(title: "", isSelected: false, action: {})
}
