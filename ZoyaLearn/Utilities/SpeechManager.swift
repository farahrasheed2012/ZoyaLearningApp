//
//  SpeechManager.swift
//  ZoyaLearn
//

import AVFoundation

@MainActor
final class SpeechManager: NSObject, ObservableObject {
    static let shared = SpeechManager()

    private let synthesizer = AVSpeechSynthesizer()
    private var utteranceQueue: [AVSpeechUtterance] = []
    private var isPlayingSequence = false

    override private init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        stopSequence()
        synthesizer.speak(makeUtterance(text, rate: 0.42))
    }

    func speakLetterAndWord(_ item: LearningItem) {
        if item.type == .letter {
            speak("\(item.soundSpeak)... \(item.exampleWord.lowercased())")
        } else {
            speak("\(item.character)... \(item.exampleWord)")
        }
    }

    func speakLetterSound(_ item: LearningItem) {
        speak(item.soundSpeak)
    }

    func speakWord(_ word: PhonicsWord) {
        speak(word.word)
    }

    /// Onset + rime build, then snap the whole word — flows as connected speech.
    func soundOutWord(_ word: PhonicsWord) {
        stopSequence()
        let parts = PhonicsPhonemeMap.blendParts(for: word.word)

        let build = makeUtterance(parts.build, rate: 0.26)
        build.preUtteranceDelay = 0.05
        build.postUtteranceDelay = 0.22

        let snap = makeUtterance(parts.snap, rate: 0.44)
        snap.pitchMultiplier = 1.18

        utteranceQueue = [build, snap]
        isPlayingSequence = true
        speakNextQueued()
    }

    func speakPrompt(_ text: String) {
        speak(text)
    }

    func speakPraise() {
        let phrases = [
            "Great job, Zoya!",
            "Awesome work, Zoya!",
            "You did it, Zoya!",
            "Super star, Zoya!",
        ]
        speak(phrases.randomElement() ?? "Great job, Zoya!")
    }

    func speakBadgeUnlock(_ badge: Badge) {
        speak("Congratulations! You unlocked \(badge.title)!")
    }

    private func stopSequence() {
        isPlayingSequence = false
        utteranceQueue.removeAll()
        synthesizer.stopSpeaking(at: .immediate)
    }

    private func makeUtterance(_ text: String, rate: Float) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = 1.1
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        return utterance
    }

    private func speakNextQueued() {
        guard isPlayingSequence, !utteranceQueue.isEmpty else {
            isPlayingSequence = false
            return
        }
        synthesizer.speak(utteranceQueue.removeFirst())
    }
}

extension SpeechManager: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            speakNextQueued()
        }
    }
}
