import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authController: AuthController
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingImagePicker = false


    @State private var selectedImage: UIImage?
    @State private var showingEditProfileSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // User Photo and Name
            HStack(spacing: 20) {
                // Profile Image on the left
                ProfileImageView(imageURL: viewModel.profileImageURL)
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        showingImagePicker = true
                    }

                // User Name and Edit Button on the right
                VStack(alignment: .leading) {
                    Text(viewModel.getUserName())
                        .font(.title)
                        .fontWeight(.bold)
                    
                    //Player info
                    VStack {
                        HStack {
                            Text("\(viewModel.getPrimaryPosition()) | B/T: \(viewModel.shortBattingStance)/\(viewModel.shortThrowingHand) | #\(viewModel.getJerseyNumber())")
                        }
                    }

                    // Edit Button
                    Button(action: {
                        showingEditProfileSheet = true
                    }) {
                        HStack {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.blue)
                            Text("Edit")
                                .foregroundColor(.blue)
                        }
                        .font(.headline)
                    }
                }

                Spacer()
            }
            .padding([.top, .horizontal])

            
          /*
            // User Information
            VStack(alignment: .leading, spacing: 10) {
                Text("User Information")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack {
                    Text("Primary Position:")
                    Spacer()
                    Text(viewModel.getPrimaryPosition())
                }
                HStack {
                    Text("Secondary Position:")
                    Spacer()
                    Text(viewModel.getSecondaryPosition())
                }
                HStack {
                    Text("Jersey Number:")
                    Spacer()
                    Text("\(viewModel.getJerseyNumber())")
                }
                HStack {
                    Text("Throwing Hand:")
                    Spacer()
                    Text(viewModel.getThrowingHand())
                }
                HStack {
                    Text("Batting Stance:")
                    Spacer()
                    Text(viewModel.getBattingStance())
                }
            }
            .padding([.horizontal])
            
            */

            // Previous Games (Placeholder)
            VStack(alignment: .leading, spacing: 10) {
                Text("Previous Games")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Empty component for future games display
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(Text("Previous games will be displayed here").foregroundColor(.gray))
            }
            .padding([.horizontal, .bottom])
            
            Spacer()

            if viewModel.isLoading {
                ProgressView()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .sheet(isPresented: $showingEditProfileSheet) {
            EditProfileView(viewModel: viewModel) // Pass the view model to the edit view
        }
        .onChange(of: selectedImage) { 
            if let image = selectedImage, let userId = authController.userId {
                viewModel.uploadAndSetProfileImage(image, for: userId)
            }
        }
      
        .onAppear {
            if let userId = authController.userId {
                viewModel.loadTeamMemberData(for: userId)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthController())
}
