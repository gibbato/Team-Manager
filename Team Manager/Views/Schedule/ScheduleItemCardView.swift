//
//  ScheduleItemCardView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/28/24.
//

import SwiftUI

struct ScheduleItemCardView: View {
    let item: ScheduleItem

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(item.title)
                .font(.headline)
            Text(item.date, style: .date)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(item.type.rawValue.capitalized)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.veryLightGray)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding([.horizontal])
    }
}


#Preview {
    let sampleItem = ScheduleItem(id: "1", title: "Practice", date: Date(), type: .practice, teamID: "team1")
    return ScheduleItemCardView(item: sampleItem)
        .previewLayout(.sizeThatFits)
        .padding()
}
