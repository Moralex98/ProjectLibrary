//
//  LoanModel.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import Foundation

class LoanModel: Identifiable {
    var idLoan: Int64 = 0
    var isbn: Int64 = 0
    var idStudent: Int64 = 0
    var loanDate: String = ""
    var returnDate: String = ""
    var health: String = ""
}
