import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authController: AuthController
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            if let profileImageURL = viewModel.profileImageURL {
                ProfileImageView(imageURL: profileImageURL)
            } else {
                Text("No profile image")
                    .font(.headline)
            }

            if viewModel.isLoading {
                ProgressView()
            }

            Button("Select and Upload Image") {
                showingImagePicker = true
            }
            .padding()

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
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

