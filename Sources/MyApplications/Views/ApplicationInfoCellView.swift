//
//  ApplicationInfoCellView.swift
//  
//
//  Created by Abenx on 2023/2/15.
//

import SwiftUI

struct ApplicationInfoCellView: View {
    @Binding var appIdentifier: String?
    let applicationInfo: LookUpResponseResult.Result
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let iconURLString = applicationInfo.artworkUrl100,
               let iconURL = URL(string: iconURLString) {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 60, height: 60)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(.secondary, lineWidth: 0.3))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            VStack(alignment: .leading) {
                if let trackName = applicationInfo.trackName {
                    Text(trackName)
                        .bold()
                        .lineLimit(1)
                }
                if let description = applicationInfo.description {
                    DisclosureGroup {
                        Text(description)
                            .foregroundColor(.secondary)
                    } label: {
                        Text(description)
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Button {
                if let trackId = applicationInfo.trackId {
                    appIdentifier = "\(trackId)"
                } else {
                    appIdentifier = nil
                }
            } label: {
                Text("Get")
                    .textCase(.uppercase)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
    }
}
