//
//  DashboardView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/21/24.
//

import SwiftUI

struct tempView: View {
    @EnvironmentObject private var authController: AuthController

    var body: some View {
        Button("Logout") {
            do {
                try authController.signOut()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

#Preview {
    tempView()
        .environmentObject(AuthController())
}
