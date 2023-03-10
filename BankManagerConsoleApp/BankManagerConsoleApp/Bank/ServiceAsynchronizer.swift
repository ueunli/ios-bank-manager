//
//  ServiceAsynchronizer.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/03/09.
//

import Foundation

struct ServiceAsynchronizer {
    private let queue: Queue<String>
    private var group = DispatchGroup()
    private let thread = DispatchQueue.global()
    private let semaphore: DispatchSemaphore
    
    init(queue: Queue<String>, semaphoreValue: Int = 1) {
        self.queue = queue
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
            while !queue.isEmpty() {
                guard (queue.peekFirst() as? Customer)?.purpose == clerk.service else { continue }
                
                semaphore.wait()
                guard let customer = queue.dequeue() else { semaphore.signal(); return }
                semaphore.signal()
                NotificationCenter.default.post(name: Notification.Name("WorkStart"), object: nil, userInfo: ["고객": customer])
                
                clerk.serve(customer as! Customer)
                NotificationCenter.default.post(name: Notification.Name("WorkFinished"), object: nil, userInfo: ["고객": customer])
            }
        }
        return workItem
    }
}
