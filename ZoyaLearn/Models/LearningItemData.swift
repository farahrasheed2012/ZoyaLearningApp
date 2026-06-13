//
//  LearningItemData.swift
//  ZoyaLearn — all 36 letters and numbers
//

import Foundation

enum LearningItemData {
    static let all: [LearningItem] = letters + numbers

    static let letters: [LearningItem] = [
        LearningItem(character: "A", type: .letter, exampleWord: "Apple", exampleEmoji: "🍎", phonetic: "ay", funFact: "Apples can be red, green, or yellow!"),
        LearningItem(character: "B", type: .letter, exampleWord: "Ball", exampleEmoji: "🏀", phonetic: "bee", funFact: "You can bounce a ball and play catch!"),
        LearningItem(character: "C", type: .letter, exampleWord: "Cat", exampleEmoji: "🐱", phonetic: "see", funFact: "Cats love to nap in sunny spots."),
        LearningItem(character: "D", type: .letter, exampleWord: "Dog", exampleEmoji: "🐕", phonetic: "dee", funFact: "Dogs wag their tails when they are happy."),
        LearningItem(character: "E", type: .letter, exampleWord: "Egg", exampleEmoji: "🥚", phonetic: "ee", funFact: "Eggs can become fluffy chicks!"),
        LearningItem(character: "F", type: .letter, exampleWord: "Fish", exampleEmoji: "🐟", phonetic: "ef", funFact: "Fish swim with their fins in the water."),
        LearningItem(character: "G", type: .letter, exampleWord: "Grapes", exampleEmoji: "🍇", phonetic: "jee", funFact: "Grapes grow in bunches on vines."),
        LearningItem(character: "H", type: .letter, exampleWord: "Hat", exampleEmoji: "🎩", phonetic: "aych", funFact: "Hats keep your head warm or shady."),
        LearningItem(character: "I", type: .letter, exampleWord: "Ice", exampleEmoji: "🧊", phonetic: "eye", funFact: "Ice is frozen water—so cool!"),
        LearningItem(character: "J", type: .letter, exampleWord: "Jam", exampleEmoji: "🍓", phonetic: "jay", funFact: "Jam is yummy on toast for breakfast."),
        LearningItem(character: "K", type: .letter, exampleWord: "Kite", exampleEmoji: "🪁", phonetic: "kay", funFact: "Kites fly high on windy days."),
        LearningItem(character: "L", type: .letter, exampleWord: "Lion", exampleEmoji: "🦁", phonetic: "el", funFact: "Lions are big cats with loud roars."),
        LearningItem(character: "M", type: .letter, exampleWord: "Moon", exampleEmoji: "🌙", phonetic: "em", funFact: "The moon shines at night in the sky."),
        LearningItem(character: "N", type: .letter, exampleWord: "Nest", exampleEmoji: "🪺", phonetic: "en", funFact: "Birds build nests to keep eggs safe."),
        LearningItem(character: "O", type: .letter, exampleWord: "Owl", exampleEmoji: "🦉", phonetic: "oh", funFact: "Owls say hoo and hunt at night."),
        LearningItem(character: "P", type: .letter, exampleWord: "Pig", exampleEmoji: "🐷", phonetic: "pee", funFact: "Pigs love to roll in mud puddles."),
        LearningItem(character: "Q", type: .letter, exampleWord: "Queen", exampleEmoji: "👑", phonetic: "kyoo", funFact: "Queens wear crowns in fairy tales."),
        LearningItem(character: "R", type: .letter, exampleWord: "Rainbow", exampleEmoji: "🌈", phonetic: "ar", funFact: "Rainbows appear after rain when sun shines."),
        LearningItem(character: "S", type: .letter, exampleWord: "Sun", exampleEmoji: "☀️", phonetic: "ess", funFact: "The sun gives us light and warmth."),
        LearningItem(character: "T", type: .letter, exampleWord: "Tree", exampleEmoji: "🌳", phonetic: "tee", funFact: "Trees give us shade and fresh air."),
        LearningItem(character: "U", type: .letter, exampleWord: "Umbrella", exampleEmoji: "☂️", phonetic: "yoo", funFact: "Umbrellas keep you dry in the rain."),
        LearningItem(character: "V", type: .letter, exampleWord: "Violin", exampleEmoji: "🎻", phonetic: "vee", funFact: "Violins make beautiful music with a bow."),
        LearningItem(character: "W", type: .letter, exampleWord: "Water", exampleEmoji: "💧", phonetic: "dub-ul-yoo", funFact: "Water helps flowers and you grow strong."),
        LearningItem(character: "X", type: .letter, exampleWord: "Xylophone", exampleEmoji: "🎵", phonetic: "eks", funFact: "Xylophones go ding-ding when you tap them."),
        LearningItem(character: "Y", type: .letter, exampleWord: "Yarn", exampleEmoji: "🧶", phonetic: "wy", funFact: "Yarn can be knitted into cozy scarves."),
        LearningItem(character: "Z", type: .letter, exampleWord: "Zebra", exampleEmoji: "🦓", phonetic: "zee", funFact: "Zebras have black and white stripes."),
    ]

    static let numbers: [LearningItem] = [
        LearningItem(character: "0", type: .number, exampleWord: "Zero", exampleEmoji: "0️⃣", phonetic: "zee-ro", funFact: "Zero means none—it comes before one!"),
        LearningItem(character: "1", type: .number, exampleWord: "One", exampleEmoji: "1️⃣", phonetic: "wun", funFact: "One sun shines in our sky."),
        LearningItem(character: "2", type: .number, exampleWord: "Two", exampleEmoji: "2️⃣", phonetic: "too", funFact: "You have two hands for clapping!"),
        LearningItem(character: "3", type: .number, exampleWord: "Three", exampleEmoji: "3️⃣", phonetic: "three", funFact: "Three little pigs built three houses."),
        LearningItem(character: "4", type: .number, exampleWord: "Four", exampleEmoji: "4️⃣", phonetic: "for", funFact: "A square has four equal sides."),
        LearningItem(character: "5", type: .number, exampleWord: "Five", exampleEmoji: "5️⃣", phonetic: "fyv", funFact: "Starfish often have five arms."),
        LearningItem(character: "6", type: .number, exampleWord: "Six", exampleEmoji: "6️⃣", phonetic: "siks", funFact: "Insects have six legs to walk around."),
        LearningItem(character: "7", type: .number, exampleWord: "Seven", exampleEmoji: "7️⃣", phonetic: "sev-en", funFact: "Rainbows have seven pretty colors."),
        LearningItem(character: "8", type: .number, exampleWord: "Eight", exampleEmoji: "8️⃣", phonetic: "ate", funFact: "Octopuses have eight wiggly arms."),
        LearningItem(character: "9", type: .number, exampleWord: "Nine", exampleEmoji: "9️⃣", phonetic: "nyn", funFact: "Nine planets—orbits dance around the sun."),
    ]

    static func item(for character: String) -> LearningItem? {
        all.first { $0.character == character }
    }

    static func randomUnmastered(from pool: [LearningItem], mastered: Set<String>) -> LearningItem? {
        let remaining = pool.filter { !mastered.contains($0.character) }
        return (remaining.isEmpty ? pool : remaining).randomElement()
    }
}
