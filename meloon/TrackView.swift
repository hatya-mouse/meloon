//
//  TrackView.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/01.
//

import SwiftUI

struct TrackView: View {
    var track: Track
    let detailed: Bool

    init(track: Track, detailed: Bool = false) {
        self.track = track
        self.detailed = detailed
    }

    var body: some View {
        ZStack {
            track.color
            
            VStack {
                Text(track.color.description)
                    .font(.title)
                    .foregroundStyle(.white)
                
                if detailed {
                    Text(track.color.description)
                        .font(.caption)
                }
            }
        }
    }
}
