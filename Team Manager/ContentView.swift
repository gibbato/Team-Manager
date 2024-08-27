//
//  ContentView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/21/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authController: AuthController
    @EnvironmentObject private var selectedTeamManager: SelectedTeamManager
    
    var body: some View {
        Group {
            switch authController.authState {
            case .undefined:
                AuthView()
            case .notAuthenticated:
                AuthView()
            case .authenticated:
                BottomNavigationView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthController())
        .environmentObject(SelectedTeamManager())
}
