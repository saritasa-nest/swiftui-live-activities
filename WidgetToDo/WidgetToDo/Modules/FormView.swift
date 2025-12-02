//
//  FormView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import SwiftUI

struct FormView: View {
    @Binding var taskName: String
    @Binding var lastsAllDay: Bool
    @Binding var startDate: Date
    @Binding var priority: Priority
    @Binding var repetition: Repetition
    @Binding var endRepeat: EndRepeat?
    @Binding var customRepetition: CustomRepetition
    
    @Binding var durationInSeconds: Int?
    
    @State private var hasDuration = false
    var body: some View {
        Form {
            Section {
                TextField("Take out trash", text: $taskName)
            } header: {
                Text("Title")
            }
            
            Section {
                Toggle(isOn: $lastsAllDay) {
                    Text("All day")
                }
                .onChange(of: lastsAllDay) { _, newValue in
                   updateStartDate(basedOn: newValue)
                }
                DatePicker("Starts", selection: $startDate, displayedComponents: datePickerComponents)
                Toggle(isOn: $hasDuration) {
                    Text("Duration")
                }
                if hasDuration {
                    CustomPickerView(seconds: $durationInSeconds)
                }
                
                NavigationLink(destination: { RepetitionList(selection: $repetition, customRepetition: $customRepetition) }) {
                    HStack {
                        Text("Repeat")
                        Spacer()
                        Text(repetition.description)
                            .foregroundStyle(.placeholder)
                    }
                    .onChange(of: repetition) { oldValue, newValue in
                        if oldValue == .never, newValue != .never {
                            endRepeat = .repeatForever
                        }
                    }
                }
                
                if let endRepeat, repetition != .never {
                    NavigationLink(destination: { destinationView }) {
                        HStack {
                            Text("End Repeat")
                            Spacer()
                            Text(endRepeat.description)
                                .foregroundStyle(.placeholder)
                        }
                    }
                }
            } header: {
                Text("Due Date")
            }
            .onChange(of: hasDuration) { _, newValue in
                if !newValue {
                    durationInSeconds = nil
                }
            }
            
            Section {
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                }.pickerStyle(.segmented)
            } header: {
                Text("Priority")
            }
        }
    }
    
    private var destinationView: some View {
        EndRepeatList(selection: Binding<EndRepeat>(
            get: {
                self.endRepeat ?? .repeatForever
            },
            set: {
                self.endRepeat = $0
            }
        ))
    }
    
    private var datePickerComponents: DatePicker<Text>.Components {
        if lastsAllDay {
            return .date
        } else {
            return [.date, .hourAndMinute]
        }
    }
    
    private func updateStartDate(basedOn newValue: Bool) {
        // If user has set lastsAllDay to true
        // We set the starting time to 00:00
        if newValue {
            startDate = startDate.startOfDay
        } else {
            // We use the current time for starting time
            startDate = startDate.currentHour()
        }
    }
}

#Preview {
    FormView(
        taskName: .constant(""),
        lastsAllDay: .constant(false),
        startDate: .constant(.now),
        priority: .constant(.medium),
        repetition: .constant(.never),
        endRepeat: .constant(nil),
        customRepetition: .constant(.initialValue),
        durationInSeconds: .constant(60)
    )
}
