import Playgrounds
import SwiftUI

let listTrackWidth: CGFloat = 120

struct ContentView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @State var trackScale: CGFloat = 1
    @State var viewMode: Self.ViewMode = .track

    private let colors: [Color] = [.red, .blue, .green, .orange, .black]

    enum ViewMode {
        case track
        case list
    }

    var body: some View {
        GeometryReader { outerProxy in
            if verticalSizeClass == .compact {
                // Landscape Mode
                ScrollView(.horizontal) {
                    let containerHeight = outerProxy.size.height

                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            ForEach(colors, id: \.self) { color in
                                switch viewMode {
                                case .track:
                                    ZStack {
                                        color
                                        Text("\(color.description)")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    }
                                    .frame(width: 2000, height: containerHeight)
                                case .list:
                                    ZStack {
                                        color
                                        Text("\(color.description)")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    }
                                    .frame(width: 2000, height: listTrackWidth)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollClipDisabled()
                    .scaleEffect(y: trackScale)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                }
                .modifier(
                    TrackMagnicationModifier(
                        trackScale: $trackScale,
                        viewMode: $viewMode,
                        projectModeThreshold: 0.7,
                        trackModeThreshold: 1.5
                    )
                )
            } else {
                // Portrait Mode
                ScrollView(.vertical) {
                    let containerWidth = outerProxy.size.width

                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(colors, id: \.self) { color in
                                switch viewMode {
                                case .track:
                                    ZStack {
                                        color
                                        Text("\(color.description)")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    }
                                    .frame(width: containerWidth, height: 2000)
                                case .list:
                                    ZStack {
                                        color
                                        Text("\(color.description)")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    }
                                    .frame(width: listTrackWidth, height: 2000)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollClipDisabled()
                    .scaleEffect(x: trackScale)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                }
                .modifier(
                    TrackMagnicationModifier(
                        trackScale: $trackScale,
                        viewMode: $viewMode,
                        projectModeThreshold: 0.7,
                        trackModeThreshold: 1.5
                    )
                )
            }
        }
    }
}

struct TrackMagnicationModifier: ViewModifier {
    @Binding var trackScale: CGFloat
    @Binding var viewMode: ContentView.ViewMode

    let projectModeThreshold: CGFloat
    let trackModeThreshold: CGFloat

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                MagnifyGesture()
                    .onChanged { value in
                        trackScale = value.magnification
                    }
                    .onEnded { value in
                        if value.magnification < projectModeThreshold {
                            viewMode = .list
                        } else if value.magnification > trackModeThreshold {
                            viewMode = .track
                        }

                        withAnimation {
                            trackScale = 1
                        }
                    }
            )
    }
}

#Preview {
    ContentView()
}
