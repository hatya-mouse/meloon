//
//  AudioRecorder.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/05.
//

import AVFoundation

class AudioRecorder {
    enum RecordingState {
        case recording
        case paused
        case stopped
    }
    
    private var engine: AVAudioEngine!
    private var mixerNode: AVAudioMixerNode!
    private var state: RecordingState = .stopped
    
    init() {
        setupSession()
        setupEngine()
    }
    
    fileprivate func setupSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    fileprivate func setupEngine() {
        engine = AVAudioEngine()
        mixerNode = AVAudioMixerNode()

        // Set volume to 0 to avoid audio feedback while recording
        mixerNode.volume = 0
        
        engine.attach(mixerNode)
        
        makeConnections()

        // Prepare the engine in advance
        engine.prepare()
    }
    
    fileprivate func makeConnections() {
        let inputNode = engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        if #available(iOS 27.0, *) {
            try? engine.connectNode(inputNode, to: mixerNode, format: inputFormat)
        } else {
            engine.connect(inputNode, to: mixerNode, format: inputFormat)
        }
        
        let mainMixerNode = engine.mainMixerNode
        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
        if #available(iOS 27.0, *) {
            try? engine.connectNode(mixerNode, to: mainMixerNode, format: mixerFormat)
        } else {
            engine.connect(mixerNode, to: mainMixerNode, format: mixerFormat)
        }
    }
}
