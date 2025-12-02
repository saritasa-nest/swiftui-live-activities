//
//  RepetitionList.swift
//  WidgetToDo
//
//  Created by Nicolas Cobelo on 27/08/2024.
//

import SwiftUI

struct RepetitionList: View {
    @Binding var selection: Repetition
    @Binding var customRepetition: CustomRepetition
    @Environment(\.dismiss) var dismiss
    @State private var didTapOnCustom = false
 
    var body: some View {
        List {
            Section {
                ForEach(Repetition.mainCases, id: \.self) { item in
                    HStack {
                        Text(item.description)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                            .opacity(selection == item ? 1 : 0)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        selection = item
                        dismiss()
                    }
                    
                }
            }

            Section {
                HStack {
                    Text("Custom")
                    Spacer()
                    Image(systemName: selection.isEqualToCustom() ? "checkmark" : "chevron.right")
                        .foregroundStyle(selection.isEqualToCustom() ? .blue : .gray)
                }
                .contentShape(.rect)
                .onTapGesture {
                    //selection = .custom(frequency: customFrequency, every: customValue)
                    selection = .custom(frequency: .daily, every: 1)
                    didTapOnCustom = true
                }
            } footer: {
                if selection.isEqualToCustom() {
                    Text(customRepetition.description)
                }
            }
           
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $didTapOnCustom) {
            CustomRepetitionList(customRepetition: $customRepetition, selection: $selection)
        }
    }
}

#Preview {
    RepetitionList(selection: .constant(.never), customRepetition: .constant(.initialValue))
}
