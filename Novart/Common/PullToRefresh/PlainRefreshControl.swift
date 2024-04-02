import UIKit
import Lottie

final class PlainRefreshControl: UIRefreshControl {
    
    private let loadingView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loading_indicator")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loopMode = .loop
        view.isHidden = true
        return view
    }()
    
    override init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(beginRefreshing), for: .valueChanged)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        loadingView.play()
        loadingView.isHidden = false
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        loadingView.pause()
        loadingView.isHidden = true
    }
    
    private func setUpView() {
        tintColor = .clear
        addSubview(loadingView)
        loadingView.snp.makeConstraints({ m in
            m.width.height.equalTo(24)
            m.center.equalToSuperview()
        })
    }
}
