//
//  PhonicsPhonemeMap.swift
//  ZoyaLearn — onset + rime blending (how phonics is actually taught)
//

import Foundation

struct PhonemeSound: Equatable {
    let label: String
    let speak: String
}

/// One visual/audio chunk for the blend row (e.g. c | ab).
struct BlendPart: Equatable {
    let letters: String
    let sound: String
}

enum PhonicsPhonemeMap {
    /// Two-step blend: slow build (onset + rime), then snap the whole word.
    static func blendParts(for word: String) -> (build: String, snap: String) {
        let lower = word.lowercased()
        if let irregular = irregularBlendParts[lower] {
            return irregular
        }

        let chars = Array(lower)
        switch chars.count {
        case 3:
            let onset = onsetSpeakChar(chars[0])
            let rime = String(chars[1...])
            return ("\(onset) \(rime)", lower)
        case 2:
            return ("\(chars[0]) \(chars[1])", lower)
        default:
            return (lower, lower)
        }
    }

    static func displayParts(for word: String) -> [BlendPart] {
        let lower = word.lowercased()
        if let irregular = irregularDisplayParts[lower] {
            return irregular
        }

        let chars = Array(lower)
        switch chars.count {
        case 3:
            return [
                BlendPart(letters: String(chars[0]), sound: onsetLabelChar(chars[0])),
                BlendPart(letters: String(chars[1...]), sound: String(chars[1...])),
            ]
        case 2:
            return [BlendPart(letters: lower, sound: lower)]
        default:
            return lower.enumerated().map { index, char in
                let phoneme = phoneme(for: char, in: lower, at: index)
                return BlendPart(letters: String(char), sound: phoneme.label)
            }
        }
    }

    static func labels(for word: String) -> [String] {
        let lower = word.lowercased()
        if irregularDisplayParts[lower] != nil {
            return displayParts(for: word).flatMap { part in
                part.letters.map { _ in part.sound }
            }
        }
        return lower.enumerated().map { index, character in
            phoneme(for: character, in: lower, at: index).label
        }
    }

    // MARK: - Legacy helpers (games / accessibility)

    static func phonemes(for word: String) -> [PhonemeSound] {
        let lower = word.lowercased()
        if let override = irregularPhonemes[lower] {
            return override
        }
        return lower.enumerated().map { index, character in
            phoneme(for: character, in: lower, at: index)
        }
    }

    static func spokenSequence(for word: String) -> [String] {
        let parts = blendParts(for: word)
        return [parts.build, parts.snap]
    }

    // MARK: - Private

    /// Build then snap phrases for sight / long-vowel words.
    private static let irregularBlendParts: [String: (String, String)] = [
        "go": ("g oh", "go"),
        "no": ("n oh", "no"),
        "so": ("s oh", "so"),
        "to": ("t oo", "to"),
        "do": ("d oo", "do"),
        "he": ("h ee", "he"),
        "we": ("w ee", "we"),
        "be": ("b ee", "be"),
        "me": ("m ee", "me"),
    ]

    private static let irregularDisplayParts: [String: [BlendPart]] = [
        "go": [BlendPart(letters: "g", sound: "g"), BlendPart(letters: "o", sound: "oh")],
        "no": [BlendPart(letters: "n", sound: "n"), BlendPart(letters: "o", sound: "oh")],
        "so": [BlendPart(letters: "s", sound: "s"), BlendPart(letters: "o", sound: "oh")],
        "to": [BlendPart(letters: "t", sound: "t"), BlendPart(letters: "o", sound: "oo")],
        "do": [BlendPart(letters: "d", sound: "d"), BlendPart(letters: "o", sound: "oo")],
        "he": [BlendPart(letters: "h", sound: "h"), BlendPart(letters: "e", sound: "ee")],
        "we": [BlendPart(letters: "w", sound: "w"), BlendPart(letters: "e", sound: "ee")],
        "be": [BlendPart(letters: "b", sound: "b"), BlendPart(letters: "e", sound: "ee")],
        "me": [BlendPart(letters: "m", sound: "m"), BlendPart(letters: "e", sound: "ee")],
    ]

    private static let irregularPhonemes: [String: [PhonemeSound]] = [
        "go": [.init(label: "g", speak: "guh"), .init(label: "oh", speak: "oh")],
        "no": [.init(label: "n", speak: "nnn"), .init(label: "oh", speak: "oh")],
        "so": [.init(label: "s", speak: "sss"), .init(label: "oh", speak: "oh")],
        "to": [.init(label: "t", speak: "tuh"), .init(label: "oo", speak: "oo")],
        "do": [.init(label: "d", speak: "duh"), .init(label: "oo", speak: "oo")],
        "he": [.init(label: "h", speak: "hhh"), .init(label: "ee", speak: "ee")],
        "we": [.init(label: "w", speak: "wuh"), .init(label: "ee", speak: "ee")],
        "be": [.init(label: "b", speak: "buh"), .init(label: "ee", speak: "ee")],
        "me": [.init(label: "m", speak: "mmm"), .init(label: "ee", speak: "ee")],
    ]

    private static func onsetSpeakChar(_ character: Character) -> String {
        switch character {
        case "c": return "k"
        case "x": return "ks"
        default: return String(character)
        }
    }

    private static func onsetLabelChar(_ character: Character) -> String {
        switch character {
        case "c": return "k"
        case "x": return "ks"
        default: return String(character)
        }
    }

    private static func phoneme(for character: Character, in word: String, at index: Int) -> PhonemeSound {
        let isFinal = index == word.count - 1
        let next = index + 1 < word.count ? word[word.index(word.startIndex, offsetBy: index + 1)] : nil

        switch character {
        case "a": return .init(label: "ah", speak: "ah")
        case "b": return stop("b", initialSpeak: "buh", finalSpeak: "b", isFinal: isFinal)
        case "c":
            if let next, "eiy".contains(next) { return continuous("s", speak: "sss", isFinal: isFinal) }
            return stop("k", initialSpeak: "k", finalSpeak: "k", isFinal: isFinal)
        case "d": return stop("d", initialSpeak: "duh", finalSpeak: "d", isFinal: isFinal)
        case "e": return .init(label: "eh", speak: "eh")
        case "f": return continuous("f", speak: "fff", isFinal: isFinal)
        case "g":
            if let next, "eiy".contains(next) { return stop("j", initialSpeak: "juh", finalSpeak: "j", isFinal: isFinal) }
            return stop("g", initialSpeak: "guh", finalSpeak: "g", isFinal: isFinal)
        case "h": return .init(label: "h", speak: "hhh")
        case "i": return .init(label: "ih", speak: "ih")
        case "j": return stop("j", initialSpeak: "juh", finalSpeak: "j", isFinal: isFinal)
        case "k": return stop("k", initialSpeak: "k", finalSpeak: "k", isFinal: isFinal)
        case "l": return continuous("l", speak: "lll", isFinal: isFinal)
        case "m": return continuous("m", speak: "mmm", isFinal: isFinal)
        case "n": return continuous("n", speak: "nnn", isFinal: isFinal)
        case "o": return .init(label: "aw", speak: "aw")
        case "p": return stop("p", initialSpeak: "puh", finalSpeak: "p", isFinal: isFinal)
        case "q": return .init(label: "kw", speak: "kwuh")
        case "r": return continuous("r", speak: "rrr", isFinal: isFinal)
        case "s": return continuous("s", speak: "sss", isFinal: isFinal)
        case "t": return stop("t", initialSpeak: "tuh", finalSpeak: "t", isFinal: isFinal)
        case "u": return .init(label: "uh", speak: "uh")
        case "v": return continuous("v", speak: "vvv", isFinal: isFinal)
        case "w": return stop("w", initialSpeak: "wuh", finalSpeak: "w", isFinal: isFinal)
        case "x": return .init(label: "ks", speak: "ks")
        case "y":
            if isFinal { return .init(label: "ee", speak: "ee") }
            return stop("y", initialSpeak: "yuh", finalSpeak: "y", isFinal: isFinal)
        case "z": return continuous("z", speak: "zzz", isFinal: isFinal)
        default: return .init(label: String(character), speak: String(character))
        }
    }

    private static func stop(_ label: String, initialSpeak: String, finalSpeak: String, isFinal: Bool) -> PhonemeSound {
        .init(label: label, speak: isFinal ? finalSpeak : initialSpeak)
    }

    private static func continuous(_ label: String, speak: String, isFinal: Bool) -> PhonemeSound {
        .init(label: label, speak: speak)
    }
}
