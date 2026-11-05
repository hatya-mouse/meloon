//
//  AudioTrack.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/05.
//

import AVFoundation

/// A type of track that stores raw waveform data.
class AudioTrack: Track {
    var id: UUID
    var name: String
    var color: RGBColor
    
    /// The raw audio buffer.
    var buffer: AVAudioPCMBuffer
    
    init(id: UUID = UUID(), name: String, color: RGBColor = .init(r: 0, g: 0, b: 0, a: 0)) {
        self.id = id
        self.name = name
        self.color = color
        self.buffer = AVAudioPCMBuffer()
    }
}
