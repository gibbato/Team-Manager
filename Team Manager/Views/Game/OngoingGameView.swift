//
//  OngoingGameView.swift
//  Team Manager
//
//  Created by Michael Gibson on 9/2/24.
//

import SwiftUI

struct OngoingGameView: View {
    let scheduleItem: ScheduleItem

    var body: some View {
        VStack {
            Text("Ongoing Game")
                .font(.largeTitle)
                .bold()
                .padding()

            Text(scheduleItem.title)
                .font(.title)
                .padding()

            Text("Date: \(scheduleItem.date, style: .date)")
                .font(.headline)
                .padding()

            // Additional game-related views and controls go here.
            // For example, live score updates, player statistics, etc.
            Spacer()
        }
        .navigationTitle("Game In Progress")
    }
}

#Preview {
    OngoingGameView(scheduleItem: ScheduleItem(title: "Game", date: Date(), type: .game, teamID: "teamID"))
}
