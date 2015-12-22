//
//  ViewController.swift
//  Transitions
//
//  Created by Artsiom Grintsevich on 12/17/15.
//  Copyright © 2015 Artsiom Grintsevich. All rights reserved.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    lazy var transition = TransitionManager()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func presentController(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("second")
        controller?.transitioningDelegate = self.transition
        transition.destinationViewController = controller
        self.presentViewController(controller!, animated: true, completion: nil)
    }
    
    @IBAction func switchAnimation(sender: UISwitch) {
        transition.needBlurAnimation = sender.on
    }
    
    @IBAction func pickImage(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.sourceType = .PhotoLibrary
            controller.delegate = self
            showViewController(controller, sender: self)
        } else {
            print("library not available")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        picker.dismissViewControllerAnimated(true, completion: {
            print("\(editingInfo)")
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: {
            print("Canceled")
        })
    }
    
    @IBAction func unwindBack(segue: UIStoryboardSegue) {
        print("Unwind segue")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as UIViewController
        destination.transitioningDelegate = transition
        transition.destinationViewController = destination
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transition.sourceViewController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.presentingViewController == nil ? UIStatusBarStyle.Default : UIStatusBarStyle.LightContent
    }

}

