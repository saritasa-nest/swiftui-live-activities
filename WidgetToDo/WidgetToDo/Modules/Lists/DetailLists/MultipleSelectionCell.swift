//
//  MultipleSelectionCell.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import SwiftUI

struct MultipleSelectionCell: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .stroke(lineWidth: 1)
                .foregroundStyle(isSelected ? .black.opacity(0.6) : .gray.opacity(0.3))
            Rectangle()
                .foregroundStyle(isSelected ? .blue : .clear)
            Text(title)
                .foregroundStyle(isSelected ? .black : .primary)
        }
        .frame(height: 50)
        .contentShape(.rect)
        .onTapGesture { action() }
    }
}

#Preview {
    MultipleSelectionCell(title: "", isSelected: false, action: {})
}
