//
//  BlurAnimator.swift
//  Transitions
//
//  Created by Artsiom Grintsevich on 12/22/15.
//  Copyright © 2015 Artsiom Grintsevich. All rights reserved.
//

import UIKit


class BlurAnimator: NSObject, UIViewControllerAnimatedTransitioning, AnimatorProtocol {
    
    var direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    var imageBounds: CGRect! = nil
    var imageFrame: CGRect! = nil
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let (container, from, to) = views(transitionContext)
        transform(transitionContext, container, from, to)
    }
    
    func transform(context: UIViewControllerContextTransitioning, _ container: UIView, _ from: UIView, _ to: UIView) {
        let duration = transitionDuration(context) / 2
        
        let toView = direction.bool ? to : from
        let fromView = direction.bool ? from : to
        let imageView: UIImageView? = findImageView(fromView)
        
        let initialTransition = { [unowned self] in
            if self.direction.bool {
                toView.alpha = 1
            } else {
                imageView?.bounds = self.imageBounds!
                imageView?.frame = self.imageFrame!
            }
        }
        
        func completeTransition() {
            if context.transitionWasCancelled() {
                container.superview?.addSubview(from)
                context.completeTransition(false)
            } else {
                let completion: ((Bool) -> Void)? = {
                    completed in
                    if !self.direction.bool {
                        container.superview?.addSubview(fromView)
                    }
                    context.completeTransition(true)
                }
                
                UIView.animateWithDuration(duration, delay: 0.0,
                    usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2,
                    options: [],
                    animations: {
                        if !self.direction.bool {
                            toView.alpha = 0
                        } else {
                            imageView?.bounds = container.bounds
                            imageView?.frame = container.bounds
                        }
                    }, completion: completion)
            }
        }
        
        toView.alpha = direction.bool ? 0 : 1
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        UIView.animateWithDuration(duration, animations: initialTransition) { completed in completeTransition() }
    }
    
    func findImageView(parent: UIView) -> UIImageView? {
        let imageView = parent.viewWithTag(1) as? UIImageView
        
        if imageBounds == nil { imageBounds = imageView?.bounds }
        if imageFrame == nil { imageFrame = imageView?.frame }
        
        imageView?.translatesAutoresizingMaskIntoConstraints = true
        imageView?.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        
        return imageView
    }
    
    func animationEnded(transitionCompleted: Bool) {
        print("Animation is ended [completed - \(transitionCompleted)]")
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.75
    }
    
}