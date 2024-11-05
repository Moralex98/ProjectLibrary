import Foundation
import SQLite

class DB_FinesManager {
    private let db: Connection
    
    private let finess: Table
    
    private let idFine: Expression<Int64>
    private let idLoan: Expression<Int64>
    private let payments: Expression<Int64>
    private let status: Expression<String>
    
    init() {
        db = DBManager.shared.getConnection()
        
        finess = Table("Fines")
        idFine = Expression<Int64>("idFine")
        idLoan = Expression<Int64>("idLoan")
        payments = Expression<Int64>("payments")
        status = Expression<String>("status")
        
        do {
            try createTablesIfNeeded()
        } catch {
            print("Error al crear las tablas: \(error.localizedDescription)")
        }
    }
    
    public func createTablesIfNeeded() throws {
        try db.run(finess.create(ifNotExists: true) { t in
            t.column(idFine, primaryKey: true)
            t.column(idLoan)
            t.column(payments)
            t.column(status)
        })
    }
    
    /* Modificar el método addFines para aceptar overdueDays y calcular la multa
        public func addFines(idLoanValue: Int64, overdueDays: Int) {
            let paymentsValue: Int64 = Int64(overdueDays * 5)  // 5 pesos por día de retraso
            let statusValue = "PENDIENTE"
            
            do {
                try db.run(finess.insert(idLoan <- idLoanValue, payments <- paymentsValue, status <- statusValue))
                print("Multa creada exitosamente por \(paymentsValue) pesos.")
            } catch {
                print("Error al crear multa: \(error.localizedDescription)")
            }
        }*/
    
    // Modificar el método addFines para aceptar overdueHours y calcular la multa
    public func addFines(idLoanValue: Int64, overdueHours: Int) {
        let paymentsValue: Int64 = Int64(overdueHours * 1)  // 1 peso por hora de retraso
        let statusValue = "PENDIENTE"
        
        do {
            try db.run(finess.insert(idLoan <- idLoanValue, payments <- paymentsValue, status <- statusValue))
            print("Multa creada exitosamente por \(paymentsValue) pesos.")
        } catch {
            print("Error al crear multa: \(error.localizedDescription)")
        }
    }

    
    // Método para obtener todas las multas
    public func getFines() -> [FinesModel] {
        var finesModels: [FinesModel] = []
        
        do {
            for fine in try db.prepare(finess.order(idFine.desc)) {
                let fineModel = FinesModel()
                fineModel.idFine = fine[idFine]
                fineModel.idLoan = fine[idLoan]
                fineModel.payments = fine[payments]
                fineModel.status = fine[status]
                finesModels.append(fineModel)
            }
        } catch {
            print("Error al obtener multas: \(error.localizedDescription)")
        }
        return finesModels
    }
    // Función para verificar si el estudiante tiene una multa pendiente
        public func checkForFine(idStudentValue: Int64) -> (hasFine: Bool, fineAmount: Int64, fineId: Int64) {
            do {
                let query = finess.filter(idLoan == idStudentValue && status == "PENDIENTE")
                if let fine = try db.pluck(query) {
                    return (true, fine[payments], fine[idFine])
                }
            } catch {
                print("Error al verificar multas: \(error.localizedDescription)")
            }
            return (false, 0, 0)
        }
    
    // Método para actualizar el estado de una multa a "PAGADO"
    public func updateFineStatus(idFineValue: Int64) {
        let statusValue = "PAGADO" // Nuevo estado
        
        do {
            let fineToUpdate = finess.filter(idFine == idFineValue)
            try db.run(fineToUpdate.update(status <- statusValue))
            print("Estado de la multa actualizado a PAGADO")
        } catch {
            print("Error al actualizar el estado de la multa: \(error.localizedDescription)")
        }
    }
    // actualiza el monto de la multa segun los dias de retraso
    public func updateFineAmount(idFineValue: Int64, newAmount: Int64) {
        do {
            let fineToUpdate = finess.filter(idFine == idFineValue)
            try db.run(fineToUpdate.update(payments <- newAmount))
            print("Monto de la multa actualizado a \(newAmount) pesos.")
        } catch {
            print("Error al actualizar el monto de la multa: \(error.localizedDescription)")
        }
    }

    
    public func deleteFine(idFine: Int64) {
        do {
            let fine = finess.filter(self.idFine == idFine)
            try db.run(fine.delete())
            print("Multa eliminada exitosamente.")
        } catch {
            print("Error al eliminar la multa: \(error.localizedDescription)")
        }
    }
}
