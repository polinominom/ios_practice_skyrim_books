//
//  BookChapter.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 14/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import Foundation


class BookChapter: NSObject, NSCoding
{
    struct PropertyKey
    {
        static let title = "title"
        static let content = "content"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("bookChapters")

    var title: String
    var content: String
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(content, forKey: PropertyKey.content)
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title)as? String else
        {
            Logger.log(message: "[BookChapter] Unable to decode title for a book object %@", args: "")
            return nil
        }
        
        guard let content = aDecoder.decodeObject(forKey: PropertyKey.content) as? String else
        {
            Logger.log(message: "[BookChapter] Unable to decode author for a book object %@", args: "")
            return nil
        }
        
        self.init(title: title, content: content)
        
    }
    
    init(title: String, content: String)
    {
        self.title = title
        self.content = content
    }
    
    override init()
    {
        self.title = ""
        self.content = ""
    }
    
    func set(title: String)
    {
        self.title = title
    }
    
    func set(content: String)
    {
        let trimmed = content.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression, range:nil)
        let newContent = trimmed.replacingOccurrences(of: "\n", with: "\n\n", options: .literal, range:nil)
        
        self.content = newContent
    }
}
