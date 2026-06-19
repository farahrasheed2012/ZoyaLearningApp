//
//  SoundManager.swift
//  ZoyaLearn
//

import AVFoundation
import AudioToolbox

@MainActor
final class SoundManager: ObservableObject {
    static let shared = SoundManager()

    @Published var isMuted: Bool {
        didSet { UserDefaults.standard.set(isMuted, forKey: "zoyalearn.muted") }
    }

    private init() {
        isMuted = UserDefaults.standard.bool(forKey: "zoyalearn.muted")
        #if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        #endif
    }

    func playWoodTap() { playTone(frequency: 320, duration: 0.06, volume: 0.25) }
    func playChime() { playSequence([523.25, 659.25, 784]) }
    func playWaterDrop() { playTone(frequency: 440, duration: 0.12, volume: 0.2) }
    func playBoing() { playTone(frequency: 180, duration: 0.18, volume: 0.15) }
    func playBubble() { playTone(frequency: 260, duration: 0.14, volume: 0.12) }

    private func playSequence(_ frequencies: [Double]) {
        for (i, f) in frequencies.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                self.playTone(frequency: f, duration: 0.1, volume: 0.28)
            }
        }
    }

    private func playTone(frequency: Double, duration: Double, volume: Double) {
        guard !isMuted else { return }
        let sampleRate = 44100.0
        let frameCount = Int(sampleRate * duration)
        var samples = [Float](repeating: 0, count: frameCount)
        for i in 0..<frameCount {
            let t = Double(i) / sampleRate
            let env = min(1, t * 50) * min(1, (duration - t) * 50)
            samples[i] = Float(sin(2 * .pi * frequency * t) * volume * env)
        }
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(frameCount)) else {
            AudioServicesPlaySystemSound(1104)
            return
        }
        buffer.frameLength = AVAudioFrameCount(frameCount)
        let channel = buffer.floatChannelData![0]
        for i in 0..<frameCount { channel[i] = samples[i] }
        do {
            let engine = AVAudioEngine()
            let node = AVAudioPlayerNode()
            engine.attach(node)
            engine.connect(node, to: engine.mainMixerNode, format: format)
            try engine.start()
            node.scheduleBuffer(buffer, at: nil, options: .interrupts) { engine.stop() }
            node.play()
        } catch {
            AudioServicesPlaySystemSound(1104)
        }
    }
}
