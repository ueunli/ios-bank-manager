//
//  ServiceAsynchronizer.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/03/09.
//

import Foundation

protocol ServiceAsynchronizerProtocol {
    var queue: Queue<String> { get }
    var group: DispatchGroup { get }
    var thread: DispatchQueue { get  }
    var semaphore: DispatchSemaphore { get }
    var workItems: [DispatchWorkItem] { get }
    var operationStatus: OperationStatus { get }
    
    mutating func work(by clerks: [BankClerkProtocol])
    func makeWorkItem(by clerk: BankClerkProtocol) -> DispatchWorkItem
}

struct DepositServiceAsynchronizer: ServiceAsynchronizerProtocol {
    private(set) var queue: Queue<String>
    private(set) var group: DispatchGroup = DispatchGroup()
    private(set) var thread: DispatchQueue = DispatchQueue.global()
    private(set) var semaphore: DispatchSemaphore
    private(set) var workItems: [DispatchWorkItem] = []
    private(set) var operationStatus: OperationStatus

    init(queue: Queue<String>, semaphoreValue: Int = 1) {
        self.queue = queue
        self.semaphore = DispatchSemaphore(value: semaphoreValue)
        self.operationStatus = OperationStatus()
    }
        
    mutating internal func work(by clerks: [BankClerkProtocol]) {
        workItems = clerks.map(makeWorkItem)
        workItems.forEach {
            thread.async(group: group, execute: $0)
        }
    }
    
    internal func makeWorkItem(by clerk: BankClerkProtocol) -> DispatchWorkItem {
        let work = DispatchWorkItem {
            while !queue.isEmpty() && operationStatus.isWorking {
                semaphore.wait()
                guard let customer = queue.dequeue() else { semaphore.signal(); return }
                semaphore.signal()
                
                NotificationCenter.default.post(name: Notification.Name("WorkStart"), object: nil, userInfo: ["고객": customer])
                clerk.serve(customer as! Customer)
                NotificationCenter.default.post(name: Notification.Name("WorkFinished"), object: nil, userInfo: ["고객": customer])
            }
        }
        return work
    }
}

struct LoanServiceAsychronizer: ServiceAsynchronizerProtocol {
    private(set) var queue: Queue<String>
    private(set) var group: DispatchGroup = DispatchGroup()
    private(set) var thread: DispatchQueue = DispatchQueue.global()
    private(set) var semaphore: DispatchSemaphore
    private(set) var workItems: [DispatchWorkItem] = []
    private(set) var operationStatus: OperationStatus

    init(queue: Queue<String>, semaphoreValue: Int = 1) {
        self.queue = queue
        self.semaphore = DispatchSemaphore(value: semaphoreValue)
        self.operationStatus = OperationStatus()
    }
        
    mutating internal func work(by clerks: [BankClerkProtocol]) {
        workItems = clerks.map(makeWorkItem)
        workItems.forEach {
            thread.async(group: group, execute: $0)
        }
    }
    
    internal func makeWorkItem(by clerk: BankClerkProtocol) -> DispatchWorkItem {
        let work = DispatchWorkItem {
            while !queue.isEmpty() && operationStatus.isWorking {
                semaphore.wait()
                guard let customer = queue.dequeue() else { semaphore.signal(); return }
                semaphore.signal()
                
                NotificationCenter.default.post(name: Notification.Name("WorkStart"), object: nil, userInfo: ["고객": customer])
                clerk.serve(customer as! Customer)
                NotificationCenter.default.post(name: Notification.Name("WorkFinished"), object: nil, userInfo: ["고객": customer])
            }
        }
        return work
    }
}
