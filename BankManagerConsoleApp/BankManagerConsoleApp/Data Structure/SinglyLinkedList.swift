//
//  SinglyLinkedList.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/02/21.
//

import Foundation

final class SinglyLinkedList<Element: Comparable> {
    var head: Node<Element>?
    var tail: Node<Element>?
    private(set) var nodeCount: Int = 0
    
    init(_ node: Node<Element>? = nil) {
        self.head = node
        self.tail = node
    }
    
    func isEmpty() -> Bool {
        return nodeCount == 0 ? true : false
    }
    
    func append(_ node: Node<Element>) {
        if isEmpty() {
            head = node
        } else {
            tail?.nextNode = node
        }
        tail = node
        nodeCount += 1
    }
    
    func removeFirstNode() -> Node<Element>? {
        guard !isEmpty() else { return nil }
        let firstNode = head
        head = head?.nextNode
        nodeCount -= 1
        return firstNode
    }
    
    func removeAll() {
        head = nil
        tail = nil
        nodeCount = 0
    }
    
    func findNode(_ data: Element) -> Node<Element>? {
        var node = head
        while node?.next != nil {
            if node?.data == data { break }
            node = node?.next
        }
        return node
    }
}
