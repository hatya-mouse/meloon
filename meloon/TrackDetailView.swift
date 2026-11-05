//
//  TrackView.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/01.
//

import SwiftUI

struct TrackDetailView: View {
    var track: Track

    var body: some View {
        ZStack {
            Color(rgbColor: track.color)

            VStack {
                Text(track.name)
                    .font(.title)
                    .foregroundStyle(.white)

                Text(track.name)
                    .font(.caption)
            }
        }
        .onTapGesture {
            if let audioTrack = track as? AudioTrack {
                audioTrack.record()
            }
        }
    }
}
