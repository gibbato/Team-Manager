//
//  ScheduleItemDetailView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/28/24.
//

import SwiftUI

struct ScheduleItemDetailView: View {
    let scheduleItem: ScheduleItem
    @EnvironmentObject private var authController: AuthController
    @EnvironmentObject private var selectedTeamManager: SelectedTeamManager
    
    var body: some View {
        VStack {
            Text(scheduleItem.title)
                .font(.headline)
            
            Text(scheduleItem.date, style: .date)
                .font(.subheadline)
            
            HStack {
                Button(action: {
                    confirmAttendance(willAttend: true)
                }) {
                    Text("Will Attend")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    confirmAttendance(willAttend: false)
                }) {
                    Text("Won't Attend")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            loadAttendanceStatus()
        }
    }
    
    private func confirmAttendance(willAttend: Bool) {
        guard let userID = authController.userId else { return }
        FirestoreService().updateAttendanceConfirmation(for: scheduleItem.id, playerID: userID, willAttend: willAttend) { result in
            switch result {
            case .success:
                print("Attendance confirmed.")
            case .failure(let error):
                print("Failed to confirm attendance: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadAttendanceStatus() {
        guard let userID = authController.userId else { return }
        if let status = scheduleItem.confirmations[userID] {
            print("Current status: \(status ? "Will Attend" : "Won't Attend")")
        } else {
            print("No status set")
        }
    }
}

#Preview {
    return ScheduleItemDetailView(scheduleItem: ScheduleItem(title: "Game vs Tigers", date: Date(), type: .game, teamID: "team123"))
        .environmentObject(AuthController())
        .environmentObject(SelectedTeamManager())
}
