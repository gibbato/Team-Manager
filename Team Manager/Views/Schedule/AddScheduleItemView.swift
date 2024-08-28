//
//  AddScheduleItemView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/27/24.
//

import SwiftUI

struct AddScheduleItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var type: ScheduleItemType = .game
    let teamID: String
    let viewModel: ScheduleViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Picker("Type", selection: $type) {
                        Text("Game").tag(ScheduleItemType.game)
                        Text("Practice").tag(ScheduleItemType.practice)
                        Text("Deadline").tag(ScheduleItemType.deadline)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add Event")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                viewModel.addScheduleItem(title: title, date: date, type: type, teamID: teamID)
                dismiss()
            })
        }
    }
}

#Preview {
    AddScheduleItemView(
        teamID: "teamID1",
        viewModel: ScheduleViewModel()
    )
}
