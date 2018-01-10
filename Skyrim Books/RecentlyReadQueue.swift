//
//  RecentlyReadQueue.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 26/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import Foundation

class Node
{
    var next: Node?
    var previous: Node?
    
    var value: Int
    init(value: Int)
    {
        self.value = value
    }
    
}



class LinkedList
{
    fileprivate var head: Node?
    fileprivate var tail: Node?
    
    var isEmpty: Bool
    {
        return head == nil
    }
    
    var first: Node?
    {
        return head
    }
    
    var last: Node?
    {
        return tail
    }
    
    func append(value: Int)
    {
        let newNode = Node(value: value)
        
        if let headNode = head
        {
            //!! -- TODO: check if the new node should be added to the beginning of the list -- !!
            newNode.next = headNode
            headNode.previous = newNode
        }
        else
        {
            tail = newNode
        }
        
        head = newNode
    }
    
    func nodeAt(index: Int) -> Node?
    {
        if index >= 0
        {
            var node = head
            var i: Int = index
            while node != nil
            {
                if i == 0
                {
                    return node
                }
                
                i -= 1
                node = node!.next
            }
        }
        
        return nil
    }
    
    func removeAll()
    {
        head = nil
        tail = nil
    }
    
    func remove(node: Node)
    {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev
        {
            prev.next = next
        }
        else
        {
            // if there is no previous node its the head node
            head = next
        }
        
        next?.previous = prev
        
        if next == nil
        {
            // absence of next only occur in tail node.
            tail = prev
        }
        
        node.previous = nil
        node.next = nil
    }
    

    
    
}

extension LinkedList: CustomStringConvertible {
    // 2
    public var description: String {
        // 3
        var text = "["
        var node = head
        // 4
        while node != nil {
            text += "\(node!.value)"
            node = node!.next
            if node != nil { text += ", " }
        }
        // 5
        return text + "]"
    }
}


class RecentlyReadQueue
{

    struct Queue
    {
        fileprivate var list = LinkedList()
        var isEmpty: Bool
        {
            return list.isEmpty
        }
        
        mutating func enqueue(_ element: Int)
        {
            list.append(value: element)
        }
        
        mutating func dequeue() -> Int?
        {
            guard !list.isEmpty, let element = list.first else { return nil }
            
            list.remove(node: element)
            
            return element.value
        }
        
        func peek() -> Int?
        {
            return list.first?.value
        }
        
        func find(searchedVal: Int) -> Node?
        {
            if searchedVal >= 0
            {
                var node = list.head
                while node != nil
                {
                    if node?.value == searchedVal
                    {
                        return node
                    }
                    
                    node = node!.next
                }
                
            }
            
            return nil
        }
        
        func count() -> Int
        {
            var counter: Int = 0
            var node = list.head
            while node != nil
            {
                counter += 1
                node = node!.next
            }
            
            return counter
        }
        
        func get(_ i: Int) -> Int
        {
            if let result = list.nodeAt(index: i)
            {
                return result.value
            }
            
            return 0
        }
    }
    
    static let propertyKey: String = "RecentlyReadQueue"
    static let sharedInstance = RecentlyReadQueue()
    var bookIndices: Queue
    private init()
    {
        bookIndices = Queue()
        
        if let arr = UserDefaults.standard.array(forKey: RecentlyReadQueue.propertyKey) as? [Int]
        {
            Logger.log(message: "[RecentQueue] recently reads initialized %@", args:"")
            self.initializeQueue(with: arr)
        }
        else
        {
            Logger.log(message: "NO BOOKS HAS BEEN READ RECENTLY %@", args:"")
        }
        
    }
    
    func update(bookIndex: Int)
    {
        //check if the index exist in the queue
        if let existingNode = bookIndices.find(searchedVal: bookIndex)
        {
            // node already exist
            bookIndices.list.remove(node: existingNode)
        }
        
        bookIndices.enqueue(bookIndex)
    }
    
    func getArray() -> [Int]
    {
        var arr: [Int] = []
        var node = bookIndices.list.tail
        while node != nil
        {
            arr.append(node!.value)
            node = node!.previous
        }
        return arr
    }
    
    private func initializeQueue(with arr: [Int])
    {
        for i in arr
        {
            self.bookIndices.enqueue(i)
        }
    }
}

extension RecentlyReadQueue.Queue: CustomStringConvertible
{
    public var description: String
    {
        return list.description
    }
}
