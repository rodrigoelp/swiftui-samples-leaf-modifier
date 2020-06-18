//

import SwiftUI

struct ContentView: View {
    @State private var leafRadius: CGFloat = 0
    @EnvironmentObject private var viewModel: ViewModel

    var body: some View {
        VStack {
            Spacer()
            Image(viewModel.image)
                .resizable()
                .scaledToFit()
                .leafyrised(radius: viewModel.leafRadius)
                .animation(.interpolatingSpring(stiffness: 200, damping: 200, initialVelocity: 10))
                .padding()
            Spacer()
            Text("Image name: \(viewModel.image)")
                .padding(.bottom, 16)
        }.onAppear(perform: start)
    }

    private func start() {
        viewModel.start()
    }
}

extension View {
    func leafyrised(radius: CGFloat) -> some View {
        let corners: UIRectCorner = radius > 0 ? [ .bottomLeft, .topRight ] : []
        return modifier(LeafyStyle(radius: radius, corners: corners))
    }
}

struct LeafyStyle: ViewModifier {
    let radius: CGFloat
    let corners: UIRectCorner

    func body(content: Content) -> some View {
        content.clipShape(CustomCornerRadiusShape(radius: radius, corners: corners))
    }
}

struct CustomCornerRadiusShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
