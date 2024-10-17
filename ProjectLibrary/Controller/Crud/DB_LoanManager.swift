//
//  DB_LoanManager.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import Foundation
import SQLite

class DB_LoanManager {
    private let db: Connection
    
    private let loans: Table
    private let idLoan: Expression<Int64>!
    private let isbn: Expression<Int64>!
    private let idStudent: Expression<Int64>!
    private let loanDate: Expression<String>!  // Cambiado a String
    private let returnDate: Expression<String>!  // Cambiado a String
    private let health: Expression<String>!
    
    // Aquí inicializamos finesManager
    private let finesManager: DB_FinesManager
    
    init() {
        db = DBManager.shared.getConnection()
            
        loans = Table("loans")
        idLoan = Expression<Int64>("idLoan")
        isbn = Expression<Int64>("isbn")
        idStudent = Expression<Int64>("idStudent")
        loanDate = Expression<String>("loanDate")
        returnDate = Expression<String>("returnDate")
        health = Expression<String>("health")
            
        // Inicializar finesManager
        finesManager = DB_FinesManager()
            
        do {
            try createTablesIfNeeded()
        } catch {
            print("Error al crear las tablas: \(error.localizedDescription)")
        }
    }
        
    public func createTablesIfNeeded() throws {
        try db.run(loans.create(ifNotExists: true) { t in
            t.column(idLoan, primaryKey: true)
            t.column(isbn)
            t.column(idStudent)
            t.column(loanDate)
            t.column(returnDate)
            t.column(health)
        })
    }
    
    // Función para convertir Date a String
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    // Función para convertir String a Date
    private func stringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateString)
    }
    public func checkLoanStatus(idStudentValue: Int64) -> (isOverdue: Bool, daysOverdue: Int) {
        do {
            let query = loans.filter(idStudent == idStudentValue && health == "Préstamo")
            if let loan = try db.pluck(query) {
                let loanDateValue = stringToDate(loan[loanDate])!
                let daysElapsed = Calendar.current.dateComponents([.day], from: loanDateValue, to: Date()).day ?? 0
                
                if daysElapsed > 7 {
                    let overdueDays = daysElapsed - 7
                    finesManager.addFines(idLoanValue: loan[idLoan], overdueDays: overdueDays)  // Crear multa con los días de retraso
                    return (true, overdueDays)
                }
            }
        } catch {
            print("Error al verificar el préstamo: \(error.localizedDescription)")
        }
        return (false, 0)
    }
    
    // Modificar la función para agregar préstamo
    public func addLoan(isbnValue: Int64, idStudentValue: Int64) {
        let currentDate = dateToString(Date())
        let status = "Préstamo"
            
        do {
            try db.run(loans.insert(isbn <- isbnValue, idStudent <- idStudentValue, loanDate <- currentDate, returnDate <- "", health <- status))
                print("Préstamo agregado exitosamente")
        } catch {
                print("Error al agregar préstamo: \(error.localizedDescription)")
        }
    }
    //funcion para devolver la lista de prestaamos
    public func getLoans() -> [LoanModel] {
            var loanModels: [LoanModel] = []
            
            do {
                for loan in try db.prepare(loans.order(idLoan.desc)) {
                    let loanModel = LoanModel()
                    loanModel.idLoan = loan[idLoan]
                    loanModel.isbn = loan[isbn]
                    loanModel.idStudent = loan[idStudent]
                    loanModel.loanDate = loan[loanDate]
                    loanModel.returnDate = loan[returnDate]
                    loanModel.health = loan[health]
                    
                    print("id: \(loanModel.idLoan) - isbn: \(loanModel.isbn)")
                    
                    loanModels.append(loanModel)
                }
                print("libros recuperados: \(loanModels.count)")
            } catch {
                print("Error prestamos: \(error.localizedDescription)")
            }
            return loanModels
        }
        
        public func getLoan(idLoanValue: Int64) -> LoanModel? {
            let loanModel = LoanModel()
            
            do {
                let query = loans.filter(idLoan == idLoanValue)
                if let loan = try db.pluck(query) {
                    loanModel.idLoan = loan[idLoan]
                    loanModel.isbn = loan[isbn]
                    loanModel.idStudent = loan[idStudent]
                    loanModel.loanDate = loan[loanDate]
                    loanModel.returnDate = loan[returnDate]
                    loanModel.health = loan[health]
                    
                    print("préstamo encontrado: \(loanModel.idLoan)")
                    
                    return loanModel
                } else {
                    print("No se encontró préstamo: \(loanModel.idLoan)")
                    return nil
                }
            } catch {
                print("Error préstamo: \(error.localizedDescription)")
                return nil
            }
        }
        
    // Actualiza el estado del préstamo a "DEVUELTO"
        public func updateLoanStatusToReturned(idLoanValue: Int64) {
            let currentDate = dateToString(Date())
            
            do {
                let loan = loans.filter(idLoan == idLoanValue)
                try db.run(loan.update(returnDate <- currentDate, health <- "Devuelto"))
                print("Préstamo devuelto exitosamente")
            } catch {
                print("Error al actualizar el préstamo: \(error.localizedDescription)")
            }
        }
}
