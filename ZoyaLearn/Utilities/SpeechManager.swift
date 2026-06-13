//
//  SpeechManager.swift
//  ZoyaLearn
//

import AVFoundation

@MainActor
final class SpeechManager: NSObject, ObservableObject {
    static let shared = SpeechManager()

    private let synthesizer = AVSpeechSynthesizer()

    override private init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.4
        utterance.pitchMultiplier = 1.15
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    func speakLetterAndWord(_ item: LearningItem) {
        speak("\(item.character)... \(item.exampleWord)")
    }

    func speakWord(_ word: PhonicsWord) {
        speak(word.word)
    }

    func soundOutWord(_ word: PhonicsWord) {
        let parts = word.letterParts.joined(separator: "... ")
        speak("\(parts)... \(word.word)")
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
}

extension SpeechManager: AVSpeechSynthesizerDelegate {}
