//
//  BottomSheetNavigationController.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit
import Combine

final class BottomSheetNavigationController: BaseNavigationController {
    
    private var cancellables: Set<AnyCancellable> = []
    
    let dynamicHeight: PassthroughSubject<(height: CGFloat, additional: Bool), Never>? = .init()
    
    var bottomSheetConfiguration: BottomSheetConfiguration = .init()
    
    override var transition: UIViewControllerAnimatedTransitioning? {
        return FadeTransitionAnimator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
        bind()
    }
    
    private func bind() {
        dynamicHeight?.receive(on: DispatchQueue.main)
            .sink { [weak self] height, isAdditional in
                self?.changeDetent(height: height, isAdditional: isAdditional)
            }
            .store(in: &cancellables)
    }
    
    private func changeDetent(height: CGFloat, isAdditional: Bool) {
        guard let sheet = sheetPresentationController else { return }
        
        if isAdditional {
            bottomSheetConfiguration.customHeight += height
        } else {
            bottomSheetConfiguration.customHeight = height
        }
        
        sheet.animateChanges {
            sheet.detents = bottomSheetConfiguration.makeDetents()
            sheet.invalidateDetents()
        }
    }
    
    func keyboardWillShow() {
        let bottomInset = view.safeAreaInsets.bottom
        dynamicHeight?.send((-bottomInset, true))
    }
    
    func keyboardWillHide() {
        let bottomInset = view.safeAreaInsets.bottom
        dynamicHeight?.send((bottomInset, true))
    }
}
