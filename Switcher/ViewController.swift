//
//  ViewController.swift
//  Switcher
//
//  Created by Parag Dulam on 06/11/16.
//  Copyright © 2016 Parag Dulam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var switcher: UserSwitcher!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        switcher.userIds = ["1","2","3","4"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

