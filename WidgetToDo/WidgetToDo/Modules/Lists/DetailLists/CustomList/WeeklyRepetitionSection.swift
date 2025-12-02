//
//  WeeklyRepetitionSection.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import SwiftUI

struct WeeklyRepetitionSection: View {
    @Binding var customRepetition: CustomRepetition
    var body: some View {
        Section {
            ForEach(DateFormatter().weekdaySymbols, id: \.self) { day in
                MultipleSelectionRow(title: day, isSelected: customRepetition.selectedDaysOfWeek.contains(day)) {
                    if customRepetition.selectedDaysOfWeek.contains(day) {
                        guard customRepetition.selectedDaysOfWeek.count > 1 else { return }
                        customRepetition.selectedDaysOfWeek.removeAll(where: { $0 == day })
                        
                    }
                    else {
                        customRepetition.selectedDaysOfWeek.append(day)
                        customRepetition.selectedDaysOfWeek.sort(by: sortWeekDays)
                    }
                }
            }
        }
    }
    
    func sortWeekDays(value1: String, value2: String) -> Bool {
        guard let firstItemIndex = DateFormatter().weekdaySymbols!.firstIndex(of: value1),
            let secondItemIndex = DateFormatter().weekdaySymbols!.firstIndex(of: value2) else {
                return false
        }
        return firstItemIndex < secondItemIndex
    }
}

#Preview {
    WeeklyRepetitionSection(customRepetition: .constant(.initialValue))
}
