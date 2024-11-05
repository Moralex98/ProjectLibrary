//
//  LoanListView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 18/09/24.
//

import SwiftUI

struct LoanListView: View {
    @State private var loanModels: [LoanModel] = []
    @State private var totalLoansInProgress: Int = 0 // Total de libros en estado "Préstamo"
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo degradado para la vista principal
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    VStack {
                        List {
                            ForEach(self.loanModels.sorted(by: { $0.idLoan < $1.idLoan })) { loan in
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("ID: \(loan.idLoan) - Matrícula: \(loan.idStudent)")
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                        Text("ISBN: \(loan.isbn) - Estado: \(loan.health) - Fecha de préstamo: \(loan.loanDate)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        if loan.health == "Devuelto" {
                                            Text("Fecha de devolución: \(loan.returnDate)")
                                                .font(.subheadline)
                                                .foregroundColor(.green)
                                        } else {
                                            Text("Fecha de devolución: Pendiente")
                                                .font(.subheadline)
                                                .foregroundColor(.red)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6).opacity(0.9))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteLoan(loan: loan)
                                    } label: {
                                        Label("Eliminar", systemImage: "trash.fill")
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .background(Color.clear)
                    }
                    .padding(20)
                    .onAppear {
                        loadLoans()
                    }
                }
                .preferredColorScheme(.light)
            }
            .navigationTitle("Lista de Préstamos")
            .font(.custom("AvenirNext-Bold", size: 28))
            .navigationBarItems(trailing: HStack(spacing: 15) {
                Text("Total de Préstamos: \(totalLoansInProgress)")
                    .foregroundColor(.gray)
                    .font(.custom("AvenirNext-Regular", size: 22))
                    .offset(x: -10, y: 20) // Mueve el texto ligeramente para alinearlo con el icono
                NavigationLink(destination: ReportsView()) {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .font(.title2.bold())
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .offset(y: 10) // Baja el icono para alinearlo mejor
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
    
    private func loadLoans() {
        loanModels = DB_LoanManager().getLoans().sorted(by: { $0.idLoan < $1.idLoan })
        calculateTotalLoansInProgress()
    }
    
    private func calculateTotalLoansInProgress() {
        totalLoansInProgress = loanModels.filter { $0.health == "Préstamo" }.count
    }
    
    private func deleteLoan(loan: LoanModel) {
        DB_LoanManager().deleteLoan(idLoanValue: loan.idLoan)
        loanModels.removeAll { $0.idLoan == loan.idLoan }
        calculateTotalLoansInProgress()
    }
}

struct LoanListView_Previews: PreviewProvider {
    static var previews: some View {
        LoanListView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
