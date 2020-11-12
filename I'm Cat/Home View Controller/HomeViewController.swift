//
//  HomeViewController.swift
//  I'm Cat
//
//  Created by JiaChen(: on 5/11/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUp()
    }
    
    @IBAction func openCat(_ sender: Any) {
        performSegue(withIdentifier: "showcats", sender: nil)
    }
}

