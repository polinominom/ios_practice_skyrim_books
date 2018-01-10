//
//  SearchTableViewController.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 27/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import UIKit


class SearchTableViewController: UITableViewController, UISearchBarDelegate
{

    // MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    var filtered: [Book] = []
    
    
    
    // MARK: - Override initialize functions
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        filtered = Bookshell.sharedInstance.books
        searchBar.delegate = self
        
        updateUIMode()
        
    }
    
    func updateUIMode()
    {
        DispatchQueue.main.async
            {
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: AppTheme.sharedInstance.theme.navTitleColor]
                
                self.navigationController?.navigationBar.backgroundColor = AppTheme.sharedInstance.theme.navBackgroundColor
                self.navigationController?.navigationBar.barStyle = AppTheme.sharedInstance.theme.navBarStyle
                self.navigationController?.navigationBar.tintColor = AppTheme.sharedInstance.theme.navButtonColor
                //self.footer.backgroundColor = AppTheme.sharedInstance.theme.footerBackgroundColor
                self.view.backgroundColor = AppTheme.sharedInstance.theme.tableViewControllerBackColor
                
        }
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
        
        let b: Book = self.filtered[indexPath.row]
        
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
        
        return self.filtered.count
    }
    
 

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch(segue.identifier ?? "")
        {
        case "showBookFromSearch":
            
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
            
            let book = self.filtered[index.row]
            bookViewController.book = book
        case "showFavorites":
            Bookshell.sharedInstance.updateFavoriteIndices()
            Logger.log(message: "[Search TVC] Showing fovorited books!. %@", args: "")
        case "showRecentlyRead":
            Logger.log(message: "[Search TVC] Showing books which has been read recently.. %@", args: "")
        case "showSettings":
            Logger.log(message: "[Search TVC] Showing settings! %@", args: "")
        case "showSearch":
            Logger.log(message: "[Search TVC] Showing search.. %@", args: "")
        default:
            fatalError("Unexpected identifier: \(String(describing: segue.identifier))")
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToBookList(sender: UIStoryboardSegue)
    {
        if sender.source is BookViewController
        {
            // update
            self.tableView!.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return searchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    
 
    
    // MARK: - Search
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        // started to edit hide the footer
        // footer.isHidden = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        // finished to edit open the footer
        // footer.isHidden = false
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        // change the filtered array
        if searchText == ""
        {
            filtered = Bookshell.sharedInstance.books
        }
        else
        {
            filtered = Bookshell.sharedInstance.getBooks(with: searchBar.text!)
        }
        
        tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(false)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        searchBar.endEditing(false)
    }
    
}
