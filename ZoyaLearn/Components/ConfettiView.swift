//
//  ConfettiView.swift
//  ZoyaLearn
//

import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    let isActive: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: !isActive)) { timeline in
            Canvas { context, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                for particle in particles {
                    var p = particle
                    let y = (p.y + CGFloat(t - p.start) * p.speed).truncatingRemainder(dividingBy: size.height + 40) - 20
                    let x = p.x + sin(CGFloat(t) * p.wobble) * 18
                    let rect = CGRect(x: x, y: y, width: p.size, height: p.size)
                    context.fill(Path(ellipseIn: rect), with: .color(p.color))
                }
            }
        }
        .allowsHitTesting(false)
        .onChange(of: isActive) { _, active in
            if active { spawn() }
        }
        .onAppear {
            if isActive { spawn() }
        }
    }

    private func spawn() {
        particles = (0..<48).map { i in
            ConfettiParticle(
                x: CGFloat.random(in: 0...360),
                y: CGFloat.random(in: -400...0),
                size: CGFloat.random(in: 6...12),
                speed: CGFloat.random(in: 80...160),
                wobble: CGFloat.random(in: 1...3),
                color: ZLTheme.accentColors[i % ZLTheme.accentColors.count],
                start: Date.timeIntervalSinceReferenceDate
            )
        }
    }
}

private struct ConfettiParticle {
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat
    var wobble: CGFloat
    var color: Color
    var start: TimeInterval
}
