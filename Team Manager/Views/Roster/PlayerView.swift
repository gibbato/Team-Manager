import SwiftUI

struct PlayerView: View {
    let teamMember: TeamMember

    var body: some View {
        ScrollView {
            VStack (alignment: .center) {
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
                    Text(teamMember.role)
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
    }
}

#Preview {
    let mockTeamMember = TeamMember(id: "1", name: "John Doe", email: "john@example.com", role: "Player", isAvailable: false, profilePictureURL: URL(string: "https://example.com/image1.jpg"))
    return PlayerView(teamMember: mockTeamMember)
        .preferredColorScheme(.dark)
}
