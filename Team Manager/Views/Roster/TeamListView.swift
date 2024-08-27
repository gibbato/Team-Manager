import SwiftUI

struct TeamListView: View {
    @StateObject private var viewModel = TeamController()
    @EnvironmentObject private var authController: AuthController
    @EnvironmentObject private var selectedTeamManager: SelectedTeamManager
    @State private var showingAddPlayerSheet = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 30)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Team Roster
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.teamMembers) { member in
                            NavigationLink {
                                PlayerView(teamMember: member)
                            } label: {
                                PlayerCardView(member: member)
                            }
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .navigationTitle(selectedTeamManager.currentTeam?.name ?? "Roster")
            .background(Color.whiteSmoke)
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingAddPlayerSheet) {
                AddPlayerView { newPlayer in
                    if let newPlayer = newPlayer, let teamID = selectedTeamManager.currentTeam?.id {
                        let teamMemberInfo = TeamMemberInfo(id: newPlayer.id, role: "player")
                        viewModel.addTeamMember(teamMemberInfo, to: teamID)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Player") {
                        showingAddPlayerSheet = true
                    }
                }
            }
        }
        .onAppear {
            if let currentTeam = selectedTeamManager.currentTeam {
                viewModel.loadTeamMembers(for: currentTeam.id)
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

struct PlayerCardView: View {
    let member: TeamMember
    
    var body: some View {
        VStack {
            // Profile Picture
            if let url = member.profilePictureURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 90)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(height: 90)
                }
            } else {
                Color.gray
                    .frame(height: 90)
            }
            
            VStack {
                Text(member.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(member.role) // Assuming the role is stored in TeamMember
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
        }
        .frame(width: 150, height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.emeraldGreen)
        )
    }
}
#Preview {
    TeamListView()
        .environmentObject(AuthController())
        .environmentObject(SelectedTeamManager())
}
