//
//  AnimatorProtocol.swift
//  Transitions
//
//  Created by Artsiom Grintsevich on 12/22/15.
//  Copyright © 2015 Artsiom Grintsevich. All rights reserved.
//

import UIKit

protocol AnimatorProtocol {

    func views(context: UIViewControllerContextTransitioning) -> (container: UIView, from: UIView, to: UIView)
    
    func transform(context: UIViewControllerContextTransitioning, _ container: UIView, _ from: UIView, _ to: UIView)
}

extension AnimatorProtocol {
    func views(context: UIViewControllerContextTransitioning) -> (container: UIView, from: UIView, to: UIView) {
        let container = context.containerView()!
        
        let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let fromView = context.viewForKey(UITransitionContextFromViewKey) ?? fromVC.view
        
        let toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView = context.viewForKey(UITransitionContextToViewKey) ?? toVC.view
        
        return (container, fromView!, toView!)
    }
}