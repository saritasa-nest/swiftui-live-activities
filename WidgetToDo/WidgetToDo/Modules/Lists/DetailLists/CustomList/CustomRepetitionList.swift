//
//  CustomRepetitionList.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 29/08/2024.
//

import SwiftUI

struct CustomRepetitionList: View {
    @Binding var customRepetition: CustomRepetition
    @Binding var selection: Repetition
    @State private var didTapOnFrequency = false
    @State private var didTapOnEvery = false
    @State private var valuePickerSelection = [String]()
    @State private var chooseDayOfWeek = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Frequency")
                    Spacer()
                    Text(customRepetition.frequency.rawValue.capitalized)
                        .foregroundStyle(didTapOnFrequency ? .blue : .gray)
                }
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation {
                        didTapOnFrequency.toggle()
                        if didTapOnFrequency {
                            didTapOnEvery = false
                        }
                    }
                }
                if didTapOnFrequency {
                    Picker("Frequency", selection: $customRepetition.frequency) {
                        ForEach(CustomRepetition.Frequency.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    .onChange(of: customRepetition.frequency) { _, _ in
                        valuePickerSelection = []
                        valuePickerSelection.append(customRepetition.valuePickerUnit)
                    }
                }
                
                
                HStack {
                    Text("Every")
                    Spacer()
                    Text("\(customRepetition.every) \(customRepetition.valuePickerUnit)")
                        .foregroundStyle(didTapOnEvery ? .blue : .gray)
                }
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation {
                        didTapOnEvery.toggle()
                        if didTapOnEvery {
                            didTapOnFrequency = false
                        }
                    }
                }
                
                if didTapOnEvery {
                    HStack(spacing: 0) {
                        Picker("Value", selection: $customRepetition.every) {
                            ForEach(1...999, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .pickerStyle(.wheel)
                        .padding(.trailing, -15)
                        .clipped()
                        
                        Picker("Unit", selection: .constant("")) {
                            Text(customRepetition.valuePickerUnit.capitalized)
                        }
                        .pickerStyle(.wheel)
                        .padding(.leading, -15)
                        .clipped()
                    }
                }
            } footer: {
                Text(customRepetition.description)
            }
            
            subSectionView
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: customRepetition) { oldValue, newValue in
            selection = .custom(frequency: newValue.frequency, every: newValue.every)
        }
    }
    
    @ViewBuilder
    private var subSectionView: some View {
        if customRepetition.frequency == .weekly {
            WeeklyRepetitionSection(customRepetition: $customRepetition)
        } else if customRepetition.frequency == .monthly {
            MonthlyRepetitionSection(customRepetition: $customRepetition)
        } else if customRepetition.frequency == .yearly {
            YearlyRepetitionSection(customRepetition: $customRepetition)
        }
    }
}

#Preview {
    CustomRepetitionList(customRepetition: .constant(.initialValue), selection: .constant(.biweekly))
}
