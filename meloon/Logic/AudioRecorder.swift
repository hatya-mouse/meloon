//
//  AudioRecorder.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/05.
//

import AVFoundation

class AudioRecorder {
    private let engine = AVAudioEngine()
    var isRecording: Bool {
        get {
            engine.isRunning
        }
    }
    
    func record(to destinationURL: URL) throws {
        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)
        let file = try AVAudioFile(forWriting: destinationURL, settings: format.settings)

        if #available(iOS 27.0, *) {
            try input.installAudioTap(onBus: 0, bufferSize: 4096, format: format) { buffer, time in
                do {
                    try file.write(from: buffer)
                } catch {
                    print("Error writing the buffer to \(destinationURL): \(error)")
                }
            }
        } else {
            input.installTap(onBus: 0, bufferSize: 4096, format: format) { buffer, time in
                do {
                    try file.write(from: buffer)
                } catch {
                    print("Error writing the buffer to \(destinationURL): \(error)")
                }
            }
        }

        try engine.start()
    }
    
    func stopRecord() {
        engine.stop()
    }
}
