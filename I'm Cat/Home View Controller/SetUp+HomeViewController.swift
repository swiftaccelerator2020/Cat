//
//  SetUp+HomeViewController.swift
//  I'm Cat
//
//  Created by JiaChen(: on 6/11/20.
//

import Foundation
import UIKit

extension HomeViewController {
    func setUp() {
        setUpHeaderLabel()
        setUpNextButton()
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

    func setUpNextButton() {
        nextButton.layer.cornerRadius = 49 / 2
    }
}
