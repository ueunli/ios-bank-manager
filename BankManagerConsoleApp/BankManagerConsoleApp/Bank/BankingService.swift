//
//  BankingService.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/03/02.
//

import Foundation

protocol ServiceType: CaseIterable, Hashable {
    //associatedtype Server: ServerType
    //static var serverType: AnyObject. where ServerType { get } //any ServerType.Type { get }
    var title: String { get }
    var timeSpent: Double { get }
}

protocol ServerType: AnyObject {
    associatedtype Service: ServiceType
    var isWorking: Bool { get set }
    var service: Service { get }
    func serve(_ customer: Customer<Service>)
}

//protocol Servicable: 

enum BankingService: ServiceType {
    typealias Server = BankClerk
    
    //static var serverType: any ServerType.Type = BankClerk.self
    static var allCases: [BankingService] = [deposit(), loan()]
    
    case deposit(Int = 0)
    case loan(Int = 0)
    
    var title: String {
        switch self {
        case .deposit: return "예금"
        case .loan: return "대출"
        }
    }
    
    var timeSpent: Double {
        switch self {
        case .deposit: return 0.7
        case .loan: return 1.1
        }
    }
}

