//
//  AudioTrackToolbar.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/06.
//

import SwiftUI

struct AudioTrackToolbar: ToolbarContent {
    @State var isRecording: Bool = false

    let track: AudioTrack

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            if isRecording {
                Button("Record", systemImage: "record.circle.fill") {
                    track.stopRecord()
                    isRecording = false
                }
                .transition(.blurReplace)
            } else {
                Button("Record", systemImage: "record.circle") {
                    track.record()
                    isRecording = true
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
