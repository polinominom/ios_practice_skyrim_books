//
//  Bookshell.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 14/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import Foundation

class Bookshell
{
    // contained books
    var books: [Book]
    var favoritedIndices: [Int]
    
    // do singleton
    static let sharedInstance = Bookshell()
    
    private init()
    {
        self.favoritedIndices = []
        self.books = []
        let allBooks = self.loadBooks()
        if allBooks != nil
        {
            self.books = allBooks!
            self.updateFavoriteIndices()
        }
    
    }
    
    
    // Tries to find all the books with named author
    func find(byAuthor: String) -> [Book]
    {
        var result:[Book] = []
        for b in self.books
        {
            if b.author == byAuthor
            {
                result.append(b)
            }
        }
        return result
    }
    
    // Tries to find the book that has the given title
    func find(byTitle: String) -> Book?
    {
        var result: Book?
        for b in self.books
        {
            if b.title == byTitle
            {
                result = b
            }
        }
        
        return result
        
    }
    
    //Tries to return found book's index
    func find(book: Book) -> Int?
    {
        return self.books.index(of: book)
    }
    
    func add(book: Book, control: Bool)
    {
        if control
        {
            if !bookExist(book: book)
            {
                self.books.append(book)
            }
        }
        else
        {
            self.books.append(book)
        }
        
    }
    
    func bookExist(book: Book) -> Bool
    {
        for b in self.books
        {
            if ((b.title == book.title) && (b.author == book.author) && (b.shortDescription == book.shortDescription))
            {
                return true
            }
        }
        
        return false
    }
    
    func updateFavoriteIndices()
    {
        self.favoritedIndices = []
        for b in books
        {
            if b.favorite
            {
                self.favoritedIndices.append(self.find(book: b)!)
            }
        }
    }
    
    func getRecentlyReadBookCount() -> Int
    {
        return RecentlyReadQueue.sharedInstance.bookIndices.count()
    }
    
    func getRecetlyReadBook(_ index: Int) -> Book
    {
        let bIndex = RecentlyReadQueue.sharedInstance.bookIndices.get(index)
        return books[bIndex]
    }
    
    func getBooks(with subsString: String) -> [Book]
    {
        var result: [Book] = []
        
        for b in books
        {
            if b.title.contains(subsString)
            {
                result.append(b)
            }
        }
        
        return result
    }
    
    // MARK: - Persistence
    func saveBooks()
    {
        let isSaveSuccessful = NSKeyedArchiver.archiveRootObject(books, toFile: Book.ArchiveURL.path)
        if isSaveSuccessful
        {
            Logger.log(message: "[BOOKSHELL] Books saved successfully %@", args:"")
        }
        else
        {
            Logger.log(message: "[BOOKSHELL] Books are not saved! %@", args:"")
        }
        
        self.updateFavoriteIndices()
        
    }
    
    func loadBooks() -> [Book]?
    {
        //return nil
        return NSKeyedUnarchiver.unarchiveObject(withFile: Book.ArchiveURL.path) as? [Book]
    }
    
    func saveRecentBooks()
    {
        let arr = RecentlyReadQueue.sharedInstance.getArray()
        UserDefaults.standard.set(arr, forKey: RecentlyReadQueue.propertyKey)
    }
}
