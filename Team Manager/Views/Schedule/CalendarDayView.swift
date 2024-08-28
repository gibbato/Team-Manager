//
//  CalendarDayView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/28/24.
//

import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEvents: Bool

    var body: some View {
        VStack {
            Text(dayString)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(10)
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())

            if hasEvents {
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
                    .padding(.top, 2)
            }
        }
    }

    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarDayView(date: Date(), isSelected: true, hasEvents: true)
}
