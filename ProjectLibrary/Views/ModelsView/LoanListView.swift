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
                Color.white
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
                                .background(Color(.systemGray6))
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
                        .background(Color.white)
                    }
                    .padding(20)
                    .onAppear {
                        loadLoans()
                    }
                }
                .preferredColorScheme(.light)
            }
            .navigationTitle("Lista de Préstamos")
            .navigationBarItems(trailing: HStack {
                Text("Total de Préstamos: \(totalLoansInProgress)")
                    .foregroundColor(.gray)
                NavigationLink(destination: ReportsView()) { // Cambia `AddLoanView` al destino que prefieras
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .font(.title2.bold())
                        .frame(width: 30, height: 10)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
    
    private func loadLoans() {
        loanModels = DB_LoanManager().getLoans().sorted(by: { $0.idLoan < $1.idLoan })
        calculateTotalLoansInProgress() // Calcula el total de préstamos en progreso
    }
    
    private func calculateTotalLoansInProgress() {
        totalLoansInProgress = loanModels.filter { $0.health == "Préstamo" }.count
    }
    
    private func deleteLoan(loan: LoanModel) {
        DB_LoanManager().deleteLoan(idLoanValue: loan.idLoan)
        loanModels.removeAll { $0.idLoan == loan.idLoan }
        calculateTotalLoansInProgress() // Recalcula el total después de eliminar un préstamo
    }
}

struct LoanListView_Previews: PreviewProvider {
    static var previews: some View {
        LoanListView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
