import Playgrounds
import SwiftUI

let listTrackWidth: CGFloat = 120

struct ContentView: View {
    @State var openedTrack: Int?
    @State var viewMode: Self.ViewMode = .list
    @State var listItemScale: CGFloat = 1

    private let colors: [Color] = [.red, .blue, .green, .orange, .black]

    enum ViewMode {
        case track
        case list
    }

    var body: some View {
        NavigationStack {
            GeometryReader { outerProxy in
                let containerWidth = outerProxy.size.width

                ScrollView(.vertical) {
                    switch viewMode {
                    case .track:
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                ForEach(0..<colors.count, id: \.self) {
                                    index in
                                    let color = colors[index]
                                    ZStack {
                                        color
                                        Text("\(color.description)")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    }
                                    .frame(width: containerWidth, height: 2000)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollClipDisabled()
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.viewAligned)
                        .scrollPosition(id: $openedTrack)
                    case .list:
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 0) {
                                ForEach(0..<colors.count, id: \.self) {
                                    index in
                                    Button {
                                        openedTrack = index

                                        Task { @MainActor in
                                            withAnimation(.bouncy()) {
                                                listItemScale = containerWidth / listTrackWidth
                                            } completion: {
                                                viewMode = .track
                                                listItemScale = 1
                                            }
                                        }
                                    } label: {
                                        let color = colors[index]
                                        ZStack {
                                            color
                                            Text("\(color.description)")
                                                .font(.title)
                                                .foregroundStyle(.white)
                                        }
                                    }
                                    .frame(width: listTrackWidth, height: 2000)
                                    .scaleEffect(
                                        x: index == openedTrack
                                            ? listItemScale : 1,
                                        anchor: index == 0
                                            ? .leading
                                            : index == colors.count - 1
                                                ? .trailing : .center
                                    )
                                    .zIndex(index == openedTrack ? 1 : 0)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollClipDisabled()
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.viewAligned)
                        .scrollPosition(
                            id: $openedTrack,
                            anchor: .center
                        )
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            viewMode = .list
                            listItemScale = containerWidth / listTrackWidth

                            Task { @MainActor in
                                await Task.yield()
                                withAnimation(.bouncy()) {
                                    listItemScale = 1
                                }
                            }
                        }) {
                            Image(systemName: "list.bullet")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
