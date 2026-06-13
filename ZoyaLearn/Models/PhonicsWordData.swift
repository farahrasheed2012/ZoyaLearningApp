//
//  PhonicsWordData.swift
//  ZoyaLearn — beginner phonics: 2- and 3-letter words
//

import Foundation

enum PhonicsWordData {
    static let all: [PhonicsWord] = twoLetter + threeLetter

    static let twoLetter: [PhonicsWord] = [
        PhonicsWord(word: "at", emoji: "👆", hint: "Where you point", wordFamily: "at", length: .twoLetter),
        PhonicsWord(word: "am", emoji: "🙋", hint: "I ___ happy", wordFamily: "am", length: .twoLetter),
        PhonicsWord(word: "an", emoji: "1️⃣", hint: "One of something", wordFamily: "an", length: .twoLetter),
        PhonicsWord(word: "in", emoji: "📦", hint: "Inside a box", wordFamily: "in", length: .twoLetter),
        PhonicsWord(word: "it", emoji: "👆", hint: "That thing over there", wordFamily: "it", length: .twoLetter),
        PhonicsWord(word: "on", emoji: "⬆️", hint: "Sitting ___ the table", wordFamily: "on", length: .twoLetter),
        PhonicsWord(word: "up", emoji: "🎈", hint: "The balloon goes ___", wordFamily: "up", length: .twoLetter),
        PhonicsWord(word: "go", emoji: "🏃", hint: "Run and ___!", wordFamily: "go", length: .twoLetter),
        PhonicsWord(word: "no", emoji: "🙅", hint: "The opposite of yes", wordFamily: "no", length: .twoLetter),
        PhonicsWord(word: "so", emoji: "✨", hint: "Very much — ___ fun!", wordFamily: "so", length: .twoLetter),
        PhonicsWord(word: "me", emoji: "😊", hint: "That is ___!", wordFamily: "me", length: .twoLetter),
        PhonicsWord(word: "we", emoji: "👫", hint: "You and I together", wordFamily: "we", length: .twoLetter),
        PhonicsWord(word: "he", emoji: "👦", hint: "A boy — ___ runs fast", wordFamily: "he", length: .twoLetter),
        PhonicsWord(word: "be", emoji: "🐝", hint: "To exist — I want to ___", wordFamily: "be", length: .twoLetter),
        PhonicsWord(word: "to", emoji: "➡️", hint: "I want ___ go home", wordFamily: "to", length: .twoLetter),
        PhonicsWord(word: "do", emoji: "✅", hint: "Just ___ it!", wordFamily: "do", length: .twoLetter),
    ]

    static let threeLetter: [PhonicsWord] = [
        // -at family
        PhonicsWord(word: "cat", emoji: "🐱", hint: "A furry pet that says meow", wordFamily: "at", length: .threeLetter),
        PhonicsWord(word: "bat", emoji: "🦇", hint: "Flies at night", wordFamily: "at", length: .threeLetter),
        PhonicsWord(word: "hat", emoji: "🎩", hint: "You wear it on your head", wordFamily: "at", length: .threeLetter),
        PhonicsWord(word: "mat", emoji: "🧘", hint: "A rug you wipe your feet on", wordFamily: "at", length: .threeLetter),
        PhonicsWord(word: "sat", emoji: "🪑", hint: "Past tense of sit", wordFamily: "at", length: .threeLetter),
        PhonicsWord(word: "rat", emoji: "🐀", hint: "A small rodent", wordFamily: "at", length: .threeLetter),
        // -an family
        PhonicsWord(word: "can", emoji: "🥫", hint: "A tin container", wordFamily: "an", length: .threeLetter),
        PhonicsWord(word: "man", emoji: "👨", hint: "An adult male", wordFamily: "an", length: .threeLetter),
        PhonicsWord(word: "pan", emoji: "🍳", hint: "You cook eggs in it", wordFamily: "an", length: .threeLetter),
        PhonicsWord(word: "fan", emoji: "🌀", hint: "Keeps you cool", wordFamily: "an", length: .threeLetter),
        // -og family
        PhonicsWord(word: "dog", emoji: "🐕", hint: "A furry friend that barks", wordFamily: "og", length: .threeLetter),
        PhonicsWord(word: "log", emoji: "🪵", hint: "A piece of tree", wordFamily: "og", length: .threeLetter),
        PhonicsWord(word: "fog", emoji: "🌫️", hint: "Clouds on the ground", wordFamily: "og", length: .threeLetter),
        // -ig family
        PhonicsWord(word: "pig", emoji: "🐷", hint: "Loves mud puddles", wordFamily: "ig", length: .threeLetter),
        PhonicsWord(word: "big", emoji: "🐘", hint: "Not small — very large", wordFamily: "ig", length: .threeLetter),
        PhonicsWord(word: "dig", emoji: "⛏️", hint: "Make a hole in dirt", wordFamily: "ig", length: .threeLetter),
        // -un family
        PhonicsWord(word: "sun", emoji: "☀️", hint: "Shines in the sky", wordFamily: "un", length: .threeLetter),
        PhonicsWord(word: "run", emoji: "🏃", hint: "Move your legs fast", wordFamily: "un", length: .threeLetter),
        PhonicsWord(word: "fun", emoji: "🎉", hint: "Playing is ___!", wordFamily: "un", length: .threeLetter),
        PhonicsWord(word: "bun", emoji: "🍔", hint: "Bread for a hamburger", wordFamily: "un", length: .threeLetter),
        // -ed family
        PhonicsWord(word: "bed", emoji: "🛏️", hint: "Where you sleep", wordFamily: "ed", length: .threeLetter),
        PhonicsWord(word: "red", emoji: "🔴", hint: "Color of an apple", wordFamily: "ed", length: .threeLetter),
        // -en family
        PhonicsWord(word: "hen", emoji: "🐔", hint: "A mother chicken", wordFamily: "en", length: .threeLetter),
        PhonicsWord(word: "pen", emoji: "🖊️", hint: "You write with it", wordFamily: "en", length: .threeLetter),
        PhonicsWord(word: "ten", emoji: "🔟", hint: "One more than nine", wordFamily: "en", length: .threeLetter),
        // -it family
        PhonicsWord(word: "sit", emoji: "🪑", hint: "Rest on a chair", wordFamily: "it", length: .threeLetter),
        PhonicsWord(word: "bit", emoji: "🍪", hint: "A small piece of cookie", wordFamily: "it", length: .threeLetter),
        PhonicsWord(word: "hit", emoji: "⚾", hint: "Strike the ball", wordFamily: "it", length: .threeLetter),
        // -op family
        PhonicsWord(word: "hop", emoji: "🐰", hint: "Jump like a bunny", wordFamily: "op", length: .threeLetter),
        PhonicsWord(word: "mop", emoji: "🧹", hint: "Clean the floor", wordFamily: "op", length: .threeLetter),
        PhonicsWord(word: "top", emoji: "🔝", hint: "The highest part", wordFamily: "op", length: .threeLetter),
        // -ap family
        PhonicsWord(word: "map", emoji: "🗺️", hint: "Shows where to go", wordFamily: "ap", length: .threeLetter),
        PhonicsWord(word: "cap", emoji: "🧢", hint: "Wear it on your head", wordFamily: "ap", length: .threeLetter),
        PhonicsWord(word: "tap", emoji: "🚰", hint: "Turn on the water", wordFamily: "ap", length: .threeLetter),
        PhonicsWord(word: "nap", emoji: "😴", hint: "A short sleep", wordFamily: "ap", length: .threeLetter),
        // -am family
        PhonicsWord(word: "jam", emoji: "🍓", hint: "Sweet spread on toast", wordFamily: "am", length: .threeLetter),
        PhonicsWord(word: "ham", emoji: "🍖", hint: "Pink meat for sandwiches", wordFamily: "am", length: .threeLetter),
        // -ug family
        PhonicsWord(word: "bug", emoji: "🐛", hint: "A tiny crawling insect", wordFamily: "ug", length: .threeLetter),
        PhonicsWord(word: "hug", emoji: "🤗", hint: "Wrap your arms around someone", wordFamily: "ug", length: .threeLetter),
        PhonicsWord(word: "mug", emoji: "☕", hint: "A cup for hot cocoa", wordFamily: "ug", length: .threeLetter),
        // -ox family
        PhonicsWord(word: "box", emoji: "📦", hint: "Put toys inside", wordFamily: "ox", length: .threeLetter),
        PhonicsWord(word: "fox", emoji: "🦊", hint: "Clever orange animal", wordFamily: "ox", length: .threeLetter),
        // -up family
        PhonicsWord(word: "cup", emoji: "🥤", hint: "Drink juice from it", wordFamily: "up", length: .threeLetter),
        PhonicsWord(word: "pup", emoji: "🐶", hint: "A baby dog", wordFamily: "up", length: .threeLetter),
        // -et family
        PhonicsWord(word: "get", emoji: "🎁", hint: "Receive a present", wordFamily: "et", length: .threeLetter),
        PhonicsWord(word: "jet", emoji: "✈️", hint: "A fast plane in the sky", wordFamily: "et", length: .threeLetter),
        PhonicsWord(word: "net", emoji: "🥅", hint: "Catch fish with a ___", wordFamily: "et", length: .threeLetter),
        PhonicsWord(word: "pet", emoji: "🐾", hint: "A furry friend at home", wordFamily: "et", length: .threeLetter),
        PhonicsWord(word: "wet", emoji: "💧", hint: "Not dry — full of water", wordFamily: "et", length: .threeLetter),
        PhonicsWord(word: "vet", emoji: "🩺", hint: "A doctor for animals", wordFamily: "et", length: .threeLetter),
        // -ot family
        PhonicsWord(word: "cot", emoji: "🛏️", hint: "A small bed", wordFamily: "ot", length: .threeLetter),
        PhonicsWord(word: "dot", emoji: "⚫", hint: "A tiny round spot", wordFamily: "ot", length: .threeLetter),
        PhonicsWord(word: "hot", emoji: "🔥", hint: "Very warm — like soup", wordFamily: "ot", length: .threeLetter),
        PhonicsWord(word: "lot", emoji: "🅿️", hint: "A parking ___", wordFamily: "ot", length: .threeLetter),
        PhonicsWord(word: "pot", emoji: "🍲", hint: "Cook soup in a ___", wordFamily: "ot", length: .threeLetter),
        // -ut family
        PhonicsWord(word: "cut", emoji: "✂️", hint: "Use scissors to ___ paper", wordFamily: "ut", length: .threeLetter),
        PhonicsWord(word: "hut", emoji: "🏕️", hint: "A tiny house or shelter", wordFamily: "ut", length: .threeLetter),
        PhonicsWord(word: "nut", emoji: "🥜", hint: "Squirrels love to eat these", wordFamily: "ut", length: .threeLetter),
        // -ip family
        PhonicsWord(word: "dip", emoji: "🫕", hint: "___ your chip in sauce", wordFamily: "ip", length: .threeLetter),
        PhonicsWord(word: "hip", emoji: "🕺", hint: "Shake your ___ when you dance", wordFamily: "ip", length: .threeLetter),
        PhonicsWord(word: "lip", emoji: "👄", hint: "You smile with your ___", wordFamily: "ip", length: .threeLetter),
        PhonicsWord(word: "sip", emoji: "🍵", hint: "Take a tiny drink", wordFamily: "ip", length: .threeLetter),
        PhonicsWord(word: "tip", emoji: "💡", hint: "A helpful hint", wordFamily: "ip", length: .threeLetter),
        PhonicsWord(word: "zip", emoji: "🤐", hint: "Close your coat fast", wordFamily: "ip", length: .threeLetter),
        // -in family (3-letter)
        PhonicsWord(word: "bin", emoji: "🗑️", hint: "Throw trash in the ___", wordFamily: "in", length: .threeLetter),
        PhonicsWord(word: "fin", emoji: "🦈", hint: "A fish swims with its ___", wordFamily: "in", length: .threeLetter),
        PhonicsWord(word: "pin", emoji: "📌", hint: "Hold paper on a board", wordFamily: "in", length: .threeLetter),
        PhonicsWord(word: "tin", emoji: "🥫", hint: "A metal can", wordFamily: "in", length: .threeLetter),
        PhonicsWord(word: "win", emoji: "🏆", hint: "Come in first place", wordFamily: "in", length: .threeLetter),
        // -ad family
        PhonicsWord(word: "bad", emoji: "😈", hint: "Not good — the opposite of good", wordFamily: "ad", length: .threeLetter),
        PhonicsWord(word: "dad", emoji: "👨", hint: "Your father", wordFamily: "ad", length: .threeLetter),
        PhonicsWord(word: "mad", emoji: "😠", hint: "Very angry", wordFamily: "ad", length: .threeLetter),
        PhonicsWord(word: "pad", emoji: "📝", hint: "Write notes on a ___", wordFamily: "ad", length: .threeLetter),
        PhonicsWord(word: "sad", emoji: "😢", hint: "Feeling unhappy", wordFamily: "ad", length: .threeLetter),
        // -ag family
        PhonicsWord(word: "bag", emoji: "👜", hint: "Carry toys in a ___", wordFamily: "ag", length: .threeLetter),
        PhonicsWord(word: "rag", emoji: "🧽", hint: "Wipe spills with a ___", wordFamily: "ag", length: .threeLetter),
        PhonicsWord(word: "tag", emoji: "🏷️", hint: "A label on your shirt", wordFamily: "ag", length: .threeLetter),
        // -ab family
        PhonicsWord(word: "cab", emoji: "🚕", hint: "A taxi car", wordFamily: "ab", length: .threeLetter),
        PhonicsWord(word: "tab", emoji: "📑", hint: "A page label in a browser", wordFamily: "ab", length: .threeLetter),
        // -id family
        PhonicsWord(word: "bid", emoji: "🔨", hint: "Offer money at an auction", wordFamily: "id", length: .threeLetter),
        PhonicsWord(word: "kid", emoji: "🧒", hint: "A child", wordFamily: "id", length: .threeLetter),
        PhonicsWord(word: "lid", emoji: "🫙", hint: "Covers the top of a jar", wordFamily: "id", length: .threeLetter),
        // -ob family
        PhonicsWord(word: "bob", emoji: "🎣", hint: "A name — or float on water", wordFamily: "ob", length: .threeLetter),
        PhonicsWord(word: "job", emoji: "💼", hint: "Work you do to help", wordFamily: "ob", length: .threeLetter),
        PhonicsWord(word: "sob", emoji: "😭", hint: "Cry with loud tears", wordFamily: "ob", length: .threeLetter),
        // -ub family
        PhonicsWord(word: "cub", emoji: "🐻", hint: "A baby bear", wordFamily: "ub", length: .threeLetter),
        PhonicsWord(word: "rub", emoji: "🤲", hint: "Move your hand back and forth", wordFamily: "ub", length: .threeLetter),
        PhonicsWord(word: "tub", emoji: "🛁", hint: "Take a bath in it", wordFamily: "ub", length: .threeLetter),
        // -um family
        PhonicsWord(word: "gum", emoji: "🫧", hint: "Chewy bubble ___", wordFamily: "um", length: .threeLetter),
        PhonicsWord(word: "hum", emoji: "🎵", hint: "Sing without words", wordFamily: "um", length: .threeLetter),
        PhonicsWord(word: "sum", emoji: "➕", hint: "The total when you add", wordFamily: "um", length: .threeLetter),
        // -ig family (more)
        PhonicsWord(word: "wig", emoji: "💇", hint: "Fake hair you wear", wordFamily: "ig", length: .threeLetter),
        // -en family (more)
        PhonicsWord(word: "men", emoji: "👥", hint: "More than one man", wordFamily: "en", length: .threeLetter),
        PhonicsWord(word: "den", emoji: "🦁", hint: "A cozy animal home", wordFamily: "en", length: .threeLetter),
        // -ap family (more)
        PhonicsWord(word: "gap", emoji: "↔️", hint: "A space between two things", wordFamily: "ap", length: .threeLetter),
        PhonicsWord(word: "lap", emoji: "🦵", hint: "Sit a book on your ___", wordFamily: "ap", length: .threeLetter),
        PhonicsWord(word: "sap", emoji: "🌳", hint: "Sticky tree juice", wordFamily: "ap", length: .threeLetter),
        PhonicsWord(word: "zap", emoji: "⚡", hint: "A quick burst of energy", wordFamily: "ap", length: .threeLetter),
        // -an family (more)
        PhonicsWord(word: "van", emoji: "🚐", hint: "A big family car", wordFamily: "an", length: .threeLetter),
        PhonicsWord(word: "tan", emoji: "☀️", hint: "Brown color from the sun", wordFamily: "an", length: .threeLetter),
        PhonicsWord(word: "ran", emoji: "🏃‍♀️", hint: "Moved your legs fast — past tense", wordFamily: "an", length: .threeLetter),
        // -at family (more)
        PhonicsWord(word: "pat", emoji: "👋", hint: "A gentle tap with your hand", wordFamily: "at", length: .threeLetter),
        PhonicsWord(word: "fat", emoji: "🐷", hint: "Thick or wide", wordFamily: "at", length: .threeLetter),
    ]

    static var families: [WordFamilyInfo] {
        Dictionary(grouping: all, by: \.wordFamily)
            .map { suffix, words in
                WordFamilyInfo(
                    suffix: suffix,
                    words: words.sorted { lhs, rhs in
                        if lhs.word.count == rhs.word.count { return lhs.word < rhs.word }
                        return lhs.word.count < rhs.word.count
                    }
                )
            }
            .sorted { $0.suffix < $1.suffix }
    }

    static func words(inFamily suffix: String) -> [PhonicsWord] {
        all.filter { $0.wordFamily == suffix }
    }

    static func word(for text: String) -> PhonicsWord? {
        all.first { $0.word.lowercased() == text.lowercased() }
    }

    static func randomRhyme(for word: PhonicsWord) -> PhonicsWord? {
        let rhymes = all.filter { word.rhymes(with: $0) }
        return rhymes.randomElement()
    }

    static func randomDistractors(excluding: PhonicsWord, count: Int) -> [PhonicsWord] {
        all.filter { $0.word.lowercased() != excluding.word.lowercased() }.shuffled().prefix(count).map { $0 }
    }
}
