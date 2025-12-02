//
//  YearlyRepetitionSection.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import SwiftUI

struct YearlyRepetitionSection: View {
    @Binding var customRepetition: CustomRepetition
    
    var columns: [GridItem] = [
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0)
       ]
    
    var body: some View {
        Section {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(DateFormatter().shortMonthSymbols, id: \.self) { month in
                    MultipleSelectionCell(title: month, isSelected: customRepetition.selectedMonthsOfYear.contains(month)) {
                        if customRepetition.selectedMonthsOfYear.contains(month) {
                            guard customRepetition.selectedMonthsOfYear.count > 1 else { return }
                            customRepetition.selectedMonthsOfYear.removeAll(where: { $0 == month })
                        }
                        else {
                            customRepetition.selectedMonthsOfYear.append(month)
                            customRepetition.selectedMonthsOfYear.sort(by: sortMonths)
                        }
                    }
                }
             }
            .padding(.vertical, -11)
            .padding(.horizontal, -20)
        }
        
        Section {
            Toggle(isOn: $customRepetition.isDayOfWeekSelected.animation(.easeInOut)) {
                Text("Days of Week")
            }
            if customRepetition.isDayOfWeekSelected {
                HStack(spacing: 0) {
                    Picker("Ordinal", selection: $customRepetition.ordinal) {
                        ForEach(CustomRepetition.Ordinal.allCases, id: \.self) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.trailing, -15)
                    .clipped()

                    Picker("Day", selection: $customRepetition.weekday) {
                        ForEach(DateFormatter().weekdaySymbols, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.leading, -15)
                                .clipped()
                }
            }
        }
    }
    
    func sortMonths(value1: String, value2: String) -> Bool {
        guard let firstItemIndex = DateFormatter().shortMonthSymbols!.firstIndex(of: value1),
            let secondItemIndex = DateFormatter().shortMonthSymbols!.firstIndex(of: value2) else {
                return false
        }
        return firstItemIndex < secondItemIndex
    }
}

#Preview {
    YearlyRepetitionSection(customRepetition: .constant(.initialValue))
}
