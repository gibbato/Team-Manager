import SwiftUI

struct PlayerView: View {
    @State private var teamMember: TeamMember?
    let memberInfo: TeamMemberInfo
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let teamMember = teamMember {
                ScrollView {
                    VStack(alignment: .center) {
                        // Profile Picture
                        if let url = teamMember.profilePictureURL {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.emeraldGreen, lineWidth: 4)
                                    )
                                    .shadow(radius: 10)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 150, height: 150)
                            }
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 150, height: 150)
                                .overlay(
                                    Circle()
                                        .stroke(Color.emeraldGreen, lineWidth: 4)
                                )
                                .shadow(radius: 10)
                        }

                        VStack(alignment: .center) {
                            // Divider Line
                            Rectangle()
                                .frame(height: 2)
                                .foregroundStyle(teamMember.isAvailable ? Color.emeraldGreen : Color.alizarinRed)
                                .padding(.vertical)

                            // Player Name
                            Text("Player Details")
                                .font(.title.bold())
                                .padding(.bottom, 5)

                            Text(teamMember.name)
                                .font(.title2.bold())
                                .padding(.bottom, 2)

                            Text("Email")
                                .font(.headline)
                                .padding(.top, 10)
                            Text(teamMember.email)
                                .font(.body)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)

                            Text("Role")
                                .font(.headline)
                                .padding(.top, 10)
                            Text(memberInfo.role)
                                .font(.body)
                                .foregroundColor(.deepSkyBlue)
                                .padding(.bottom, 5)

                            Text("Availability")
                                .font(.headline)
                                .padding(.top, 10)
                            Text(teamMember.isAvailable ? "Available" : "Not Available")
                                .font(.body)
                                .foregroundColor(teamMember.isAvailable ? .emeraldGreen : .red)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                .navigationTitle(teamMember.name)
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.whiteSmoke)
            } else if isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .onAppear(perform: loadTeamMember)
    }

    private func loadTeamMember() {
        FirestoreService().fetchTeamMember(byUID: memberInfo.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let member):
                    self.teamMember = member
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = "Failed to load team member: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    let mockTeamMemberInfo = TeamMemberInfo(id: "1", role: "Player")
    return PlayerView(memberInfo: mockTeamMemberInfo)
        .preferredColorScheme(.dark)
}
