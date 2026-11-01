import Playgrounds
import SwiftUI

struct Track: Identifiable, Hashable {
    let id: Int
    let color: Color
}

struct ContentView: View {
    @Namespace private var animation

    @State private var selectedTrack: Int?
    @State private var scrollPosition: ScrollPosition = .init()
    
    @State private var animated: Bool = false
    @State private var trackWidth: CGFloat = 120
    @State private var overlayOffset: CGVector = .zero

    private let tracks: [Track] = [
        Track(id: 0, color: .red),
        Track(id: 1, color: .blue),
        Track(id: 2, color: .green),
        Track(id: 3, color: .orange),
        Track(id: 4, color: .black),
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { outerProxy in
                let availableWidth = outerProxy.size.width

                ZStack {
                    if let selectedTrack = selectedTrack {
                        let track = tracks[selectedTrack]

                        TrackView(track: track, detailed: true)
                            .frame(width: availableWidth)
                            .onTapGesture {
                                animateDeselectTrack(width: availableWidth)
                            }
                    } else {
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
                    }

                    if animated {
                        HStack(spacing: 0) {
                            ForEach(tracks) { track in
                                TrackView(track: track)
                                    .frame(width: trackWidth)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: overlayOffset.dx, y: overlayOffset.dy)
                    }
                }
            }
        }
    }

    private func animateSelectTrack(index: Int, width availableWidth: CGFloat) {
        selectedTrack = index
        overlayOffset = .init(dx: -(scrollPosition.x ?? 0), dy: -(scrollPosition.y ?? 0))
        animated = true

        withAnimation(.spring, completionCriteria: .removed) {
            overlayOffset.dx = CGFloat(index) * -availableWidth
            trackWidth = availableWidth
        } completion: {
            animated = false
        }
    }

    private func animateDeselectTrack(width availableWidth: CGFloat) {
        let index = selectedTrack ?? 0
        selectedTrack = nil
        
        let targetOffset = max(0, min(CGFloat(index) * 120, CGFloat(tracks.count) * 120 - availableWidth))
        overlayOffset = .init(dx: CGFloat(index) * -availableWidth, dy: scrollPosition.y ?? 0)
        animated = true

        withAnimation(.spring, completionCriteria: .removed) {
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
