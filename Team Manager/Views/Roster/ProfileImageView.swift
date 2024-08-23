//
//  ProfileImage.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import SwiftUI

struct ProfileImageView: View {
    let imageURL: URL

    var body: some View {
        AsyncImage(url: imageURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(radius: 10)
            } else if phase.error != nil {
                Color.red // Indicates an error
            } else {
                ProgressView() // Loading indicator
            }
        }
    }
}
