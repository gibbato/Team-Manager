//
//  Team_ManagerApp.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/21/24.
//

import SwiftUI

@main
struct Team_ManagerApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authController = AuthController()
    @StateObject private var selectedTeamManager = SelectedTeamManager()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(authController)
                    .environmentObject(selectedTeamManager)
                
            }
        }
    }
}
