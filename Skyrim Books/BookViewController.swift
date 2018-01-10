//
//  BookViewController.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 23/07/2017.
//  Copyright © 2017 Çağrı Yıldı<z. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    var book: Book?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    
    func initChaptered(allChapters: [BookChapter])
    {
        self.content.text = ""
        var index: Int = 0
        for chapter in allChapters
        {
            //create a title label
            index += 1

            let chapterTitle = "\(chapter.title) (Chapter \(index))"
            let newContent = "\(chapterTitle)\n\n\n\(chapter.content)\n"
            
            self.content.insertText(newContent)
        }
    }
    
    func initUnchaptered(allContent: [String])
    {
        self.content.text = ""
        for c in allContent
        {
            self.content.insertText(c)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if book != nil
        {
            titleLabel.text = book?.title
            if let allContent = book?.content
            {
                self.initUnchaptered(allContent: allContent)
                
            }
            else if let allChapters = book?.chapters
            {
                self .initChaptered(allChapters: allChapters)
            }
            else
            {
                Logger.log(message: "[Book VC] something impossible happened: BOOK IS EMPTY %@", args: "")
            }
            
            self.content.setNeedsLayout()
            self.content.setNeedsDisplay()
            self.content.isScrollEnabled = true
        }
        
        // Do any additional setup after loading the view.
        self.updateButtonColor()
        
        //update the recently read
        let idx = Bookshell.sharedInstance.find(book: book!)
        RecentlyReadQueue.sharedInstance.update(bookIndex: idx!)
        
        // persist the data
        Bookshell.sharedInstance.saveRecentBooks()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: AppTheme.sharedInstance.theme.navTitleColor]
        
        self.navigationController?.navigationBar.backgroundColor = AppTheme.sharedInstance.theme.navBackgroundColor
        self.navigationController?.navigationBar.barStyle = AppTheme.sharedInstance.theme.navBarStyle
        //self.navigationController?.navigationBar.tintColor = AppTheme.sharedInstance.theme.navButtonColor

        self.titleLabel.textColor = AppTheme.sharedInstance.theme.navTitleColor
        self.content.backgroundColor = AppTheme.sharedInstance.theme.contentBackgroundColor
        self.content.textColor = AppTheme.sharedInstance.theme.navTitleColor
        self.view.backgroundColor = AppTheme.sharedInstance.theme.contentBackgroundColor
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.content.setContentOffset(CGPoint.zero, animated: false)
    }
    
    // MARK: - Actions
    @IBAction func onClick(_ sender: UIBarButtonItem)
    {
        guard self.book != nil else
        {
            fatalError("ERROR! BOOK IS NIL IN A BOOK VIEW! ")
        }
        
        DispatchQueue.main.async
        {
            self.book!.favorite = !(self.book!.favorite)
            self.updateButtonColor()
            Bookshell.sharedInstance.saveBooks()
        }
    }
    
    func updateButtonColor()
    {
        if self.book!.favorite
        {
            // change the button color to gray, not favorite anymore
            let color = UIColor.init(colorLiteralRed: 0.0, green: Float(122.0/255.0), blue: 1.0, alpha: 1.0)
            favoriteButton.tintColor = color
        }
        else
        {
            // change the button color to blue, it is favorite
            favoriteButton.tintColor = UIColor.gray
        }
    }


}
