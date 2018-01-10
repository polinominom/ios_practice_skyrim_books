//
//  DownloadService.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 13/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import Foundation
import Kanna

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

class DownloadService
{
    var data: String
    var searchedPart: String
    var bookLinks: [String]
    var head: String
    
    var bookCount: Int
    
    var bookshell: Bookshell
    var delegate: DownloadServiceDelegate
    var failed: [Int] = []

    
    init(bookshell: Bookshell, delegate: DownloadServiceDelegate)
    {
        self.data = ""
        self.searchedPart = "<span class=\"field-content\"><a href=\""
        self.bookLinks = []
        
        self.head = "https://www.imperial-library.info"
        
        self.bookshell = bookshell
        self.bookCount = 0
        
        self.delegate = delegate
        
        
        // load the book links and book contents
        self.loadBookLinks()
        
    }
    
    func loadBooks()
    {
        self.failed = []
        self.bookCount = 0
        for i in 0...(self.bookshell.books.count-1)
        {
            self.loadBook(index: i)
        }
    }
    // Tries to load book contents
    func loadBook(index: Int)
    {
        let bookLink = self.bookLinks[index]
        let url = URL(string: bookLink)
        var request = URLRequest(url:url!)
        request.timeoutInterval = 200
        
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            
            guard data != nil else
            {
                Logger.log(message: "Error! the raw data is corrupted book index: response: error:%@", args: "\(String(describing: error))")
                self.failed.append(index)
                return
            }
            
            guard let transformedData = String(data: data!, encoding: String.Encoding.utf8) else
            {
                Logger.log(message: "Error! at the transforming the data when loading a book:%@", args: "\(index)")
                self.failed.append(index)
                return
            }
            
            guard error == nil else
            {
                Logger.log(message: "Error is not nil when downloading book contents! error:%@", args:"\(String(describing: error))")
                self.failed.append(index)
                return
                
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            guard statusCode == 200 else
            {
                Logger.log(message: "Status Code Failed:%@", args: "\(statusCode)")
                self.failed.append(index)
                return
        
            }
            
            //message the delegate
            self.delegate.startedContentDownload(index: index)
            
            self.bookCount += 1
            
            var chapterBooks: [BookChapter] = []
            if let doc = HTML(html: transformedData, encoding: String.Encoding.utf8)
            {
                
                var chaptered: Bool = false
                //GET CHAPTERED BOOK TITLES
                for link in doc.xpath("//span[contains(@class, 'field-content')]")
                {
                    if let chapterTitle = link.text
                    {
                        let trimmedTitle = chapterTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                        chaptered = true
                        
                        var bookChapter = BookChapter()
                        bookChapter.set(title: trimmedTitle)
                        chapterBooks.append(bookChapter)
                        
                    }
                    else
                    {
                        Logger.log(message: "ERROR OCCURED WHILE DOWNLOADING CHAPTERED BOOKS!%@", args: "\(index)")
                    }
                    
                }
                
                // GET BOOK CHAPTER CONTENTS
                if chaptered
                {
                    // parse the chaptered content and assign it the objects
                    self.delegate.startedChapteredContentDownload(index: index, chapterCount: chapterBooks.count)
                    
                    var chapterCount: Int = 0
                    for link in doc.xpath("//div[contains(@class, 'field-content')]")
                    {
                        if let text = link.text
                        {
                            var b: BookChapter = chapterBooks[chapterCount]
                            b.set(content: text)
                            self.bookshell.books[index].add(chapter: b)
                            chapterCount += 1
                        }
                    }
                    
                    self.delegate.didFinishedChapterContentDownload(index: index)
                
                }
                else
                {
                    // message the delegate
                    self.delegate.startedUnchapteredContentDownload(index: index)
                    
                    /* -_- */
                    
                    // parse the un-chaptered content
                    // unchaptered example "view-source:https://www.imperial-library.info/content/runils-journal"
                    // <div class='node-content clear-block prose'>
                    // field field-type-text field-field-comment
                    // <div class="field-item odd">
                    var ignoreStr: [String] = []
                    
                    //get the ignored strings
    
                    for link in doc.xpath("//div[contains(@class, 'field-item odd')]")
                    {
                        if let text = link.text
                        {
                            ignoreStr.append(text)
                
                        }
                    }
                    
                    var isSecond: Bool = false
                    for link in doc.xpath("//div[contains(@class, 'node-content clear-block prose')]")
                    {
                        if !isSecond
                        {
                            isSecond = true
                            continue
                        }
                        
                        if var text = link.text
                        {
                            //remove the ignored textxs 
                            for _str in ignoreStr
                            {
                                text = text.replacingOccurrences(of: _str, with: "")
                            }
                            
                            let trimText = text.trimmingCharacters(in: .whitespaces)
                            self.bookshell.books[index].add(content: trimText)
                        }
                    }
                    
                    self.delegate.didFinishedUnchapteredContentDownload(index: index)
                }
            }
            
            self.delegate.oneDownloadFinished(index: index)
            if self.bookCount == self.bookshell.books.count
            {
                //all books downloaded persist the data.
                self.bookshell.saveBooks()
                self.delegate.downloadsDidFinished()
            }
        }
        
        task.resume()
        
    }
    
    func loadBookLinks()
    {
        let url = URL(string:"https://www.imperial-library.info/books/skyrim/by-title")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            // Transform and encode the data
            guard let transformedData = String(data: data!, encoding: String.Encoding.utf8) else
            {
                // if could't, log the error and finish this tast.
                Logger.log(message: "something wrong at parsing html to string:%@", args: "\(String(describing: error))")
                return
            }
            
            guard error == nil else
            {
                Logger.log(message: "Error is not nil when loading book links:%@", args:"\(String(describing: error))")
                return
            }

            // Get the document as html
            if let doc = HTML(html: transformedData, encoding: String.Encoding.utf8)
            {
                var isTitleReached: Bool = false
                var finished: Bool = false
                
                self.delegate.startedTitleDownload(index: 0)
                // Find the titles, authors and short descriptions
                for link in doc.xpath("//li[contains(@class, 'views-row')]")
                {
                    if let text = link.text
                    {
                        var book = Book()
                        book.favorite = false
                        book.recentlyReadModifier = -1
                        
                        // GET TITLES
                        for titleLink in link.xpath("span[contains(@class, 'views-field views-field-title')]")
                        {
                            if let title = titleLink.text
                            {
                                let title = title.trimmingCharacters(in: .whitespaces)
                                book.set(title: title)
                                
                            }
                        }
                        
                        // GET AUTHORS
                        for authorLink in link.xpath("span[contains(@class, 'views-field views-field-field-author-value')]")
                        {
                            if let text = authorLink.text
                            {
                                let author = text.trimmingCharacters(in: .whitespaces)
                                book.set(author: author)
                            }
                        }
                        
                        for sdLink in link.xpath("div[contains(@class, 'views-field views-field-field-summary-value')]")
                        {
                            if let text = sdLink.text
                            {
                                let shortDescription = text.trimmingCharacters(in: .whitespaces)
                                book.set(shortDescription: shortDescription)
                            }
                        }
                        
                        // add the book into the bookshell
                        self.bookshell.add(book: book, control: false)
                        
                    }
                }
                
                //GET THE BOOK LINKS
                for link in doc.xpath("//a | //link") {
                    if let text = link.text
                    {
                        // Find "by title" text, and after that start to get book links.
                        // Finish when a "http" substirng occurs
                        if text == "By title"
                        {
                            isTitleReached = true
                            continue
                        }
                        
                        if isTitleReached
                        {
                            if let extraLink = link["href"]
                            {
                                if extraLink.lowercased().range(of: "http") == nil
                                {
                                    self.bookLinks.append(self.head + extraLink)
                                }
                                else
                                {
                                    finished = true
                                }
                                
                            }
                            
                            if finished
                            {
                                // load the book contents
                                self.loadBooks()
                                break
                            }
                            
                        }
                        
                    }
                    
                }
            
            }
        }
        task.resume()
        
    }
    
}
