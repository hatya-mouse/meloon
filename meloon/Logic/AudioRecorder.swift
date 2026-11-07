//
//  AudioRecorder.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/05.
//

import AVFoundation

class AudioRecorder {
    enum RecordingState: Equatable {
        case recording
        case paused
        case stopped

        static nonisolated func == (lhs: RecordingState, rhs: RecordingState)
            -> Bool
        {
            switch (lhs, rhs) {
            case (.recording, .recording): return true
            case (.paused, .paused): return true
            case (.stopped, .stopped): return true
            default: return false
            }
        }
    }

    var state: RecordingState = .stopped

    private var engine: AVAudioEngine!
    private var mixerNode: AVAudioMixerNode!

    private var isInterrupted: Bool = false
    private var configChangePending: Bool = false

    // MARK: Initialization

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
            try? engine.connectNode(
                inputNode,
                to: mixerNode,
                format: inputFormat
            )
        } else {
            engine.connect(inputNode, to: mixerNode, format: inputFormat)
        }

        let mainMixerNode = engine.mainMixerNode
        let mixerFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt32,
            sampleRate: inputFormat.sampleRate,
            channels: 1,
            interleaved: false
        )
        if #available(iOS 27.0, *) {
            try? engine.connectNode(
                mixerNode,
                to: mainMixerNode,
                format: mixerFormat
            )
        } else {
            engine.connect(mixerNode, to: mainMixerNode, format: mixerFormat)
        }
    }

    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard let self = self else {
                return
            }

            let userInfo = notification.userInfo
            let interruptionTypeValue: UInt =
                userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt ?? 0
            let interruptionType = AVAudioSession.InterruptionType(
                rawValue: interruptionTypeValue
            )!

            switch interruptionType {
            case .began:
                self.isInterrupted = true

                if self.state == .recording {
                    self.pauseRecording()
                }
            case .ended:
                self.isInterrupted = false

                try? AVAudioSession.sharedInstance().setActive(
                    true,
                    options: .notifyOthersOnDeactivation
                )

                self.handleConfigurationChange()

                if self.state == .paused {
                    try? self.resumeRecording()
                }
            @unknown default:
                break
            }
        }

        NotificationCenter.default.addObserver(
            forName: Notification.Name.AVAudioEngineConfigurationChange,
            object: nil,
            queue: nil
        ) { [weak self] (notification) in
            guard let self = self else {
                return
            }

            self.configChangePending = true

            if !self.isInterrupted {
                self.handleConfigurationChange()
            } else {
                print("deferring changes")
            }
        }
    }

    fileprivate func handleConfigurationChange() {
        if configChangePending {
            makeConnections()
        }

        configChangePending = false
    }

    // MARK: Recording

    func startRecording() throws {
        let tapNode: AVAudioNode = mixerNode
        let format = tapNode.outputFormat(forBus: 0)

        if #available(iOS 27.0, *) {
            try tapNode.installAudioTap(
                onBus: 0,
                bufferSize: 4096,
                format: format
            ) { buffer, time in
                // Do something here
            }
        } else {
            tapNode.installTap(onBus: 0, bufferSize: 4096, format: format) {
                buffer,
                time in
                // Do something here
            }
        }

        try engine.start()
        state = .recording
    }

    func resumeRecording() throws {
        try engine.start()
        state = .recording
    }

    func pauseRecording() {
        engine.pause()
        state = .paused
    }

    func stopRecording() {
        // Remove existing taps on nodes
        mixerNode.removeTap(onBus: 0)

        engine.stop()
        state = .stopped
    }
}
