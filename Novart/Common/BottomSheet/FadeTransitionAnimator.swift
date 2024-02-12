//
//  FadeTransitionAnimator.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit

final class FadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 0.2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        // Set initial alpha for the "to" view
        toView.alpha = 0.0
        
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: duration, animations: {
            // Fade in the "to" view
            toView.alpha = 1.0
            
            // Fade out the "from" view
            fromView.alpha = 0.0
        }, completion: { _ in
            // Reset alpha values and complete the transition
            fromView.alpha = 1.0
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

