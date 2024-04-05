//
//  ReportType.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import Foundation

enum ReportType {
    case user(UserReportType)
    case product(ProductReportType)
}

enum UserReportType: String {
    
    case hateSpeech = "HATE_SPEECH"
    case transactionProblem = "TRANSACTION_PROBLEM"
    case fraud = "FRAUD"
}

enum ProductReportType: String {
    case plagiarism = "PLAGIARISM"
    case sexualAbuse = "SEXUAL"
    case violence = "VIOLENT"
}
