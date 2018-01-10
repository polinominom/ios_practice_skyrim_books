//
//  RecentBookshellTableViewController.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 22/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import UIKit

class RecentBookshellTableViewController: UITableViewController {

    
    
    @IBOutlet weak var footer: BookshellFooterView!
    
    var bookshell: Bookshell = Bookshell.sharedInstance
    var rrbQueue: RecentlyReadQueue = RecentlyReadQueue.sharedInstance
    
    // MARK: - Override initialize functions
    override func viewDidAppear(_ animated: Bool)
    {
        //footer.set(table: self)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateUIMode()
    }
    
    func updateUIMode()
    {
       // DispatchQueue.main.async
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
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "BookViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BookshellTableViewCell else
        {
            fatalError("The dequeued cell is not instanced of BookshellTableViewCell")
        }
        
        let b = self.bookshell.getRecetlyReadBook(indexPath.row)
        cell.title.text = b.title
        cell.textView.text = b.shortDescription
        cell.authorLabel.text = "Author: \(b.author)"
        
        cell.backgroundColor = AppTheme.sharedInstance.theme.cellBackgroundColor
        cell.textView.backgroundColor = AppTheme.sharedInstance.theme.cellDescriptionBackColor
        cell.title.textColor = AppTheme.sharedInstance.theme.cellTextColor

        return cell
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.bookshell.getRecentlyReadBookCount()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch(segue.identifier ?? "")
        {
        case "showBookFromRecentlyRead":
            
            guard let bookViewController = segue.destination as? BookViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
                
            }
            
            guard let selectedBook = sender as? BookshellTableViewCell else
            {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let index = tableView.indexPath(for: selectedBook) else
            {
                fatalError("Selected cell is not destroyed in the table list")
            }
            
            let idx = rrbQueue.bookIndices.get(index.row)
            let book = bookshell.books[idx]
            bookViewController.book = book
        case "showAllBooks":
            Logger.log(message: "[Recently TVC] Showing all books!. %@", args: "")
        case "showFavorites":
            Logger.log(message: "[Recently TVC] Showing books which has been favorited! %@", args: "")
        case "showSettings":
            Logger.log(message: "[Recently TVC] Showing settings! %@", args: "")
        case "showSearch":
            Logger.log(message: "[Recently TVC] searhing books %@", args: "")
        default:
            fatalError("Unexpected identifier: \(String(describing: segue.identifier))")
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Navigation
    @IBAction func unwindToBookList(sender: UIStoryboardSegue)
    {
        if sender.source is BookViewController
        {
            // update
            self.tableView!.reloadData()
        }
        if sender.source is SettingsViewController
        {
            self.tableView!.reloadData()
            
            updateUIMode()
        }
    }

}
