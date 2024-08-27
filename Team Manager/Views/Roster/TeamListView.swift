import SwiftUI

struct TeamListView: View {
    @StateObject private var viewModel = TeamController()
    @EnvironmentObject private var authController: AuthController
    @State private var showingAddPlayerSheet = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 30)
    ]
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Roster")
            .background(Color.whiteSmoke)
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingAddPlayerSheet) {
                AddPlayerView { newPlayer in
                    if let newPlayer = newPlayer {
                        viewModel.addTeamMember(newPlayer)
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
            if let userID = authController.userId {
                viewModel.loadTeam(for: userID)
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
            if let url = member.profilePictureURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()  // Fill the area while maintaining aspect ratio
                        .frame(height: 90)  // 90% of the card height
                        .clipped()  // Clip the image to the frame
                } placeholder: {
                    ProgressView()
                        .frame(height: 90)
                }
            } else {
                Color.gray
                    .frame(height: 90)  // 90% of the card height
            }
            
            VStack {
                Text(member.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(member.role)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
        }
        .frame(width: 150, height: 170)  // Ensure all cards are the same size
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(member.isAvailable ? Color.emeraldGreen : Color.alizarinRed)
        )
    }
}

#Preview {
    TeamListView()
        .environmentObject(AuthController())
}
