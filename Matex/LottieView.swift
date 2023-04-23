import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    let name: String
    var loopMode: LottieLoopMode = .loop
    let completion: () -> Void

    func makeUIView(context _: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = 1
        animationView.play { _ in
            completion()
        }

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}
