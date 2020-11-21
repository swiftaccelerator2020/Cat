//
//  Degrees+CGAffineTransform.swift
//  I'm Cat
//
//  Created by JiaChen(: on 21/11/20.
//

import Foundation
import UIKit

extension CGAffineTransform {
    
    /// CGAffineTransform but it's degrees
    ///
    /// Sorry Ms Tan. I've let you down. I forgot my math so, here's a helper function
    /// to fix that. My A Math is terrible.
    ///
    /// - Parameter degrees: The rotation angle in **degrees**
    ///
    init(degrees: CGFloat) {
        
        let radians = degrees * (.pi / 180)
        
        self.init(rotationAngle: radians)
    }
}
