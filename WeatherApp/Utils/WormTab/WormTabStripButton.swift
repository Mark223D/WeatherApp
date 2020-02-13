//
//  WormTabStripButton.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/12/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation
import UIKit
class WormTabStripButton: UILabel{
    
    
    var index:Int?
    var paddingToEachSide:CGFloat = 10
    var tabText:NSString?{
        didSet{
            let textSize:CGSize = tabText!.size(withAttributes: [NSAttributedString.Key.font: font as Any])
            self.frame.size.width = textSize.width + paddingToEachSide + paddingToEachSide
            
            self.text = String(tabText!)
        }
    }
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.layer.addShadow()
        
        
    }
    convenience required init(key:String) {
        self.init(frame:CGRect.zero)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
    
}

