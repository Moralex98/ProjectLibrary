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
    // Verificar si el estudiante tiene un préstamo pendiente
        public func hasActiveLoan(idStudentValue: Int64) -> Bool {
            do {
                let query = loans.filter(idStudent == idStudentValue && health == "Préstamo")
                return try db.pluck(query) != nil
            } catch {
                print("Error al verificar préstamo activo: \(error.localizedDescription)")
                return false
            }
        }
        
        // Obtener préstamo activo del estudiante
        public func getActiveLoan(idStudentValue: Int64) -> LoanModel? {
            do {
                let query = loans.filter(idStudent == idStudentValue && health == "Préstamo")
                if let loan = try db.pluck(query) {
                    let loanModel = LoanModel()
                    loanModel.idLoan = loan[idLoan]
                    loanModel.isbn = loan[isbn]
                    loanModel.idStudent = loan[idStudent]
                    loanModel.loanDate = loan[loanDate]
                    loanModel.returnDate = loan[returnDate]
                    loanModel.health = loan[health]
                    
                    return loanModel
                }
            } catch {
                print("Error al obtener préstamo activo: \(error.localizedDescription)")
            }
            return nil
        }
        /*calcula si un estudiante tiene un dia de retraso para la multa
        public func verifyAndCreateFineIfNeeded(idStudentValue: Int64, isbnValue: Int64) {
            do {
                let query = loans.filter(idStudent == idStudentValue && isbn == isbnValue && health == "Préstamo")
                if let loan = try db.pluck(query) {
                    let loanDateValue = stringToDate(loan[loanDate])!
                    let daysElapsed = Calendar.current.dateComponents([.day], from: loanDateValue, to: Date()).day ?? 0
                    
                    if daysElapsed > 1 {
                        let overdueDays = daysElapsed - 1
                        
                        // Verificar si ya existe una multa para este préstamo
                        let fineCheck = finesManager.checkForFine(idStudentValue: idStudentValue)
                        
                        if fineCheck.hasFine {
                            // Actualizar multa existente: calcular días adicionales y actualizar monto
                            let additionalDays = overdueDays - Int(fineCheck.fineAmount / 5) // Días de multa ya calculados
                            if additionalDays > 0 {
                                let newFineAmount = fineCheck.fineAmount + Int64(additionalDays * 5)
                                finesManager.updateFineAmount(idFineValue: fineCheck.fineId, newAmount: newFineAmount)
                                print("Multa actualizada a \(newFineAmount) pesos por \(overdueDays) días de retraso.")
                            }
                        } else {
                            // Crear una nueva multa si aún no existe
                            finesManager.addFines(idLoanValue: loan[idLoan], overdueDays: overdueDays)
                            print("Multa creada por \(overdueDays * 5) pesos por \(overdueDays) días de retraso.")
                        }
                    } else {
                        print("No hay retraso en el préstamo.")
                    }
                } else {
                    print("No se encontró un préstamo activo para esta matrícula e ISBN.")
                }
            } catch {
                print("Error al verificar el estado del préstamo: \(error.localizedDescription)")
            }
        }
       // Nueva función para verificar y crear multas para todos los préstamos atrasados
       public func updateOverdueFinesForAllLoans() {
           do {
               // Filtrar solo los préstamos activos
               for loan in try db.prepare(loans.filter(health == "Préstamo")) {
                   let loanDateValue = stringToDate(loan[loanDate])!
                   let daysElapsed = Calendar.current.dateComponents([.day], from: loanDateValue, to: Date()).day ?? 0
                   
                   if daysElapsed > 1 {
                       let overdueDays = daysElapsed - 1
                       
                       // Verificar si ya existe una multa para este préstamo
                       let fineCheck = finesManager.checkForFine(idStudentValue: loan[idStudent])
                       
                       if fineCheck.hasFine {
                           // Actualizar multa existente si ya hay días adicionales de atraso
                           let additionalDays = overdueDays - Int(fineCheck.fineAmount / 5)
                           if additionalDays > 0 {
                               let newFineAmount = fineCheck.fineAmount + Int64(additionalDays * 5)
                               finesManager.updateFineAmount(idFineValue: fineCheck.fineId, newAmount: newFineAmount)
                               print("Multa actualizada a \(newFineAmount) pesos para préstamo con id \(loan[idLoan]) por \(overdueDays) días de retraso.")
                           }
                       } else {
                           // Crear nueva multa si aún no existe
                           finesManager.addFines(idLoanValue: loan[idLoan], overdueDays: overdueDays)
                           print("Multa creada por \(overdueDays * 5) pesos para préstamo con id \(loan[idLoan]) por \(overdueDays) días de retraso.")
                       }
                   }
               }
           } catch {
               print("Error al actualizar multas para préstamos atrasados: \(error.localizedDescription)")
           }
       }*/
    // Calcula si un estudiante tiene un retraso en horas y crea o actualiza la multa según sea necesario
    public func verifyAndCreateFineIfNeeded(idStudentValue: Int64, isbnValue: Int64) {
        do {
            let query = loans.filter(idStudent == idStudentValue && isbn == isbnValue && health == "Préstamo")
            if let loan = try db.pluck(query) {
                let loanDateValue = stringToDate(loan[loanDate])!
                let hoursElapsed = Calendar.current.dateComponents([.hour], from: loanDateValue, to: Date()).hour ?? 0
                
                if hoursElapsed > 1 {
                    let overdueHours = hoursElapsed - 1
                    
                    // Verificar si ya existe una multa para este préstamo
                    let fineCheck = finesManager.checkForFine(idStudentValue: idStudentValue)
                    
                    if fineCheck.hasFine {
                        // Actualizar multa existente: calcular horas adicionales y actualizar monto
                        let additionalHours = overdueHours - Int(fineCheck.fineAmount / 1) // Horas de multa ya calculadas
                        if additionalHours > 0 {
                            let newFineAmount = fineCheck.fineAmount + Int64(additionalHours * 1) // 1 peso por hora
                            finesManager.updateFineAmount(idFineValue: fineCheck.fineId, newAmount: newFineAmount)
                            print("Multa actualizada a \(newFineAmount) pesos por \(overdueHours) horas de retraso.")
                        }
                    } else {
                        // Crear una nueva multa si aún no existe
                        finesManager.addFines(idLoanValue: loan[idLoan], overdueHours: overdueHours)
                        print("Multa creada por \(overdueHours * 1) pesos por \(overdueHours) horas de retraso.")
                    }
                } else {
                    print("No hay retraso en el préstamo.")
                }
            } else {
                print("No se encontró un préstamo activo para esta matrícula e ISBN.")
            }
        } catch {
            print("Error al verificar el estado del préstamo: \(error.localizedDescription)")
        }
    }

    // Nueva función para verificar y crear multas para todos los préstamos atrasados, ahora calculando por horas
    public func updateOverdueFinesForAllLoans() {
        do {
            // Filtrar solo los préstamos activos
            for loan in try db.prepare(loans.filter(health == "Préstamo")) {
                let loanDateValue = stringToDate(loan[loanDate])!
                let hoursElapsed = Calendar.current.dateComponents([.hour], from: loanDateValue, to: Date()).hour ?? 0
                
                if hoursElapsed > 1 {
                    let overdueHours = hoursElapsed - 1
                    
                    // Verificar si ya existe una multa para este préstamo
                    let fineCheck = finesManager.checkForFine(idStudentValue: loan[idStudent])
                    
                    if fineCheck.hasFine {
                        // Actualizar multa existente si ya hay horas adicionales de atraso
                        let additionalHours = overdueHours - Int(fineCheck.fineAmount / 1) // 1 peso por hora
                        if additionalHours > 0 {
                            let newFineAmount = fineCheck.fineAmount + Int64(additionalHours * 1)
                            finesManager.updateFineAmount(idFineValue: fineCheck.fineId, newAmount: newFineAmount)
                            print("Multa actualizada a \(newFineAmount) pesos para préstamo con id \(loan[idLoan]) por \(overdueHours) horas de retraso.")
                        }
                    } else {
                        // Crear nueva multa si aún no existe
                        finesManager.addFines(idLoanValue: loan[idLoan], overdueHours: overdueHours)
                        print("Multa creada por \(overdueHours * 1) pesos para préstamo con id \(loan[idLoan]) por \(overdueHours) horas de retraso.")
                    }
                }
            }
        } catch {
            print("Error al actualizar multas para préstamos atrasados: \(error.localizedDescription)")
        }
    }

    
    /*
        // Calcular multa según días de atraso
        public func checkLoanStatus(idStudentValue: Int64, overdueThreshold: Int = 1) -> (isOverdue: Bool, daysOverdue: Int) {
            do {
                let query = loans.filter(idStudent == idStudentValue && health == "Préstamo")
                if let loan = try db.pluck(query) {
                    let loanDateValue = stringToDate(loan[loanDate])!
                    let daysElapsed = Calendar.current.dateComponents([.day], from: loanDateValue, to: Date()).day ?? 0
                    
                    // Verificar si el préstamo ha pasado del umbral de días
                    if daysElapsed > overdueThreshold {
                        let overdueDays = daysElapsed - overdueThreshold
                        finesManager.addFines(idLoanValue: loan[idLoan], overdueHours: overdueHours)
                        return (true, overdueDays)
                    }
                }
            } catch {
                print("Error al verificar el estado del préstamo: \(error.localizedDescription)")
            }
            return (false, 0)
        }
     */
    public func checkLoanStatus(idStudentValue: Int64, overdueThreshold: Int = 1) -> (isOverdue: Bool, hoursOverdue: Int) {
        do {
            let query = loans.filter(idStudent == idStudentValue && health == "Préstamo")
            if let loan = try db.pluck(query) {
                let loanDateValue = stringToDate(loan[loanDate])!
                let hoursElapsed = Calendar.current.dateComponents([.hour], from: loanDateValue, to: Date()).hour ?? 0
                
                // Verificar si el préstamo ha pasado del umbral de horas
                if hoursElapsed > overdueThreshold {
                    let overdueHours = hoursElapsed - overdueThreshold
                    finesManager.addFines(idLoanValue: loan[idLoan], overdueHours: overdueHours)
                    return (true, overdueHours)
                }
            }
        } catch {
            print("Error al verificar el estado del préstamo: \(error.localizedDescription)")
        }
        return (false, 0)
    }

        // Añadir un préstamo
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
        
        // Actualizar estado del préstamo a "Devuelto"
        public func updateLoanStatusToReturned(idLoanValue: Int64) {
            let currentDate = dateToString(Date())
            
            do {
                let loan = loans.filter(idLoan == idLoanValue)
                try db.run(loan.update(returnDate <- currentDate, health <- "Devuelto"))
                print("Préstamo devuelto exitosamente")
            } catch {
                print("Error al actualizar el estado del préstamo: \(error.localizedDescription)")
            }
        }
    // Función para obtener todos los préstamos
        public func getLoans() -> [LoanModel] {
            var loanModels: [LoanModel] = []
            
            do {
                // Recuperar todos los préstamos de la tabla
                for loan in try db.prepare(loans) {
                    let loanModel = LoanModel()
                    loanModel.idLoan = loan[idLoan]
                    loanModel.isbn = loan[isbn]
                    loanModel.idStudent = loan[idStudent]
                    loanModel.loanDate = loan[loanDate]
                    loanModel.returnDate = loan[returnDate]
                    loanModel.health = loan[health]
                    
                    loanModels.append(loanModel)
                }
            } catch {
                print("Error al obtener préstamos: \(error.localizedDescription)")
            }
            
            return loanModels
        }
        public func deleteLoan(idLoanValue: Int64) {
            do {
                let loan = loans.filter(self.idLoan == idLoanValue)
                try db.run(loan.delete())
                print("Préstamo eliminado exitosamente.")
            } catch {
                print("Error al eliminar el préstamo: \(error.localizedDescription)")
            }
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
}
