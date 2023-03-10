//
//  ServiceAsynchronizer.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/03/09.
//

import Foundation

struct ServiceAsynchronizer {
    private var queues = [BankingService: Queue<String>]()
    private var group = DispatchGroup()
    private let thread = DispatchQueue.global()
    private let semaphore: DispatchSemaphore
    
    init(queue: Queue<String>, semaphoreValue: Int = 1) {
        self.semaphore = DispatchSemaphore(value: semaphoreValue)
        setServiceType()
        while !queue.isEmpty() {
            guard let customer = queue.dequeue() as? Customer else { continue }
            queues[customer.purpose!]?.enqueue(customer)
        }
    }
    
    private mutating func setServiceType(serviceType: any CaseIterable.Type = BankingService.self) {
        let serviceTypes = serviceType.allCases as! [BankingService]
        serviceTypes.forEach { self.queues.updateValue(Queue<String>(), forKey: $0) }
    }
    
    func work(by clerks: [BankClerkProtocol]) {
        let workItems = clerks.map {
            var clerk = $0
            return makeWorkItem(by:clerk)
        }
        workItems.forEach {
            thread.async(execute: $0)
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
                //clerk.isWorking = true
                clerk.serve(customer)
                //clerk.isWorking = false
                NotificationCenter.default.post(name: Notification.Name("WorkFinished"), object: nil, userInfo: ["고객": customer])
            }
        }
        return workItem
    }
}
