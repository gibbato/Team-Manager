import UIKit
import FirebaseStorage

class ImageUploadService {
    static let shared = ImageUploadService()
    
    private init() {}

    func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        // Define the target size for resizing (e.g., 256x256 pixels)
        let targetSize = CGSize(width: 256, height: 256)
        
        // Resize the image
        guard let resizedImage = resizeImage(image: image, targetSize: targetSize) else {
            completion(.failure(NSError(domain: "ImageResizingError", code: -1, userInfo: nil)))
            return
        }
        
        // Compress the image with a lower quality (e.g., 0.7)
        guard let imageData = compressImage(image: resizedImage, compressionQuality: 0.7) else {
            completion(.failure(NSError(domain: "ImageCompressionError", code: -1, userInfo: nil)))
            return
        }

        // Create a unique file name for the image
        let fileName = UUID().uuidString + ".jpg"

        // Get a reference to Firebase Storage
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
