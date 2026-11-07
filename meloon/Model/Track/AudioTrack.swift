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
    private var audioFileURL: URL?
    /// Audio player for the audio track.
    private var audioPlayer: AVAudioPlayer?
    /// Audio recorder for the audio track.
    var recorder: AudioRecorder?
    
    /// Whether the track is recording.
    var isRecording: Bool {
        get {
            recorder?.state == .recording
        }
    }

    init(id: UUID = UUID(), name: String, color: RGBColor = .init(r: 0, g: 0, b: 0, a: 0)) {
        self.id = id
        self.name = name
        self.color = color

        Task {
            do {
                let recorder = try await AudioRecorder()
                await MainActor.run {
                    self.recorder = recorder
                }
            } catch {
                print("Error while initialization: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    fileprivate func setRecorder(_ recorder: AudioRecorder) {
        self.recorder = recorder
    }

    /// Starts recording audio.
    func record() {
        do {
            guard let url = audioFileURL ?? generateAudioURL() else {
                return
            }
            audioFileURL = url
            try recorder?.startRecording()
        } catch {
            print("Recorder Error: \(error.localizedDescription)")
        }
    }

    /// Stops recording.
    func stopRecord() {
        recorder?.stopRecording()
    }

    /// Plays the recorded audio.
    func playAudio() {
        guard let url = audioFileURL else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let error {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }

    /// Generates a new URL for an audio file.
    func generateAudioURL() -> URL? {
        do {
            try FileManager.default.createDirectory(at: URL.temporaryDirectory, withIntermediateDirectories: true)
            return URL.temporaryDirectory.appendingPathComponent("audio", conformingTo: .audio)
        } catch {
            return nil
        }
    }
}
