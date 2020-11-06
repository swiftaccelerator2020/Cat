//
//  ViewController.swift
//  I'm Cat
//
//  Created by JiaChen(: on 5/11/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpHeaderLabel()
        
    }
    
    func setUpHeaderLabel() {
        let headerAttributedString = NSMutableAttributedString(string: "Me = 😺\nYou = 😺\nEveryone = 😺",
                                                               attributes: [.font : UIFont.boldSystemFont(ofSize: 40),
                                                                            .foregroundColor : UIColor.accentColor])
        
        try! NSRegularExpression(pattern: "=", options: []).enumerateMatches(in: headerAttributedString.string,
                                                                        options: [],
                                                                        range: NSRange(location: 0,
                                                                                       length: headerAttributedString.length)) { (result, _, _) in
            
            headerAttributedString.addAttribute(.foregroundColor, value: UIColor.label, range: result!.range)
        }
        
        headerLabel.attributedText = headerAttributedString
    }


}

