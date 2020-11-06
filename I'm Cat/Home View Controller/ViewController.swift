//
//  ViewController.swift
//  I'm Cat
//
//  Created by JiaChen(: on 5/11/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUp()
    }
    
    func setUp() {
        setUpHeaderLabel()
        setUpNextButton()
    }
}

