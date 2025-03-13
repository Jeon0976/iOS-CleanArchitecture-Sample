//
//  DoublyLinkedList.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

final class DoublyLinkedList<T> {
    private var head: Node<T>?
    private var tail: Node<T>?
    
    var count: Int = 0
    
    var isEmpty: Bool { head == nil }
    var first: Node<T>? { head }
    
    func node(at index: Int) -> Node<T>? {
        let center = count / 2
        
        if index <= center {
            var currentIndex = 0
            var currentNode = head
            
            while currentNode != nil && currentIndex < index {
                currentNode = currentNode!.next
                currentIndex += 1
            }
            
            return currentNode
        } else {
            var currentIndex = count - 1
            var currentNode = tail
            
            while currentNode != nil && currentIndex > index {
                currentNode = currentNode!.prev
                currentIndex -= 1
            }
            
            return currentNode
        }
    }
    
    @discardableResult
    func push(value: T) -> Node<T> {
        let newNode = Node(value: value)
        
        count += 1
        
        guard tail != nil else {
            head = newNode
            tail = newNode
            
            return newNode
        }
        
        newNode.next = head
        head?.prev = newNode
        head = newNode
        
        return newNode
    }
    
    @discardableResult
    func append(value: T) -> Node<T> {
        let newNode = Node(value: value)
        
        guard let tailNode = tail else {
            push(value: value)
            return newNode
        }
        
        count += 1
        
        newNode.prev = tailNode
        tailNode.next = newNode
        tail = newNode
        
        return newNode
    }
    
    @discardableResult
    func removeLast() -> Node<T>? {
        guard !isEmpty else { return nil }

        let prevNode = tail?.prev
        
        defer {
            prevNode?.next = nil
            tail?.prev = nil
            tail = prevNode
            
            count -= 1
        }
        
        return tail
    }
    
    func moveToHead(node: Node<T>) {
        guard !isEmpty else { return }
        
        guard node !== head else { return }
        
        if tail === node {
            tail = node.prev
            tail?.next = nil
        } else {
            node.prev?.next = node.next
            node.next?.prev = node.prev
        }
        
        node.next = head
        node.prev = nil
        head?.prev = node
        head = node
    }
}
