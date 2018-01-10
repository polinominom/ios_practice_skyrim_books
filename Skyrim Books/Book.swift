//
//  Book.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 14/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import Foundation

class Book: NSObject, NSCoding
{
    struct PropertyKey
    {
        static let title = "title"
        static let shortDescription = "short"
        static let author = "author"
        static let content = "content"
        static let chapters = "chapters"
        static let recentModifier = "recentlyReadModifier"
        static let favorite = "favorite"
    }
    
    var title: String
    var shortDescription: String?
    var author: String
    var content: [String]?
    var chapters: [BookChapter]?
    var favorite: Bool
    var recentlyReadModifier: Int
  
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("booksPath")
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(shortDescription, forKey: PropertyKey.shortDescription)
        aCoder.encode(author, forKey:PropertyKey.author)
        aCoder.encode(content, forKey: PropertyKey.content)
        aCoder.encode(chapters, forKey: PropertyKey.chapters)
        aCoder.encode(favorite, forKey: PropertyKey.favorite)
        aCoder.encode(recentlyReadModifier, forKey: PropertyKey.recentModifier)
    
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title)as? String else
        {
            Logger.log(message: "Unable to decode title for a book object %@", args: "")
            return nil
        }
        
        guard let author = aDecoder.decodeObject(forKey: PropertyKey.author) as? String else
        {
            Logger.log(message: "Unable to decode author for a book object %@", args: "")
            return nil
        }
        
        let favorite = aDecoder.decodeBool(forKey: PropertyKey.favorite)
        let recentlyReadModifier = aDecoder.decodeInteger(forKey: PropertyKey.recentModifier)
        let content = aDecoder.decodeObject(forKey: PropertyKey.content) as? [String]
        let chapters = aDecoder.decodeObject(forKey: PropertyKey.chapters) as? [BookChapter]
        let shortDescription = aDecoder.decodeObject(forKey: PropertyKey.shortDescription) as? String
        
        self.init(title: title, author: author, content: content,
                  chapters: chapters, shortDescription: shortDescription,
                  favorite: favorite, recentModifier: recentlyReadModifier)
        
    }
    
    init(title: String, author: String, content: [String]?, chapters: [BookChapter]?, shortDescription: String?, favorite: Bool, recentModifier: Int)
    {
        //super.init()
        self.title = title
        self.author = author
        self.chapters = chapters
        self.content = content
        self.shortDescription = shortDescription
        self.favorite = favorite
        self.recentlyReadModifier = recentModifier
    }
    
    
    override init()
    {
        self.author = ""
        self.title = ""
        self.recentlyReadModifier = -1
        self.favorite = false
        
    }
    
    func set(author: String)
    {
        self.author = author
    }
    
    func set(title: String)
    {
        self.title = title
    }
    
    func set(shortDescription: String)
    {
        self.shortDescription = shortDescription
    }
    
    func add(content: String)
    {
        if var bookContent = self.content
        {
            bookContent.append(content)
        }
        else
        {
            let trimmed = content.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression, range:nil)
            let newContent = trimmed.replacingOccurrences(of: "\n", with: "\n\n", options: .literal, range:nil)
            
            self.content = []
            self.content?.append(newContent)
        }
        
    }
    
    func add(chapter: BookChapter)
    {
        if self.chapters != nil
        {
            self.chapters?.append(chapter)
        }
        else
        {
            self.chapters = []
            self.chapters?.append(chapter)
        }
    }
    
}
