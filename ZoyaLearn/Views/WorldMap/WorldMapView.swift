//
//  WorldMapView.swift
//  ZoyaLearn
//

import SwiftUI

struct WorldMapView: View {
    @EnvironmentObject var progressStore: ProgressStore
    @EnvironmentObject var avatarStore: AvatarStore
    @EnvironmentObject var appState: AppState
    @ObservedObject var mapVM: WorldMapViewModel

    @State private var dragOffset: CGSize = .zero
    @State private var activeLocation: MapLocation?
    @State private var showMuteInfo = false
    @State private var lessonExpanded = false

    private var avatar: Avatar { avatarStore.avatar ?? .defaultZoya }

    var body: some View {
        VStack(spacing: 0) {
            header

            ZStack {
                mapCanvas
                    .offset(dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { dragOffset = $0.translation }
                    )

                if let invite = mapVM.showInvitation {
                    VStack {
                        Spacer()
                        speechBubble(invite)
                            .padding(.bottom, 24)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if let lesson = appState.todaysLesson {
                todaysLessonBar(lesson)
            }
        }
        .background(ZLTheme.cream.ignoresSafeArea())
        .navigationDestination(item: $activeLocation) { location in
            destination(for: location)
        }
        .onAppear {
            appState.refreshTodaysLesson(progressStore: progressStore)
            mapVM.randomInvitation(for: avatar.name)
            resumePendingLessonNavigation()
        }
        .onChange(of: appState.pendingLessonDestination) { _, destination in
            guard let destination else { return }
            resumePendingLessonNavigation(to: destination)
        }
    }

    private func resumePendingLessonNavigation(to destination: MapLocation? = nil) {
        guard let destination = destination ?? appState.pendingLessonDestination else { return }
        goTo(destination)
        appState.clearLessonNavigation()
    }

    private var header: some View {
        HStack {
            HStack(spacing: 8) {
                Text("☀️")
                Text(mapVM.greeting(for: avatar.name))
                    .font(ZLTheme.headingFont)
                    .foregroundStyle(ZLTheme.ink)
            }
            Spacer()
            StarJarView(count: progressStore.totalStars, bounce: mapVM.starJarBounce)
            Button {
                showMuteInfo.toggle()
            } label: {
                Image(systemName: SoundManager.shared.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .foregroundStyle(ZLTheme.earth)
            }
            .popover(isPresented: $showMuteInfo) {
                Toggle("Sounds on", isOn: Binding(
                    get: { !SoundManager.shared.isMuted },
                    set: { SoundManager.shared.isMuted = !$0 }
                ))
                .padding()
            }
        }
        .padding()
    }

    private func todaysLessonBar(_ lesson: TodaysLesson) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Today")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(ZLTheme.earth)
                    Text(lesson.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(ZLTheme.ink)
                        .lineLimit(1)
                }

                lessonProgressDots(lesson)

                Button("Start") {
                    appState.beginLessonStep(.explore)
                }
                .buttonStyle(.borderedProminent)
                .tint(ZLTheme.grass)
                .controlSize(.small)

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        lessonExpanded.toggle()
                    }
                } label: {
                    Image(systemName: lessonExpanded ? "chevron.down" : "chevron.up")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(ZLTheme.earth)
                        .frame(width: 28, height: 28)
                        .background(ZLTheme.cream)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            if lessonExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(LessonStep.allCases.filter { $0 != .mastered }) { step in
                            let done = lesson.stepDone(step, progressStore: progressStore)
                            Button {
                                appState.beginLessonStep(step)
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: done ? "checkmark.circle.fill" : step.icon)
                                        .font(.caption)
                                    Text(step.rawValue)
                                        .font(.caption2.weight(.semibold))
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(done ? ZLTheme.grass.opacity(0.2) : ZLTheme.cream)
                                .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 10)
                }
            }
        }
        .background(ZLTheme.whiteSoft)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(ZLTheme.grass.opacity(0.25))
                .frame(height: 1)
        }
    }

    private func lessonProgressDots(_ lesson: TodaysLesson) -> some View {
        HStack(spacing: 5) {
            ForEach(LessonStep.allCases.filter { $0 != .mastered }) { step in
                let done = lesson.stepDone(step, progressStore: progressStore)
                Circle()
                    .fill(done ? ZLTheme.grass : ZLTheme.earth.opacity(0.2))
                    .frame(width: 8, height: 8)
            }
        }
    }

    private var mapCanvas: some View {
        ZStack(alignment: .topLeading) {
            Canvas { context, size in
                drawHills(context: &context, size: size)
                drawPath(context: &context, size: size)
            }
            .frame(width: 520, height: 620)

            ForEach(MapLocation.allCases) { location in
                MapLocationNode(
                    location: location,
                    isUnlocked: mapVM.isUnlocked(location),
                    isVisited: mapVM.visitedLocations.contains(location),
                    onTap: { goTo(location) }
                )
                .position(location.mapPosition)
            }

            ZoyaAvatarView(
                avatar: avatar,
                expression: mapVM.isWalking ? .walking : .idle,
                size: 64
            )
            .position(mapVM.avatarOffset)
        }
        .frame(width: 520, height: 620)
    }

    private func speechBubble(_ text: String) -> some View {
        Text(text)
            .font(ZLTheme.bodyFont)
            .foregroundStyle(ZLTheme.ink)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(ZLTheme.whiteSoft)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(ZLTheme.earth.opacity(0.3), lineWidth: 2))
            .padding(.horizontal)
    }

    private func goTo(_ location: MapLocation) {
        guard mapVM.isUnlocked(location) else { return }
        SoundManager.shared.playWoodTap()
        mapVM.walkTo(location) {
            mapVM.visit(location)
            activeLocation = location
        }
    }

    @ViewBuilder
    private func destination(for location: MapLocation) -> some View {
        switch location {
        case .letterHouse: LetterHouseView()
        case .artCorner: ArtCornerView()
        case .libraryTree: LibraryTreeView()
        case .backyard: BackyardView()
        case .trophyShed: TrophyShedView()
        }
    }

    private func drawHills(context: inout GraphicsContext, size: CGSize) {
        var sky = Path()
        sky.addRect(CGRect(origin: .zero, size: size))
        context.fill(sky, with: .linearGradient(
            Gradient(colors: [ZLTheme.warmSky, ZLTheme.cream]),
            startPoint: .zero,
            endPoint: CGPoint(x: 0, y: size.height)
        ))

        var hill = Path()
        hill.move(to: CGPoint(x: 0, y: size.height * 0.55))
        hill.addQuadCurve(to: CGPoint(x: size.width, y: size.height * 0.62), control: CGPoint(x: size.width * 0.45, y: size.height * 0.42))
        hill.addLine(to: CGPoint(x: size.width, y: size.height))
        hill.addLine(to: .zero)
        hill.closeSubpath()
        context.fill(hill, with: .color(ZLTheme.grass.opacity(0.45)))
    }

    private func drawPath(context: inout GraphicsContext, size: CGSize) {
        var path = Path()
        let points = MapLocation.allCases.map(\.mapPosition)
        guard let first = points.first else { return }
        path.move(to: first)
        for point in points.dropFirst() {
            path.addQuadCurve(to: point, control: CGPoint(x: (path.currentPoint?.x ?? 0 + point.x) / 2, y: point.y - 30))
        }
        context.stroke(path, with: .color(ZLTheme.earth.opacity(0.45)), style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [4, 8]))
    }
}

extension MapLocation: Hashable {}
