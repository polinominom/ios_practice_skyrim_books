//
//  SettingsViewController.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 27/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{

    @IBOutlet weak var nightModeLabel: UILabel!
    
    @IBOutlet weak var onButton: UIButton!
    
    @IBOutlet weak var offButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nightModeOn(_ sender: UIButton)
    {
        AppTheme.sharedInstance.saveMode(mode: true)
        updateUI()
    }

    @IBAction func nightModeOff(_ sender: UIButton)
    {
        AppTheme.sharedInstance.saveMode(mode: false)
        updateUI()
        
    }
    
    func updateUI()
    {
        //DispatchQueue.main.async()
        //{
            self.onButton.isUserInteractionEnabled = !AppTheme.sharedInstance.nightMode
            self.offButton.isUserInteractionEnabled = AppTheme.sharedInstance.nightMode
            
            let disableColor = UIColor.lightGray
            let activeColor = UIButton().tintColor!
            
            if AppTheme.sharedInstance.nightMode
            {
                self.offButton.tintColor = activeColor
                self.onButton.tintColor = disableColor
            }
            else
            {
                self.offButton.tintColor = disableColor
                self.onButton.tintColor = activeColor
            }
            
            
        
            self.view.backgroundColor = AppTheme.sharedInstance.theme.contentBackgroundColor
            self.nightModeLabel.textColor = AppTheme.sharedInstance.theme.navTitleColor
        
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: AppTheme.sharedInstance.theme.navTitleColor]
        
            self.navigationController?.navigationBar.backgroundColor = AppTheme.sharedInstance.theme.navBackgroundColor
            self.navigationController?.navigationBar.barStyle = AppTheme.sharedInstance.theme.navBarStyle
            self.navigationController?.navigationBar.tintColor = AppTheme.sharedInstance.theme.navButtonColor
        //}
        
    }
    
}
