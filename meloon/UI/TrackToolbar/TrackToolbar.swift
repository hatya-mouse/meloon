//
//  TrackToolbar.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/06.
//

import SwiftUI

struct TrackToolbar: ToolbarContent {
    let track: Track

    var body: some ToolbarContent {
        if let track = track as? AudioTrack {
            AudioTrackToolbar(track: track)
        }
    }
}
