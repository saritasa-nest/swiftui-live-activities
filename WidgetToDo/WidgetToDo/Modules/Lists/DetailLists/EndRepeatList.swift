//
//  EndRepeatList.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import SwiftUI

struct EndRepeatList: View {
    @Binding var selection: EndRepeat
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            ForEach(EndRepeat.allCases) { item in
                HStack {
                    Text(item.title)
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                        .opacity(isEqual(to: item) ? 1 : 0)
                }
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selection = item
                    }
                }
                
            }
            if selection != .repeatForever {
                DatePicker("End Date",
                           selection: $selection.date,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func isEqual(to item: EndRepeat) -> Bool{
        switch selection {
        case .repeatForever:
            return selection == item
        case .endRepeatDate:
            if case .endRepeatDate = item {
                return true
            } else {
                return false
            }
        }
    }
}

#Preview {
    EndRepeatList(selection: .constant(.repeatForever))
}
