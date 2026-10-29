import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    private let colors: [Color] = [.red, .blue, .green, .orange, .black]

    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geometry in
                ZStack {
                    ForEach(Array(zip(colors.indices, colors)), id: \.1.self) { index, color in
                        ZStack {
                            color
                            Text("\(color.description)")
                                .font(.title)
                                .foregroundStyle(.white)
                        }
                        .frame(width: geometry.size.width)
                        .offset(x: CGFloat(index - currentIndex) * geometry.size.width + dragOffset)
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            let trackWidth = geometry.size.width
                            let offset = value.translation.width / trackWidth
                            
                            if value.velocity.width == 0 {
                                return
                            }

                            withAnimation(Animation.spring(duration: trackWidth / value.velocity.width)) {
                                dragOffset = 0
                                if value.translation.width < -offset {
                                    currentIndex = min(currentIndex + 1, colors.count - 1)
                                } else if value.translation.width > offset {
                                    currentIndex = max(currentIndex - 1, 0)
                                }
                            }
                        }
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ContentView()
}
