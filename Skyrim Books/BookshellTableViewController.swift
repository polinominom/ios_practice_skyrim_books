//
//  BookshellTableViewController.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 15/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import UIKit

extension UIView {
    func fadeIn(completion: ((Bool)->Void)?) {
        // Move our fade out code from earlier
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: completion)
    }
    
    func fadeOut(completion: ((Bool)->Void)?) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: completion)
        
        
    }
}

class BookshellTableViewController: UITableViewController, DownloadServiceDelegate
{
    
    // MARK: - Properties
    
    @IBOutlet weak var footer: BookshellFooterView!
    
    var isAlreadyStarted: Bool = false
    var booksAreLoaded: Bool = false
    
    var bookshell = Bookshell.sharedInstance
    var rrbQueue: RecentlyReadQueue = RecentlyReadQueue.sharedInstance
    
    var ds: DownloadService?
    
    var bookDownloadProgressViewContoller: BookDownloadProgresViewController?
    
    var downloadedBookCount: Int = 0
    var isDownloadProgresLoaded: Bool = false

    // MARK: - Override initialize functions
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // init the footer's table view
        if !booksAreLoaded
        {
            if self.bookshell.books != []
            {
                Logger.log(message: "[Bookshell Table View] View did appear, Books are already loaded! %@", args: "")
                booksAreLoaded = true
            }
            else
            {
                Logger.log(message: "[Bookshell Table View] No files saved! Started to download files! %@", args: "")
                self.showAlert()
                
                ds = DownloadService(bookshell: bookshell, delegate: self)
            }
            
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if self.bookshell.books != []
        {
            booksAreLoaded = true
        }
        updateUIMode()
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //UserDefaults.standard.set(10, forKey: "MoneyKey");
    }
    
    func updateUIMode()
    {
        //DispatchQueue.main.async
        //{
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: AppTheme.sharedInstance.theme.navTitleColor]
            
            self.navigationController?.navigationBar.backgroundColor = AppTheme.sharedInstance.theme.navBackgroundColor
            self.navigationController?.navigationBar.barStyle = AppTheme.sharedInstance.theme.navBarStyle
            self.navigationController?.navigationBar.tintColor = AppTheme.sharedInstance.theme.navButtonColor
            self.footer.backgroundColor = AppTheme.sharedInstance.theme.footerBackgroundColor
            self.view.backgroundColor = AppTheme.sharedInstance.theme.tableViewControllerBackColor
            
        //}
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "BookViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BookshellTableViewCell else
        {
            fatalError("The dequeued cell is not instanced of BookshellTableViewCell")
        }
        
        let b = self.bookshell.books[indexPath.row]

        
        

        cell.title.text = b.title
        
        
        cell.textView.text = b.shortDescription
        if b.chapters != nil
        {
            cell.textView.insertText("\n\(b.title) (\(b.chapters!.count) Chapters.) ") 
        }
        cell.authorLabel.text = "Author: \(b.author)"
        
        cell.backgroundColor = AppTheme.sharedInstance.theme.cellBackgroundColor
        cell.textView.backgroundColor = AppTheme.sharedInstance.theme.cellDescriptionBackColor
        cell.title.textColor = AppTheme.sharedInstance.theme.cellTextColor
    
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.bookshell.books.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        
        footer.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50)
        return footer
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 50.0
    }
    
    // MARK: - madeup functions

    
    func downloadingSceneLoaded()
    {
        self.isDownloadProgresLoaded = true
    }
    
    func downloadsDidFinished()
    {
        Logger.log(message: "[Bookshell table view] Downloads is finished! %@", args: "")
        
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
        
    }
    
    func oneDownloadFinished(index: Int)
    {
        Logger.log(message: "[Bookshell Table View] Book content download finished, index: %@", args: "\(index)")
        downloadedBookCount += 1
        if isDownloadProgresLoaded
        {
            if (self.bookDownloadProgressViewContoller?.progress) != nil
            {
                if (self.bookDownloadProgressViewContoller?.dismissed)!
                {
                    return
                }
                let total = self.bookshell.books.count
                self.bookDownloadProgressViewContoller!.updateProgress(
                    downloadedBooks: downloadedBookCount,
                    maxBookCount: total)   
            }
        }
    }
    
    func startedContentDownload(index: Int)
    {
        Logger.log(message: "[Bookshell Table View] Book has just started to download!: %@", args: "\(index)")
    }
    
    func startedTitleDownload(index: Int)
    {
        Logger.log(message: "[Bookshell Table View] Started to download books' title: %@", args: "")
    }
    
    func startedChapteredContentDownload(index: Int, chapterCount: Int)
    {
        Logger.log(message: "[Bookshell Table View] Started To Download Chapters of INDEX: %@", args: "\(index) cc: \(chapterCount)")
    }
    
    func didFinishedChapterContentDownload(index: Int)
    {
        Logger.log(message: "%@", args: "[Bookshell Table View] Finished To Download Chapters of INDEX: \(index)")
    }
    
    func startedUnchapteredContentDownload(index: Int)
    {
        Logger.log(message: "%@", args: "[Bookshell Table View] Started to download unchaptered content of INDEX: \(index)")
    }
    
    func didFinishedUnchapteredContentDownload(index: Int)
    {
        Logger.log(message: "%@", args: "[Bookshell Table View] Finished to download unchaptered content of INDEX: \(index)")
    }
    
    func showAlert()
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
        bookDownloadProgressViewContoller = viewController.instantiateViewController(withIdentifier: "DownloadProgress") as? BookDownloadProgresViewController
        
        bookDownloadProgressViewContoller?.table = self
        present(bookDownloadProgressViewContoller!, animated:true, completion:nil)
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch(segue.identifier ?? "")
        {
            case "showBookFromAllBooks":
                
                guard let bookViewController = segue.destination as? BookViewController else
                {
                    fatalError("Unexpected destination: \(segue.destination)")
                    
                }
            
                guard let selectedBook = sender as? BookshellTableViewCell else
                {
                    fatalError("Unexpected sender: \(sender ?? "")")
                }
            
                guard let index = tableView.indexPath(for: selectedBook) else
                {
                    fatalError("Selected cell is not destroyed in the table list")
                }
            
                let book = bookshell.books[index.row]
                bookViewController.book = book
            case "showFavorites":
                bookshell.updateFavoriteIndices()
                Logger.log(message: "[Bookshell Table View] Showing fovorited books!. %@", args: "")
            case "showRecentlyRead":
                Logger.log(message: "[Bookshell Table View] Showing books which has been read recently. %@", args: "")
            case "showSettings":
                Logger.log(message: "[Bookshell Table View] Showing settings! %@", args: "")
            case "showSearch":
                Logger.log(message: "[Bookshell Table View] Showing search! %@", args: "")
            default:
                fatalError("Unexpected identifier: \(segue.identifier ?? "unknown identifier")")
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToBookList(sender: UIStoryboardSegue)
    {
        if sender.source is BookViewController
        {
            self.tableView!.reloadData()
            
        }
        if sender.source is SettingsViewController
        {
            self.tableView!.reloadData()
            updateUIMode()
        }
    }


}
