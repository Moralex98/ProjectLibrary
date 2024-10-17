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
    
    let loanManager = DB_LoanManager()

    var body: some View {
        ZStack {
            VStack {
                Spacer() // Espaciador superior para centrar verticalmente
                
                VStack(spacing: 20) {
                    Text("Servicio de préstamos y devoluciones")
                        .font(Font.custom("MisterGrape", size: 40))
                        .padding(.bottom, 30)

                    TextField("Ingresa el ISBN", text: $isbn)
                        .keyboardType(.numberPad)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                    TextField("Ingresa el ID del estudiante", text: $idStudent)
                        .keyboardType(.numberPad)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)

                    HStack(spacing: 20) {
                        Button(action: {
                            handleLoanAction(isReturning: false)
                        }, label: {
                            Text("Conceder préstamo")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                        .padding(.top)
                        .font(.title)

                        Button(action: {
                            handleLoanAction(isReturning: true)
                        }, label: {
                            Text("Devolver libro")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                        .padding(.top)
                        .font(.title)
                    }
                    .padding(.top, 20)
                }

                Spacer() // Espaciador inferior para centrar verticalmente
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Asegura que ocupe todo el espacio disponible
            
           
        }
        .overlay(
            Group {
                // Popup emergente
                if showPopup {
                    PopUpView(popup: $showPopup, message: $popupMessage, success: $popupSuccess)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .background(Color.black.opacity(0.3)) // Fondo oscuro para el popup
                        .transition(.opacity) // Cambiar la animación para evitar movimiento
                        .animation(.easeInOut, value: showPopup)
                        .ignoresSafeArea()
                }
            }
        )
        .ignoresSafeArea(.keyboard, edges: .bottom) // Evitar que el teclado mueva la vista
    }
    
    // Manejo de préstamo o devolución
        func handleLoanAction(isReturning: Bool) {
            let bookManager = DB_BookManager()
            let studentManager = DB_StudentManager()

            if let isbnValue = Int64(isbn), let idStudentValue = Int64(idStudent) {
                if bookManager.isISBNRegistered(isbnValue: isbnValue) && !studentManager.isIdStudentNotRegistered(idStudentValue: idStudentValue) {
                    let (isOverdue, overdueDays) = loanManager.checkLoanStatus(idStudentValue: idStudentValue)
                    
                    if isOverdue {
                        popupMessage = "El estudiante tiene una multa de \(overdueDays * 5) pesos. ¿Desea pagarla?"
                        popupSuccess = false
                    } else {
                        loanManager.addLoan(isbnValue: isbnValue, idStudentValue: idStudentValue)
                        popupMessage = isReturning ? "Devolución exitosa" : "Préstamo exitoso"
                        popupSuccess = true
                    }
                } else {
                    popupMessage = "ISBN o ID del estudiante no existen"
                    popupSuccess = false
                }
            } else {
                popupMessage = "Ingrese valores válidos para ISBN e ID de estudiante"
                popupSuccess = false
            }
            showPopup = true
        }
    
    
    func loadCustomFont() {
        guard let fontURL = Bundle.main.url(forResource: "MisterGrape", withExtension: "otf") else {
            print("No se pudo encontrar el archivo de la fuente")
            return
        }

        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
            print("Fuente registrada exitosamente")
        } else {
            print("Error al registrar la fuente: \(error!.takeRetainedValue())")
        }
    }
}

struct AddLoanView_Previews: PreviewProvider {
    static var previews: some View {
        AddLoanView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
