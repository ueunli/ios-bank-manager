//
//  ServiceAsynchronizer.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/03/05.
//

import Foundation

struct ServiceAsynchronizer {
    private let queue: Queue<String>
    private var group = DispatchGroup()
    private let thread = DispatchQueue.global()
    private let semaphore = DispatchSemaphore(value: 1)
    
    func makeWorkGroup(by clerks: [BankClerkProtocol]) -> DispatchGroup {
        let workItems = clerks.map(makeWorkItem)
        workItems.forEach {
            thread.async(group: group, execute: $0)
        }

        return group
    }
    
    private func makeWorkItem(by clerk: BankClerkProtocol) -> DispatchWorkItem {
        let workItem = DispatchWorkItem {
            while !queue.isEmpty() {
                guard (queue.peekFirst() as? Customer)?.purposeOfVisit == clerk.service else { continue }
                
                semaphore.wait()
                guard let customer = extractCustomerfromQueue() else { semaphore.signal(); return }
                semaphore.signal()
                
                clerk.serve(customer)
            }
        }
        return workItem
    }
    
    private func extractCustomerfromQueue() -> Customer? {
        let customer = queue.dequeue() as? Customer
        return customer
    }
    
    init(queue: Queue<String>) {
        self.queue = queue
    }
}
