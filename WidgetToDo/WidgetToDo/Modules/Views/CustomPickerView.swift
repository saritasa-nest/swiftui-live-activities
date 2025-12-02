//
//  CustomPickerView.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 24/10/2024.
//

import SwiftUI

struct CustomPickerView: View {
    @Binding public var seconds: Int?

    var hoursArray = [Int](0..<24)
    var minutesArray = [Int](0..<60)

    private let secondsInMinute = 60
    private let secondsInHour = 3600
    private let secondsInDay = 86400

    @State private var hourSelection = 0
    @State private var minuteSelection = 1

    private let frameHeight: CGFloat = 160
    
    init(seconds: Binding<Int?>) {
        _seconds = seconds
        updatePickers()
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Picker("Pick Hours", selection: $hourSelection) {
                        ForEach(hoursArray, id: \.self) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.trailing, -15)
                    .clipped()
                    
                    Picker("Hour Unit", selection: .constant("")) {
                        Text("h")
                    }
                    .pickerStyle(.wheel)
                    .padding(.leading, -15)
                    .clipped()
                }
                .onChange(of: hourSelection) { _, _ in
                    seconds = totalInSeconds
                }
                
                HStack(spacing: 0) {
                    Picker("Pick Minutes", selection: $minuteSelection) {
                        ForEach(minutesArray, id: \.self) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.trailing, -15)
                    .clipped()
                    
                    Picker("Minute Unit", selection: .constant("")) {
                        Text("min")
                    }
                    .pickerStyle(.wheel)
                    .padding(.leading, -15)
                    .clipped()
                }
                .onChange(of: minuteSelection) { _, _ in
                    seconds = totalInSeconds
                }
            }
        }
        .frame(height: frameHeight)
    }

    func updatePickers() {
        guard let seconds else { return }
        hourSelection = seconds * secondsInHour
        minuteSelection = seconds * secondsInMinute
    }

    var totalInSeconds: Int {
        return hourSelection * secondsInHour + minuteSelection * secondsInMinute
    }
}
