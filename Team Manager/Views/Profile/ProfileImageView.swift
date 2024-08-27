//
//  ProfileImage.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import SwiftUI

struct ProfileImageView: View {
    let imageURL: URL?

    var body: some View {
        if let url = imageURL {
            AsyncImage(url: url) { phase in
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
                    // Display default image in case of error loading the URL
                    Image("defaultUser")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 4)
                        )
                        .shadow(radius: 10)
                } else {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            }
        } else {
            // Display default image when the URL is nil
            Image("defaultUser")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 4)
                )
                .shadow(radius: 10)
        }
    }
}
