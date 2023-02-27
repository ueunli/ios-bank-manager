//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/02/23.
//

import Foundation

struct Bank {
    private let queue: Queue<String>
    private let clerksYeahGuem: [BankClerk]
    private let clerksDaeChul: [BankClerkDaeChul]
    private var numberOfCustomers: Int = 0
    
    init() {
        self.queue = Queue<String>()
        self.clerksYeahGuem = [BankClerk(),BankClerk()]
        self.clerksDaeChul = [BankClerkDaeChul()]
    }
    
    mutating func receive(numberOfCustomers: Int) {
        self.numberOfCustomers = numberOfCustomers
    }
    
    func lineUpCustomersInQueue() {
        (1...numberOfCustomers).forEach {
            let customer = "\($0)번 고객"
            let node = Node(customer)
            queue.enqueue(node)
        }
    }
    
    private func distributeCustomersToClerk() -> Node<String>? {
        let node = queue.dequeue()
        return node
    }
    
    func handleAllCustomers() {
        let tasks = DispatchGroup()
        let task1 = DispatchWorkItem {
            guard let customer = distributeCustomersToClerk() else { return }
            clerksYeahGuem[0].serve(customer: customer)
        }
        let task2 = DispatchWorkItem {
            guard let customer = distributeCustomersToClerk() else { return }
            clerksYeahGuem[1].serve(customer: customer)
        }
        let task3 = DispatchWorkItem {
            guard let customer = distributeCustomersToClerk() else { return }
            clerksDaeChul[0].serve(customer: customer)
        }

        while !queue.isEmpty() {
            DispatchQueue.global().async(group: tasks, execute: task1)
            DispatchQueue.global().async(group: tasks, execute: task2)
            DispatchQueue.global().async(group: tasks, execute: task3)
        }
        tasks.wait()
        
        let totalTime = calculateTotalTime()
        BankManager.closingMessage(totalNumberOfCustomers: numberOfCustomers, totalTime: totalTime)
    }
    
    private func calculateTotalTime() -> Double {
        return Double(numberOfCustomers) * 0.7
    }
}
