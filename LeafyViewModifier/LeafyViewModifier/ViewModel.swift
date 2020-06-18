import SwiftUI // just because I am using CGFloat. I could avoid this, but this is a sample...
import Combine

class ViewModel: ObservableObject {
    private static let images = [ "rocks-balancing", "white-pebble-stone", "leaves-black-pebble" ]
    private let ticker = Timer.publish(every: 4, on: RunLoop.main, in: .default)

    private var disposeBag: Set<AnyCancellable> = []
    @Published private var currentIndex = 0
    @Published var image: String = ViewModel.images[0]
    @Published var leafRadius: CGFloat = 0

    deinit {
        disposeBag.removeAll()
    }

    func start() {
        ticker.autoconnect()
            .map { [weak self] _ in ((self?.currentIndex ?? 0) + 1) % ViewModel.images.count }
            .assign(to: \.currentIndex, on: self)
            .store(in: &disposeBag)

        $currentIndex
            .map { index in ViewModel.images[index] }
            .assign(to: \.image, on: self)
            .store(in: &disposeBag)

        $currentIndex.map { index -> CGFloat in  CGFloat(index) * 45 }
            .assign(to: \.leafRadius, on: self)
            .store(in: &disposeBag)
    }
}
