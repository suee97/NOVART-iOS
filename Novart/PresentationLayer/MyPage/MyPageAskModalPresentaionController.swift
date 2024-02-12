import UIKit
import SnapKit

/* refs.
https://medium.com/@vialyx/import-uikit-custom-modal-transitioning-with-swift-6f320de70f55
https://sujinnaljin.medium.com/swift-uisheetpresentationcontroller-%EB%BF%8C%EC%8B%9C%EA%B8%B0-eb982a09b55f
https://stackoverflow.com/questions/46711943/uipresentationcontroller-passing-touch-event/46713845#46713845
https://stackoverflow.com/questions/41594465/how-can-i-present-a-modal-view-on-top-of-a-tab-bar-controller */

final class MyPageAskModalPresentaionController: UIPresentationController {
    
    private lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return dimmingView
    }()
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let size = containerView?.frame.size ?? presentingViewController.view.frame.size
        return CGRect(origin: .zero, size: size)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else { return }
        let containerSize = containerView.bounds.size
        let preferredSize = presentedViewController.preferredContentSize
        
        if presentedViewController.isKind(of: MyPageAskModalViewController.self) {
            containerView.frame = CGRect(x: 0, y: containerSize.height - preferredSize.height,
                                         width: containerSize.width, height: preferredSize.height)
        }
        
        if presentedViewController.isKind(of: MyPageReportModalViewController.self) || presentedViewController.isKind(of: MyPageUserBlockViewController.self) {
            containerView.insertSubview(dimmingView, at: 0)
            dimmingView.snp.makeConstraints({ m in
                m.edges.equalToSuperview()
            })
        }
    }
    
    @objc private func onTapDimmingView() {
        presentingViewController.dismiss(animated: true)
    }
}
