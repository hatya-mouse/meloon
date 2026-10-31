import SwiftUI
import Playgrounds

struct ContentView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State var listMagnification: CGFloat = 1

    private let colors: [Color] = [.red, .blue, .green, .orange, .black]

    var body: some View {
        GeometryReader { outerProxy in
            if verticalSizeClass == .compact {
                // Landscape Mode
                ScrollView(.horizontal) {
                    let containerHeight = outerProxy.size.height

                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            ForEach(colors, id: \.self) { color in
                                ZStack {
                                    color
                                    Text("\(color.description)")
                                        .font(.title)
                                        .foregroundStyle(.white)
                                }
                                .frame(width: 2000, height: containerHeight)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollClipDisabled()
                    .scaleEffect(y: listMagnification)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                }
                .simultaneousGesture(
                    MagnifyGesture()
                        .onChanged { value in
                            listMagnification = value.magnification
                        }
                        .onEnded { value in
                            withAnimation {
                                listMagnification = 1
                            }
                        }
                )
            } else {
                // Portrait Mode
                ScrollView(.vertical) {
                    let containerWidth = outerProxy.size.width
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(colors, id: \.self) { color in
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
                    .scaleEffect(x: listMagnification)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                }
                .simultaneousGesture(
                    MagnifyGesture()
                        .onChanged { value in
                            listMagnification = value.magnification
                        }
                        .onEnded { value in
                            withAnimation {
                                listMagnification = 1
                            }
                        }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
