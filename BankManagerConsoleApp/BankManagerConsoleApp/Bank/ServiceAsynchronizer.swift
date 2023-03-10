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
    
    func work(by clerks: [BankClerkProtocol])
    func makeWorkItem(by clerk: BankClerkProtocol) -> DispatchWorkItem
}

struct DepositServiceAsynchronizer: ServiceAsynchronizerProtocol {
    var queue: Queue<String>
    var group: DispatchGroup = DispatchGroup()
    var thread: DispatchQueue = DispatchQueue.global()
    var semaphore: DispatchSemaphore
    
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
    
    func makeWorkItem(by clerk: BankClerkProtocol) -> DispatchWorkItem {
        let work = DispatchWorkItem {
            while !queue.isEmpty() {
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
    var queue: Queue<String>
    var group: DispatchGroup = DispatchGroup()
    var thread: DispatchQueue = DispatchQueue.global()
    var semaphore: DispatchSemaphore
    
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
    
    func makeWorkItem(by clerk: BankClerkProtocol) -> DispatchWorkItem {
        let work = DispatchWorkItem {
            while !queue.isEmpty() {
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
//
//struct ServiceAsynchronizer {
//    private let depositQueue: Queue<String>
//    private let loanQueue: Queue<String>
//    private var group = DispatchGroup()
//    private let thread = DispatchQueue.global()
//    private let semaphore: DispatchSemaphore
//
//    init(depositQueue: Queue<String>, loanQueue: Queue<String>, semaphoreValue: Int = 1) {
//        self.depositQueue = depositQueue
//        self.loanQueue = loanQueue
//        self.semaphore = DispatchSemaphore(value: semaphoreValue)
//    }
//
//    func work(by clerks: [BankClerkProtocol]) {
//        let workItems = clerks.map(makeWorkItem)
//        workItems.forEach {
//            thread.async(group: group, execute: $0)
//        }
//    }
//
//    private func makeWorkItem(by clerk: BankClerkProtocol) -> DispatchWorkItem {
//        switch clerk.service {
//        case .loan(_):
//            return  DispatchWorkItem {
//                while !loanQueue!.isEmpty() {
//                    semaphore.wait()
//                    guard let customer = loanQueue!.dequeue() else { semaphore.signal(); return }
//                    semaphore.signal()
//
//                    NotificationCenter.default.post(name: Notification.Name("WorkStart"), object: nil, userInfo: ["고객": customer])
//                    clerk.serve(customer as! Customer)
//                    NotificationCenter.default.post(name: Notification.Name("WorkFinished"), object: nil, userInfo: ["고객": customer])
//                }
//            }
//        case .deposit(_):
//            return DispatchWorkItem {
//                while !depositQueue!.isEmpty() {
//                    guard let customer = depositQueue!.dequeue() else { semaphore.signal(); return }
//
//                    NotificationCenter.default.post(name: Notification.Name("WorkStart"), object: nil, userInfo: ["고객": customer])
//                    clerk.serve(customer as! Customer)
//                    NotificationCenter.default.post(name: Notification.Name("WorkFinished"), object: nil, userInfo: ["고객": customer])
//                }
//            }
//        }
//    }
//}
