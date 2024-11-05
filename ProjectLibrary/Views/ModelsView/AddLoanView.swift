//
//  AddLoanView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct AddLoanView: View {
    @State private var isbn: String = ""
    @State private var idStudent: String = ""
    
    @State private var showPopup = false
    @State private var popupMessage = ""
    @State private var popupSuccess = false
    @State private var showPaymentPopup = false
    @State private var fineAmount: Int64 = 0
    @State private var fineId: Int64 = 0
    
    let loanManager = DB_LoanManager()
    let finesManager = DB_FinesManager()
    let bookManager = DB_BookManager()
    let studentManager = DB_StudentManager()
    
    var body: some View {
        ZStack {
            // Fondo con degradado
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Servicio de préstamos y devoluciones")
                        .font(.custom("Avenir Next", size: 36))  // Fuente estilizada para el título
                        .foregroundColor(.black)
                        .padding(.bottom, 30)
                    
                    TextField("Ingresa el ISBN", text: $isbn)
                        .keyboardType(.numberPad)
                        .padding(20)
                        .frame(width: 500)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .font(.custom("Avenir Next", size: 20))  // Fuente estilizada para los campos de entrada
                        .disableAutocorrection(true)
                    
                    TextField("Ingresa el ID del estudiante", text: $idStudent)
                        .keyboardType(.numberPad)
                        .padding(20)
                        .frame(width: 500)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .font(.custom("Avenir Next", size: 20))  // Fuente estilizada para los campos de entrada
                        .disableAutocorrection(true)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            handleLoanAction(isReturning: false)
                        }, label: {
                            Text("Conceder préstamo")
                                .padding()
                                .background(Color.purple.opacity(0.8))  // Botón púrpura oscuro
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.custom("Avenir Next", size: 25))  // Fuente estilizada para el botón
                        })
                        .padding(.top)
                        
                        Button(action: {
                            handleLoanAction(isReturning: true)
                        }, label: {
                            Text("Devolver libro")
                                .padding()
                                .background(Color.blue.opacity(0.8))  // Botón azul intenso
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.custom("Avenir Next", size: 27))  // Fuente estilizada para el botón
                        })
                        .padding(.top)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(
            Group {
                if showPopup {
                    PopUpView(popup: $showPopup, message: $popupMessage, success: $popupSuccess)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .background(Color.black.opacity(0.3))
                        .transition(.opacity)
                        .animation(.easeInOut, value: showPopup)
                        .ignoresSafeArea()
                }
                if showPaymentPopup {
                    PopUpViewTwo(
                        popup: $showPaymentPopup,
                        message: $popupMessage,
                        success: $popupSuccess,
                        onPay: {
                            finesManager.updateFineStatus(idFineValue: fineId)
                            popupMessage = "Multa pagada exitosamente."
                            popupSuccess = true
                            showPopup = true
                        },
                        onCancel: {
                            popupMessage = "La multa permanece en estado pendiente."
                            popupSuccess = false
                            showPopup = true
                        }
                    )
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(Color.black.opacity(0.3))
                    .transition(.opacity)
                    .animation(.easeInOut, value: showPaymentPopup)
                    .ignoresSafeArea()
                }
            }
        )
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    func handleLoanAction(isReturning: Bool) {
        if let isbnValue = Int64(isbn), let idStudentValue = Int64(idStudent) {
            if bookManager.isISBNRegistered(isbnValue: isbnValue) && !studentManager.isIdStudentNotRegistered(idStudentValue: idStudentValue) {
                if isReturning {
                    handleReturn(idStudentValue: idStudentValue)
                } else {
                    handleLoan(isbnValue: isbnValue, idStudentValue: idStudentValue)
                }
            } else {
                popupMessage = "ISBN o ID del estudiante no existen"
                popupSuccess = false
                showPopup = true
            }
        } else {
            popupMessage = "Ingrese valores válidos para ISBN e ID de estudiante"
            popupSuccess = false
            showPopup = true
        }
    }
    
    func handleLoan(isbnValue: Int64, idStudentValue: Int64) {
        if loanManager.hasActiveLoan(idStudentValue: idStudentValue) {
            popupMessage = "El estudiante ya tiene un préstamo activo."
            popupSuccess = false
            showPopup = true
            return
        }
        
        let (hasFine, fineAmount, fineId) = finesManager.checkForFine(idStudentValue: idStudentValue)
        if hasFine {
            popupMessage = "El estudiante tiene una multa de \(fineAmount) pesos. ¿Desea pagarla?"
            self.fineAmount = fineAmount
            self.fineId = fineId
            popupSuccess = false
            showPaymentPopup = true
        } else if bookManager.getBook(isbnValue: isbnValue)?.numberBooks == 1 {
            popupMessage = "El libro tiene solo un ejemplar, no puede ser prestado."
            popupSuccess = false
            showPopup = true
        } else {
            loanManager.addLoan(isbnValue: isbnValue, idStudentValue: idStudentValue)
            bookManager.updateBookQuantity(isbnValue: isbnValue, delta: -1)
            popupMessage = "Préstamo exitoso"
            popupSuccess = true
            resetFields()
            showPopup = true
        }
    }
    func handleReturn(idStudentValue: Int64) {
        if let loan = loanManager.getActiveLoan(idStudentValue: idStudentValue) {
            // Verificar si el préstamo tiene un retraso en horas y crear multa si es necesario
            loanManager.verifyAndCreateFineIfNeeded(idStudentValue: idStudentValue, isbnValue: loan.isbn)
            
            let (isOverdue, hoursOverdue) = loanManager.checkLoanStatus(idStudentValue: idStudentValue, overdueThreshold: 1) // Cambiado a horas
            
            if isOverdue {
                // Calcular el monto de la multa y crearla en la base de datos
                let fineAmount = Int64(hoursOverdue * 1) // 1 peso por hora de retraso
                finesManager.addFines(idLoanValue: loan.idLoan, overdueHours: hoursOverdue) // Crear multa en base a horas de retraso
                self.fineAmount = fineAmount
                self.fineId = loan.idLoan
                
                // Mostrar popup para preguntar si desea pagar la multa
                popupMessage = "Tiene una multa de \(fineAmount) pesos por \(hoursOverdue) horas de atraso. ¿Desea pagarla?"
                showPaymentPopup = true
            } else {
                // Si no hay retraso, simplemente completar la devolución
                loanManager.updateLoanStatusToReturned(idLoanValue: loan.idLoan)
                bookManager.updateBookQuantity(isbnValue: loan.isbn, delta: 1) // Incrementar cantidad de libros disponibles
                popupMessage = "Devolución exitosa"
                popupSuccess = true
                resetFields()
                showPopup = true
            }
        } else {
            // Mensaje si no hay préstamo activo para devolver
            popupMessage = "No hay préstamos activos para este estudiante."
            popupSuccess = false
            showPopup = true
        }
    }
    /*
    func handleReturn(idStudentValue: Int64) {
        if let loan = loanManager.getActiveLoan(idStudentValue: idStudentValue) {
            // Verificar si el préstamo tiene un día de atraso y crear multa si es necesario
            loanManager.verifyAndCreateFineIfNeeded(idStudentValue: idStudentValue, isbnValue: loan.isbn)
            
            let (isOverdue, daysOverdue) = loanManager.checkLoanStatus(idStudentValue: idStudentValue)
            
            if isOverdue {
                // Calcular el monto de la multa y crearla en la base de datos
                let fineAmount = Int64(daysOverdue * 5) // 5 pesos por día de retraso
                finesManager.addFines(idLoanValue: loan.idLoan, overdueDays: daysOverdue) // Crear multa
                self.fineAmount = fineAmount
                self.fineId = loan.idLoan
                
                // Mostrar popup para preguntar si desea pagar la multa
                popupMessage = "Tiene una multa de \(fineAmount) pesos por \(daysOverdue) días de atraso. ¿Desea pagarla?"
                showPaymentPopup = true
            } else {
                // Si no hay retraso, simplemente completar la devolución
                loanManager.updateLoanStatusToReturned(idLoanValue: loan.idLoan)
                bookManager.updateBookQuantity(isbnValue: loan.isbn, delta: 1) // Incrementar cantidad de libros disponibles
                popupMessage = "Devolución exitosa"
                popupSuccess = true
                resetFields()
                showPopup = true
            }
        } else {
            // Mensaje si no hay préstamo activo para devolver
            popupMessage = "No hay préstamos activos para este estudiante."
            popupSuccess = false
            showPopup = true
        }
    }*/
    
    func resetFields() {
        isbn = ""
        idStudent = ""
    }
}

struct AddLoanView_Previews: PreviewProvider {
    static var previews: some View {
        AddLoanView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
