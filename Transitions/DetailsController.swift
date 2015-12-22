//
//  DetailsController.swift
//  Transitions
//
//  Created by Artsiom Grintsevich on 12/21/15.
//  Copyright © 2015 Artsiom Grintsevich. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    @IBAction func dismissCurrentController(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
    }
    
}
