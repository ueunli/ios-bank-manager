//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/02/23.
//

import Foundation

class Bank {
    private let clerks: [BankClerk]
    private let customers: Queue<String>
    private var numberOfCustomers: Int = 0 {
        didSet {
            lineUpCustomersInQueue(oldValue + 1 ... numberOfCustomers)
            //handleAllCustomers()
        }
    }
    private var timer: Timer
    private var serviceManager: ServiceAsynchronizer
    
    init(clerks: BankingService...) {
        self.customers = Queue<String>()
        self.clerks = Array(clerksPerType: clerks)
        self.timer = Timer()
        self.serviceManager = ServiceAsynchronizer.shared
    }
    
    func open() {
        timer.start()
        lineUpCustomersInQueue(0...0)
        handleAllCustomers()
        timer.finish()
    }
    
    private func lineUpCustomersInQueue(_ range: ClosedRange<Int>) {
        range.forEach {
            let customer = Customer(number: $0)
            customers.enqueue(customer)
            serviceManager.addService(for: customer)
            NotificationCenter.default.post(.add, about: customer)
        }
    }
    
    func handleAllCustomers() {
        //if !serviceManager.isPowered {
        serviceManager.work(by: clerks)
        //}
    }
    
    func close() {
        let totalSpentTime = timer.totalTime()
        printClosingMessage(with: totalSpentTime)
    }
    
    func removeCustomers() {
        customers.clear()
    }
    
    private func printClosingMessage(with totalSpentTime: Double) {
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(numberOfCustomers)명이며, 총 업무시간은 \(totalSpentTime)초입니다.")
    }
    
    func addMoreCustomers(_ count: Int = 10) {
        numberOfCustomers += count
    }
}
