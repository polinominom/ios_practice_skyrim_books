//
//  AppTheme.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 02/08/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import Foundation
import UIKit

class AppTheme
{
    struct NightTheme
    {
        var cellBackgroundColor: UIColor = UIColor(colorLiteralRed: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        var cellTextColor: UIColor = UIColor.white
        var cellDescriptionBackColor: UIColor = UIColor(colorLiteralRed: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        var navBarStyle: UIBarStyle = UIBarStyle.blackTranslucent
        var navTitleColor: UIColor = UIColor.white
        var navButtonColor: UIColor = UIColor.white
        
        var navBackgroundColor: UIColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        var footerBackgroundColor: UIColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        var contentBackgroundColor: UIColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        var tableViewControllerBackColor: UIColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
    }
    
    struct Theme
    {
        var cellBackgroundColor: UIColor = UIColor.white
        var cellTextColor: UIColor = UIColor.black
        var cellDescriptionBackColor: UIColor = UIColor.white
        
        var navBarStyle: UIBarStyle = UIBarStyle.default
        var navTitleColor: UIColor = UIColor.black
        var navButtonColor: UIColor = UIView().tintColor
        
        var navBackgroundColor: UIColor = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        var footerBackgroundColor: UIColor = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        var contentBackgroundColor: UIColor = UIColor.white
        
        var tableViewControllerBackColor: UIColor = UIColor.white

    }
    static let propertyKey: String = "nightMode"
    static let sharedInstance: AppTheme = AppTheme()
    var nightMode: Bool
    var theme: Theme
    
    private init()
    {
        nightMode = UserDefaults.standard.bool(forKey: AppTheme.propertyKey)
        theme = Theme()
        updateTheme(mode: self.nightMode)
    }
    
    func saveMode(mode: Bool)
    {
        nightMode = mode
        UserDefaults.standard.set(nightMode, forKey: AppTheme.propertyKey)
        self.updateTheme(mode: nightMode)
        
    }
    
    func updateTheme(mode: Bool)
    {
        theme = Theme()
        if mode
        {
            let nm = NightTheme()
            theme.cellBackgroundColor = nm.cellBackgroundColor
            theme.cellTextColor = nm.cellTextColor
            theme.cellDescriptionBackColor = nm.cellDescriptionBackColor
            theme.navBarStyle = nm.navBarStyle
            theme.navTitleColor = nm.navTitleColor
            theme.navButtonColor = nm.navButtonColor
            theme.navBackgroundColor = nm.navBackgroundColor
            theme.footerBackgroundColor = nm.footerBackgroundColor
            theme.contentBackgroundColor = nm.contentBackgroundColor
            theme.tableViewControllerBackColor = nm.tableViewControllerBackColor
        }
    }
    
}
