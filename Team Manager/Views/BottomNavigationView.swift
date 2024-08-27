//
//  BottomNavigationView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/23/24.
//

import SwiftUI

struct BottomNavigationView: View {
    var body: some View {
        TabView {
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            TeamListView()
                .tabItem {
                    Label("Roster", systemImage: "house")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    BottomNavigationView()
        .environmentObject(AuthController())
}
