# ZoyaLearn

ABC & 123 learning app for **Zoya** — letters A–Z, numbers 0–9, with Learn, Trace, Flashcards, Games, and Progress tabs.

## Requirements

- Xcode 15+
- iOS 17+ (iPhone & iPad)
- macOS 14+ (native Mac target)

## Open in Xcode

```bash
open ZoyaLearn.xcodeproj
```

Select the **ZoyaLearn** scheme and run on **My Mac** or an iOS simulator.

## Features

- **Learn** — swipeable character cards with speech, emoji, and “mark as learned”
- **Trace** — draw over letters/numbers on a canvas; earn stars on success
- **Flashcards** — flip cards, shuffle deck, streak counter
- **Games** — Match It, Find It, Fill in the Blank
- **Progress** — mastery rings, character grid, trophy badges, parent dashboard (Face ID / PIN)

## Parent dashboard

Default PIN: `1234` (change in `ParentGateView.swift` before shipping).

## Structure

Matches the spec: Models, ViewModels, Views (by tab), Components, Utilities, shared Assets.
