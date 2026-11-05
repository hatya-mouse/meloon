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

    /// URL of the audio file.
    var audioFileURL: URL?
    /// Audio format metadata.
    var format: AVAudioFormat?
    /// Recorder for the audio track.
    let recorder = AudioRecorder()
    
    /// Whether the track is recording.
    var isRecording: Bool {
        get {
            recorder.isRecording
        }
    }

    init(id: UUID = UUID(), name: String, color: RGBColor = .init(r: 0, g: 0, b: 0, a: 0)) {
        self.id = id
        self.name = name
        self.color = color
    }

    /// Starts recording audio.
    func record() {
        do {
            audioFileURL = audioFileURL ?? generateAudioURL()
            try recorder.record(to: audioFileURL!)
        } catch {
            print("Recorder Error: \(error)")
        }
    }

    /// Stops recording.
    func stopRecord() {
        recorder.stopRecord()
    }
    
    /// Generates a new URL for an audio file.
    func generateAudioURL() -> URL {
        return URL.temporaryDirectory.appendingPathComponent("meloon", conformingTo: .directory).appendingPathComponent("audio.caf", conformingTo: .audio)
    }
}
