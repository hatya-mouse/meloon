//
//  ListTrackView.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/04.
//

import SwiftUI

struct TrackListItemView: View {
    var track: Track

    var body: some View {
        ZStack {
            Color(rgbColor: track.color)
            Text(track.name)
                .font(.title)
                .foregroundStyle(.white)
        }
    }
}
