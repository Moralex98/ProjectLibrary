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
            .navigationBarItems(trailing: HStack {
                Text("Total Pagado: \(totalPaidFines) pesos")
                    .foregroundColor(.gray)
                NavigationLink(destination: ReportsView()) { // Puedes cambiar `AddFineView` al destino que prefieras
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
    
    private func loadFines() {
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
