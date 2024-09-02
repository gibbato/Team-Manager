//
//  CalendarView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/28/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    private let daysToShow = 30 // Number of days to show in the sliding calendar
    let events: [Date] // Add the list of event dates to the CalendarView

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<daysToShow, id: \.self) { offset in
                    let date = Calendar.current.date(byAdding: .day, value: offset, to: Date())!
                    CalendarDayView(date: date,
                                    isSelected: Calendar.current.isDate(selectedDate, inSameDayAs: date),
                                    hasEvents: events.contains { Calendar.current.isDate($0, inSameDayAs: date) })
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    // Mocked events for the preview
    let mockEvents = [
        Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 10, to: Date())!
    ]

    return CalendarView(selectedDate: .constant(Date()), events: mockEvents)
}
