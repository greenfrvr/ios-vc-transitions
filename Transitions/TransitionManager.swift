//
//  TransitionManager.swift
//  Transitions
//
//  Created by Artsiom Grintsevich on 12/18/15.
//  Copyright © 2015 Artsiom Grintsevich. All rights reserved.
//

import UIKit

class TransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate {
    
    //MARK: Properties
    private var enterPanRecognizer: UIScreenEdgePanGestureRecognizer!
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanRecognizer = UIScreenEdgePanGestureRecognizer()
            self.enterPanRecognizer.addTarget(self, action:"panHandling:")
            self.enterPanRecognizer.edges = .Right
            self.sourceViewController.view.addGestureRecognizer(self.enterPanRecognizer)
        }
    }
    
    private var exitPanRecognizer: UIScreenEdgePanGestureRecognizer!
    private var exitPinchRecognizer: UIPinchGestureRecognizer!
    var destinationViewController: UIViewController! {
        didSet {
            self.exitPanRecognizer = UIScreenEdgePanGestureRecognizer()
            self.exitPanRecognizer.addTarget(self, action: "exitPanHandling:")
            self.exitPanRecognizer.edges = .Left
            self.destinationViewController.view.addGestureRecognizer(self.exitPanRecognizer)
            
            self.exitPinchRecognizer = UIPinchGestureRecognizer()
            self.exitPinchRecognizer.addTarget(self, action: "exitPinchHandling:")
            self.destinationViewController.view.addGestureRecognizer(self.exitPinchRecognizer)

        }
    }
    
    lazy var blurAnimator = BlurAnimator(direction: .Straight)
    lazy var translateAnimator = TransitionAnimator(direction: .Straight)
    
    var interactive = false
    var needBlurAnimation = true
    
    //MARK: Transitioning delegate
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        blurAnimator.direction = .Straight
        translateAnimator.direction = .Straight
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        blurAnimator.direction = .Reverse
        translateAnimator.direction = .Reverse
        return self.interactive ? self : nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("Dismiss")
        blurAnimator.direction = .Reverse
        translateAnimator.direction = .Reverse
        return needBlurAnimation ? blurAnimator : translateAnimator
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("Present")
        blurAnimator.direction = .Straight
        translateAnimator.direction = .Straight
        return needBlurAnimation ? blurAnimator : translateAnimator
    }
    
    //MARK: Gesture handling
    func panHandling(pan: UIPanGestureRecognizer) {
        let translation = pan.translationInView(pan.view!)
        let d = -translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
        
        switch (pan.state) {
        case UIGestureRecognizerState.Began:
            interactive = true
            sourceViewController.performSegueWithIdentifier("presentMenu", sender: self)
        case UIGestureRecognizerState.Changed:
            updateInteractiveTransition(d)
        default:
            interactive = false
            if d > 0.2 {
                finishInteractiveTransition()
            } else {
                cancelInteractiveTransition()
            }
        }
    }
    
    func exitPanHandling(pan: UIPanGestureRecognizer) {
        let translation = pan.translationInView(pan.view!)
        let delta = translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
        
        unwind(pan.state, delta)
    }
    
    func exitPinchHandling(pinch: UIPinchGestureRecognizer) {
        let delta = (1 - pinch.scale) * 0.75
        if pinch.velocity > 0 && pinch.scale >= 1 {
            return
        }
        
        unwind(pinch.state, delta)
    }
    
    func unwind(state: UIGestureRecognizerState, _ delta: CGFloat) {
        print("Delta - \(delta)")
        switch (state) {
        case UIGestureRecognizerState.Began:
            interactive = true
            destinationViewController.performSegueWithIdentifier("unwindBack", sender: self)
        case UIGestureRecognizerState.Changed:
            updateInteractiveTransition(delta)
        default:
            interactive = false
            if delta > 0.2 {
                finishInteractiveTransition()
            } else {
                cancelInteractiveTransition()
            }
        }
    }
}

enum Direction: String {
    case Straight, Reverse
    
    var inverse: Direction {
        switch self {
        case Straight: return Reverse
        case Reverse: return Straight
        }
    }
    
    var multiplier: CGFloat {
        switch self {
        case Straight: return -1.0
        case Reverse: return 1.0
        }
    }
    
    var bool: Bool {
        switch self {
        case Straight: return true
        case Reverse: return false
        }
    }
    
    mutating func revert() {
        self = self.inverse
    }
}
