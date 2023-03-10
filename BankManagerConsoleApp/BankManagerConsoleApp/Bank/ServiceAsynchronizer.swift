//
//  ServiceAsynchronizer.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/03/09.
//

import Foundation

struct ServiceAsynchronizer {
    private let queues = [BankingService: Queue<String>]()
    private var group = DispatchGroup()
    private let thread = DispatchQueue.global()
    private let semaphore: DispatchSemaphore
    
    init(queue: Queue<String>, semaphoreValue: Int = 1) {
        while !queue.isEmpty() {
            guard let customer = queue.dequeue() as? Customer else { continue }
            queues[customer.purpose!]?.enqueue(customer)
        }
        self.semaphore = DispatchSemaphore(value: semaphoreValue)
    }
    
    func work(by clerks: [BankClerkProtocol]) {
        let workItems = clerks.map(makeWorkItem)
        workItems.forEach {
            thread.async(group: group, execute: $0)
        }
    }
    
    private func makeWorkItem(by clerk: BankClerkProtocol) -> DispatchWorkItem {
        let workItem = DispatchWorkItem {
            let queue = queues[clerk.service]!
            while !queue.isEmpty() {
                semaphore.wait()
                guard let customer = queue.dequeue() as? Customer else { semaphore.signal(); return }
                semaphore.signal()
                
                NotificationCenter.default.post(name: Notification.Name("WorkStart"), object: nil, userInfo: ["고객": customer])
                clerk.serve(customer)
                NotificationCenter.default.post(name: Notification.Name("WorkFinished"), object: nil, userInfo: ["고객": customer])
            }
        }
        return workItem
    }
}
