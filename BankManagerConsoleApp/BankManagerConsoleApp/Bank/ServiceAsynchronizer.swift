//
//  ServiceAsynchronizer.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/03/09.
//

import Foundation

struct ServiceAsynchronizer<Service: ServiceType, Server: ServerType> {
    private var queues = [Service: Queue<String>]()
    private var group = DispatchGroup()
    private let thread = DispatchQueue.global()
    private let semaphore: DispatchSemaphore
    
    init(queue: Queue<String>, semaphoreValue: Int = 1) {
        self.semaphore = DispatchSemaphore(value: semaphoreValue)
        setServiceType()
        while !queue.isEmpty() {
            guard let customer = queue.dequeue() as? Customer<Service> else { continue }
            guard let service = customer.purpose else { return }
            queues[service]?.enqueue(customer)
        }
    }
    
    private mutating func setServiceType() {
        let serviceTypes = Service.allCases
        serviceTypes.forEach { self.queues.updateValue(Queue<String>(), forKey: $0) }
    }
    
    func work(by workers: [Server]) {
        let workItems = workers.map(makeWorkItem)
        workItems.forEach {
            thread.async(execute: $0)
        }
    }
    
    private func makeWorkItem(by worker: Server) -> DispatchWorkItem {
        let workItem = DispatchWorkItem {
            guard let service = worker.service as? Service else { return }
            guard let queue = queues[service] else { return }
            
            while !queue.isEmpty() {
                guard !worker.isWorking else { continue }
                
                semaphore.wait()
                guard let customer = queue.dequeue() as? Customer<Service> else { semaphore.signal(); return }
                semaphore.signal()
                
                NotificationCenter.default.post(name: Notification.Name("WorkStart"), object: nil, userInfo: ["고객": customer])
                worker.isWorking = true
                worker.serve(customer)
                worker.isWorking = false
                NotificationCenter.default.post(name: Notification.Name("WorkFinished"), object: nil, userInfo: ["고객": customer])
            }
        }
        return workItem
    }
}
