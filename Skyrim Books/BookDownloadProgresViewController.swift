//
//  BookDownloadProgresViewController.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 16/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import UIKit

class BookDownloadProgresViewController: UIViewController {
    
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var downloadedBookLabel: UILabel!
    
    var table: BookshellTableViewController?
    
    var dismissed: Bool = false
    
    
    // initializations
    
    init(table: BookshellTableViewController)
    {
        self.table = table
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        if let t = self.table
        {
            progress.progress = 0
            progress.setNeedsLayout()
            t.downloadingSceneLoaded()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Adjusting view
    func updateProgress(downloadedBooks: Int, maxBookCount: Int)
    {
        if self.dismissed
        {
            return
        }
        
        DispatchQueue.main.async()
        {
                self.downloadedBookLabel.text = "(\(downloadedBooks)/\(maxBookCount) downloaded.)"
                self.downloadedBookLabel.setNeedsDisplay()
                self.progress.setProgress(Float(downloadedBooks)/Float(maxBookCount), animated: true)
                if downloadedBooks == maxBookCount
                {
                    self.dismissed = true
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }
    
    
    
    // MARK: - Navigation
    

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
