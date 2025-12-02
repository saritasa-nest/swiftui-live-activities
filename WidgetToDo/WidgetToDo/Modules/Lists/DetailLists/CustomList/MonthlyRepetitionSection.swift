//
//  MonthlyRepetitionSection.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 03/09/2024.
//

import SwiftUI

struct MonthlyRepetitionSection: View {
    enum MonthlySelection: String, CaseIterable {
        case each = "Each"
        case onThe = "On The..."
    }
    
    @Binding var customRepetition: CustomRepetition
    @State private var selection: MonthlySelection = .each
    
    var columns: [GridItem] = [
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0)
       ]

    var body: some View {
        Section {
            ForEach(MonthlySelection.allCases, id: \.self) { item in
                    HStack {
                        Text(item.rawValue)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                            .opacity(selection == item ? 1 : 0)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selection = item
                        }
                    }
                
            }
                switch selection {
                case .each:
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(1...31, id: \.self) { i in
                            MultipleSelectionCell(title: "\(i)", isSelected: customRepetition.selectedDaysOfMonth.contains(i)) {
                                if customRepetition.selectedDaysOfMonth.contains(i) {
                                    guard customRepetition.selectedDaysOfMonth.count > 1 else { return }
                                    customRepetition.selectedDaysOfMonth.removeAll(where: { $0 == i })
                                }
                                else {
                                    customRepetition.selectedDaysOfMonth.append(i)
                                    customRepetition.selectedDaysOfMonth.sort(by: {$0 < $1})
                                }
                            }
                        }
                     }
                    .padding(.vertical, -11)
                    .padding(.horizontal, -20)
                case .onThe:
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
        .onAppear(perform: {
            if customRepetition.isDayOfWeekSelected {
                selection = .onThe
            }
        })
        .onChange(of: selection) { _, newValue in
            if newValue == .onThe {
                customRepetition.isDayOfWeekSelected = true
            } else {
                customRepetition.isDayOfWeekSelected = false
            }
        }
    }
}

#Preview {
    MonthlyRepetitionSection(customRepetition: .constant(.initialValue))
}
