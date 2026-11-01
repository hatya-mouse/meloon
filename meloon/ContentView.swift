import Playgrounds
import SwiftUI

let trackAnimation: Animation = .timingCurve(
    0.25, 0.8,
    0.35, 1.0,
    duration: 0.25
)

struct Track: Identifiable, Hashable {
    let id: Int
    let color: Color
}

struct ContentView: View {
    // MARK: States

    @State private var selectedTrack: Int?
    @State private var availableWidth: CGFloat = 0
    @State private var showBackButton: Bool = false

    // Animation States
    @State private var animated: Bool = false
    @State private var trackWidth: CGFloat = 120
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var overlayOffset: CGVector = .zero
    @State private var listScrollOffset: CGPoint = .zero

    // MARK: Tracks

    private let tracks: [Track] = [
        Track(id: 0, color: .red),
        Track(id: 1, color: .blue),
        Track(id: 2, color: .green),
        Track(id: 3, color: .orange),
        Track(id: 4, color: .black),
    ]
    
    // MARK: UI

    var body: some View {
        NavigationStack {
            GeometryReader { outerProxy in
                ZStack {
                    if animated {
                        // Track Animation Overlay
                        HStack(spacing: 0) {
                            ForEach(tracks) { track in
                                TrackView(track: track)
                                    .frame(width: trackWidth)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: overlayOffset.dx, y: overlayOffset.dy)
                    } else if let selectedTrack = selectedTrack {
                        // Track Mode
                        let track = tracks[selectedTrack]

                        TrackView(track: track, detailed: true)
                            .frame(width: availableWidth)
                            .onTapGesture {
                                animateDeselectTrack(width: availableWidth)
                            }
                    } else {
                        // Track List Mode
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                ForEach(tracks) { track in
                                    TrackView(track: track)
                                        .frame(width: 120)
                                        .onTapGesture {
                                            animateSelectTrack(index: track.id, width: availableWidth)
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
                }
                .onChange(of: outerProxy.size.width, initial: true) { _, newWidth in
                    availableWidth = newWidth
                }
            }
            .toolbar {
                if showBackButton {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back", systemImage: "chevron.left") {
                            animateDeselectTrack(width: availableWidth)
                        }
                    }
                }
            }
        }
    }

    // MARK: Animation

    private func animateSelectTrack(index: Int, width availableWidth: CGFloat) {
        overlayOffset = .init(dx: -listScrollOffset.x, dy: -listScrollOffset.y)
        animated = true
        
        withAnimation {
            showBackButton = true
        }

        withAnimation(trackAnimation, completionCriteria: .removed) {
            overlayOffset.dx = CGFloat(index) * -availableWidth
            trackWidth = availableWidth
        } completion: {
            selectedTrack = index
            animated = false
        }
    }

    private func animateDeselectTrack(width availableWidth: CGFloat) {
        let index = selectedTrack ?? 0
        let targetOffset = max(0, min(CGFloat(index) * 120, CGFloat(tracks.count) * 120 - availableWidth))
        overlayOffset = .init(dx: CGFloat(index) * -availableWidth, dy: listScrollOffset.y)
        animated = true
        
        withAnimation {
            showBackButton = false
        }

        withAnimation(trackAnimation, completionCriteria: .removed) {
            overlayOffset.dx = -targetOffset
            trackWidth = 120
        } completion: {
            selectedTrack = nil
            animated = false
            scrollPosition.scrollTo(x: targetOffset)
        }
    }
}

#Preview {
    ContentView()
}
