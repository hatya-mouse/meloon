//
//  TrackView.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/01.
//

import SwiftUI

struct TrackItemView: View {
    let track: Track
    let detailed: Bool

    var body: some View {
        if let track = track as? AudioTrack {
            AudioTrackView(track: track, detailed: detailed)
        }
    }
}
