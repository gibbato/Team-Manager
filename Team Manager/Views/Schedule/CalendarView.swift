//
//  CalendarView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/28/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @EnvironmentObject var viewModel: ScheduleViewModel

    private let daysToShow = 30 // Number of days to show in the sliding calendar

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<daysToShow, id: \.self) { offset in
                    let date = Calendar.current.date(byAdding: .day, value: offset, to: Date())!
                    CalendarDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(selectedDate, inSameDayAs: date),
                        hasEvents: viewModel.eventDates.contains(Calendar.current.startOfDay(for: date))
                    )
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
    CalendarView(selectedDate: .constant(Date()))
        .environmentObject(ScheduleViewModel())
}
