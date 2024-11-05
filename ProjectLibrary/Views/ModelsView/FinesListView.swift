//
//  FinesListView.swift
//  ProjectLibrary
//
//  Created by Freddy Morales on 07/10/24.
//

import SwiftUI

struct FinesListView: View {
    @State private var finesModels: [FinesModel] = []
    @State private var totalPaidFines: Int64 = 0 // Total de dinero de multas pagadas
    @State private var showReportsView = false // Estado para controlar la navegación
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    let loanManager = DB_LoanManager() // Instancia de DB_LoanManager para acceder a updateOverdueFinesForAllLoans
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo degradado
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    VStack (alignment: .leading){
                        List {
                            ForEach(self.finesModels.sorted(by: { $0.idFine < $1.idFine })) { fine in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("ID: \(fine.idFine) - Id Préstamo: \(fine.idLoan)")
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteFine(fine: fine)
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
                        loadFines()
                    }
                }
                .preferredColorScheme(.light)
            }
            .navigationTitle("Lista de Multas")
            .font(.custom("AvenirNext-Bold", size: 28))
            .navigationBarItems(trailing: HStack(spacing: 15) { //Usamos VStack para manejar el posicionamiento vertical
                HStack {
                    Text("Total Pagado: \(totalPaidFines) pesos")
                        .font(.custom("AvenirNext-Regular", size: 20))
                        .foregroundColor(.black)
                    
                    // Botón que activa la navegación a ReportsView
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
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
    
    private func loadFines() {
        // Verificar y actualizar multas para préstamos con atraso antes de cargar la lista de multas
        loanManager.updateOverdueFinesForAllLoans()
        
        // Luego cargar las multas actualizadas
        finesModels = DB_FinesManager().getFines().sorted(by: { $0.idFine < $1.idFine })
        calculateTotalPaidFines() // Calcula el total de multas pagadas
    }
    
    private func calculateTotalPaidFines() {
        totalPaidFines = finesModels
            .filter { $0.status == "PAGADO" }
            .reduce(0) { $0 + $1.payments }
    }
    
    private func deleteFine(fine: FinesModel) {
        DB_FinesManager().deleteFine(idFine: fine.idFine)
        finesModels.removeAll { $0.idFine == fine.idFine }
        calculateTotalPaidFines() // Recalcula el total después de eliminar una multa
    }
}


struct FinesListView_Previews: PreviewProvider {
    static var previews: some View {
        FinesListView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
