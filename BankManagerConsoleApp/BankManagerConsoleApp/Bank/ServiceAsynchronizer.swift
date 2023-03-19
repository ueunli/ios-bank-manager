//
//  ServiceAsynchronizer.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/03/09.
//

import Foundation

class ServiceAsynchronizer {
    static let shared = ServiceAsynchronizer()
    //private(set) var powered: Bool { queues.values.allSatisfy { $0.isEmpty() } }
    private let group = DispatchGroup()
    private var queues = [BankingService: Queue<String>]()
    private let thread = DispatchQueue.global()
    private var semaphore = [BankingService: DispatchSemaphore]()
    
    private init(semaphoreValue: Int = 1) {
        //setServiceType()
        let serviceTypes = BankingService.allCases
        serviceTypes.forEach { self.queues.updateValue(Queue<String>(), forKey: $0) }
        serviceTypes.forEach { self.semaphore.updateValue(DispatchSemaphore(value: semaphoreValue), forKey: $0) }
    }
    
    private func setServiceType() {
        let serviceTypes = BankingService.allCases
        serviceTypes.forEach { self.queues.updateValue(Queue<String>(), forKey: $0) }
        serviceTypes.forEach { self.semaphore.updateValue(DispatchSemaphore(value: 1), forKey: $0) }
    }
    
    func addServices(for customers: Queue<String>) {
        while !customers.isEmpty() {
            guard let customer = customers.dequeue() as? Customer else { continue }
            addService(for: customer)
        }
    }
    
    func addService(for customer: Customer) {
        guard let service = customer.purpose else { return }
        queues[service]?.enqueue(customer)
    }
    
    func work(by workers: [BankClerk]) {
        let workItems = workers.map(makeWorkItem)
        workItems.forEach {
            thread.async(group: group, execute: $0)
        }
    }
    
    private func makeWorkItem(by worker: BankClerk) -> DispatchWorkItem {
        let workItem = DispatchWorkItem { [self] in
            guard let queue = queues[worker.service],
                  let semaphore = semaphore[worker.service] else { return }
            
            while !queue.isEmpty() {
                guard !worker.isWorking else { continue }
                
                semaphore.wait()
                guard let customer = queue.dequeue() as? Customer else { semaphore.signal(); return }
                semaphore.signal()
                
                NotificationCenter.default.post(.serve, about: customer)
                worker.serve(customer)
                NotificationCenter.default.post(.remove, about: customer)
            }
        }
        return workItem
    }
}
