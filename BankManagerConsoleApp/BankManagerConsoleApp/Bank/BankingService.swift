//
//  BankingService.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/03/02.
//

import Foundation

enum BankingService: CaseIterable, Hashable {
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

