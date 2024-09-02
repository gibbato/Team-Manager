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
        VStack(spacing: 2) { // Control the spacing between elements
            Text(dayString)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 40, height: 40) // Fixed frame for alignment
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())
            
            if hasEvents {
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
                    .padding(.top, 2) // Add padding to ensure consistent spacing
                    .offset(y: -14)
            } else {
                Spacer().frame(height: 6) // Add spacer to maintain consistent height
            }
        }
        .frame(width: 40, height: 60) // Ensure each day takes up the same vertical space
    }

    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

#Preview {
    // Mocked day view for preview
    let mockDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    return VStack {
        CalendarDayView(date: mockDate, isSelected: true, hasEvents: true)
        CalendarDayView(date: mockDate, isSelected: false, hasEvents: true)
        CalendarDayView(date: mockDate, isSelected: false, hasEvents: false)
    }
    .padding()
}
