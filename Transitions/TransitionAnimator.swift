//
//  TransitionAnimator.swift
//  Transitions
//
//  Created by Artsiom Grintsevich on 12/22/15.
//  Copyright © 2015 Artsiom Grintsevich. All rights reserved.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, AnimatorProtocol {
    
    var direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let (container, from, to) = views(transitionContext)
        transform(transitionContext, container, from, to)
    }
    
    func transform(context: UIViewControllerContextTransitioning, _ container: UIView, _ from: UIView, _ to: UIView) {
        let duration = self.transitionDuration(context)
        let width = container.frame.width
        var fromTranslate = CGAffineTransformIdentity
        var toTranslate = CGAffineTransformIdentity
        
        let initialTransition = {
            fromTranslate.tx = 2 / 3 * width * (self.direction.multiplier)
            toTranslate.tx = 2 / 3 * width * (self.direction.inverse.multiplier)
            
            from.transform = fromTranslate
            to.transform = toTranslate
        }
        
        func completeTransition() {
            if context.transitionWasCancelled() {
                container.superview?.addSubview(from)
                context.completeTransition(false)
            } else {
                let completion: ((Bool) -> Void)? = {
                    completed in
                    container.superview?.addSubview(to)
                    context.completeTransition(true)
                }
            
                UIView.animateWithDuration(duration / 2, delay: duration, options: [],
                    animations: {
                        [unowned self] in
                        fromTranslate.tx = width * self.direction.multiplier
                        
                        from.transform = fromTranslate
                        to.transform = CGAffineTransformIdentity
                    },
                    completion: completion)
            }
        }
        
        to.transform = CGAffineTransformMakeTranslation(direction.inverse.multiplier * width, 0)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        indicator.startAnimating()
        indicator.center = container.center
        
        container.backgroundColor = UIColor.grayColor()
        container.addSubview(indicator)
        container.addSubview(from)
        container.addSubview(to)
        
        UIView.animateWithDuration(duration / 2, animations: initialTransition) { completed in completeTransition() }
    }
    
    
    func animationEnded(transitionCompleted: Bool) {
        print("Animation is ended [completed - \(transitionCompleted)]")
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.75
    }

}