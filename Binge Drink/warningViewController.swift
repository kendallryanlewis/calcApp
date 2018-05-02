//
//  warningViewController.swift
//  Binge Drink
//
//  Created by Kendall Lewis on 4/16/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit

class warningViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "goToMainUI", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
