//
//  AddProfilePicView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import SwiftUI
import FirebaseStorage

struct AddProfilePicView: View {
    
    @State private var profileImageURL: URL?
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if let profileImageURL = profileImageURL {
                ProfileImageView(imageURL: profileImageURL)
            } else {
                Text("No profile image")
                    .font(.headline)
            }
            
            Button("Select and Upload Image") {
                showingImagePicker = true
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) {
            if let image = selectedImage {
                uploadProfileImage(image) { result in
                    switch result {
                    case .success(let url):
                        profileImageURL = url
                    case .failure(let error):
                        print("Failed to upload image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversionError", code: -1, userInfo: nil)))
            return
        }
        
        // Create a unique file name for the image
        let fileName = UUID().uuidString + ".jpg"
        
        // Get a reference to the Firebase Storage
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profile_pictures/\(fileName)")
        
        // Create metadata for the image
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the image data
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Get the download URL for the image
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let url = url {
                    completion(.success(url))
                } else {
                    completion(.failure(NSError(domain: "URLRetrievalError", code: -1, userInfo: nil)))
                }
            }
        }
    }
}

#Preview {
    AddProfilePicView()
}
