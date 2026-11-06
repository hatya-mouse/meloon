//
//  AudioTrackToolbar.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/06.
//

import SwiftUI

struct AudioTrackToolbar: ToolbarContent {
    let track: AudioTrack

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            if track.isRecording {
                Button("Record", systemImage: "record.circle.fill") {
                    track.stopRecord()
                }
                .transition(.blurReplace)
            } else {
                Button("Record", systemImage: "record.circle") {
                    track.record()
                }
                .transition(.blurReplace)
            }

            Button("Play", systemImage: "play") {
                track.playAudio()
            }
            .transition(.blurReplace)
        }
    }
}
