//
//  AudioDetailView.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/06.
//

import SwiftUI

struct AudioTrackView: View {
    let track: Track
    let detailed: Bool

    var body: some View {
        ZStack {
            Color(rgbColor: track.color)

            VStack {
                Text(track.name)
                    .font(.title)
                    .foregroundStyle(.white)
                if detailed {
                    Text(track.name)
                        .font(.caption)
                }
            }
        }
    }
}
