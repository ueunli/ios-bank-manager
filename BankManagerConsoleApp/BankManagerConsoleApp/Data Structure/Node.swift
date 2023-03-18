//
//  Node.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/02/21.
//

import Foundation

class Node<Element: Comparable>: Equatable {
    private(set) var data: Element
    private(set) var next: Node?
    var nextNode: Node? {
        get {
            return next
        }
        set(newNode) {
            next = newNode
        }
    }
    
    init(_ data: Element) {
        self.data = data
    }
    
    static func == (lhs: Node<Element>, rhs: Node<Element>) -> Bool {
        return lhs.data == rhs.data
    }
}
