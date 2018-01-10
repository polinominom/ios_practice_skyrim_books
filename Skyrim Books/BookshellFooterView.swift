//
//  BookshellFooterView.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 22/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import UIKit

class BookshellFooterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - properties
    
    override init(frame: CGRect)
    {
        print("init footer with a normal initializer")
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        print("init footer with a coder")
        super.init(coder: aDecoder)
    }
    
    func set(navigationController: UINavigationController)
    {
        print("navigation controller has been assigned!")
    }
    
}
