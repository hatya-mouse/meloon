import Playgrounds
import SwiftUI

let trackAnimation: Animation = .timingCurve(
    0.25,
    0.8,
    0.35,
    1.0,
    duration: 0.25
)

struct ContentView: View {
    // MARK: States

    @State private var selectedTrack: Int?
    @State private var availableWidth: CGFloat = 0
    @State private var showBackButton: Bool = false
    @State private var playhead: Double = 0
    /// The time scale before the magnification gesture.
    @State private var oldTimeScale: Double = 1
    /// The current time scale.
    @State private var timeScale: Double = 1

    // Animation States
    @State private var animated: Bool = false
    @State private var trackWidth: CGFloat = 120
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var overlayOffset: CGVector = .zero
    @State private var listScrollOffset: CGPoint = .zero

    // MARK: Tracks

    private let tracks: [any Track] = [
        AudioTrack(name: "Red", color: .init(r: 255, g: 0, b: 0)),
        AudioTrack(name: "Blue", color: .init(r: 0, g: 239, b: 255)),
        AudioTrack(name: "Green", color: .init(r: 24, g: 124, b: 0)),
        AudioTrack(name: "Orange", color: .init(r: 255, g: 165, b: 0)),
        AudioTrack(name: "Black", color: .init(r: 26, g: 26, b: 26)),
    ]

    // MARK: UI

    var body: some View {
        NavigationStack {
            GeometryReader { outerProxy in
                ZStack {
                    if animated {
                        // Track Animation Overlay
                        HStack(spacing: 0) {
                            ForEach(tracks, id: \.id) { track in
                                TrackListItemView(track: track)
                                    .frame(width: trackWidth)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: overlayOffset.dx, y: overlayOffset.dy)
                    } else if let selectedTrack = selectedTrack {
                        // Track Mode
                        let track = tracks[selectedTrack]

                        TrackDetailView(track: track)
                            .frame(width: availableWidth)
                    } else {
                        // Track List Mode
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                ForEach(tracks.enumerated(), id: \.element.id) {
                                    index,
                                    track in
                                    TrackListItemView(track: track)
                                        .frame(width: 120)
                                        .onTapGesture {
                                            animateSelectTrack(
                                                index: index,
                                                width: availableWidth
                                            )
                                        }
                                }
                            }
                        }
                        .scrollIndicators(.never)
                        .scrollPosition($scrollPosition)
                        .onScrollGeometryChange(for: CGPoint.self) { geometry in
                            geometry.contentOffset
                        } action: { _, newValue in
                            listScrollOffset = newValue
                        }
                    }

                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: availableWidth, height: 2)
                        .position(x: availableWidth * 0.5, y: playhead * timeScale)
                }
                .onChange(of: outerProxy.size.width, initial: true) {
                    _,
                    newWidth in
                    availableWidth = newWidth
                }
                .gesture(MagnifyGesture().onChanged { value in
                    timeScale = oldTimeScale * value.magnification
                })
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    if showBackButton {
                        Button("Back", systemImage: "chevron.left") {
                            animateDeselectTrack(width: availableWidth)
                        }
                    } else {
                        Button("Home", systemImage: "house") {}
                    }
                }
            }
        }
    }

    // MARK: Animation

    private func animateSelectTrack(index: Int, width availableWidth: CGFloat) {
        overlayOffset = .init(dx: -listScrollOffset.x, dy: -listScrollOffset.y)
        selectedTrack = index
        animated = true

        withAnimation(trackAnimation, completionCriteria: .removed) {
            showBackButton = true
            overlayOffset.dx = CGFloat(index) * -availableWidth
            trackWidth = availableWidth
        } completion: {
            animated = false
        }
    }

    private func animateDeselectTrack(width availableWidth: CGFloat) {
        let index = selectedTrack ?? 0
        let targetOffset = max(
            0,
            min(
                CGFloat(index) * 120,
                CGFloat(tracks.count) * 120 - availableWidth
            )
        )
        overlayOffset = .init(
            dx: CGFloat(index) * -availableWidth,
            dy: listScrollOffset.y
        )
        selectedTrack = nil
        animated = true

        withAnimation(trackAnimation, completionCriteria: .removed) {
            showBackButton = false
            overlayOffset.dx = -targetOffset
            trackWidth = 120
        } completion: {
            animated = false
            scrollPosition.scrollTo(x: targetOffset)
        }
    }
}

#Preview {
    ContentView()
}
