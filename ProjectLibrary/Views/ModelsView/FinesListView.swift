//
//  FinesListView.swift
//  ProjectLibrary
//
//  Created by Freddy Morales on 07/10/24.
//

import SwiftUI

struct FinesListView: View {
    @State private var finesModels: [FinesModel] = []
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.white
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("Lista de multas")
                        .font(.title.bold())
                        .padding(30)
                    
                        VStack{
                            List{
                                ForEach(self.finesModels.sorted(by: { $0.idFine < $1.idFine })) { fine in
                                        HStack{
                                            VStack{
                                                Text("ID: \(fine.idFine) - Id Prestamo: \(fine.idLoan)")
                                                            .font(.headline)
                                                            .foregroundColor(.blue)
//                                                        Text("Isbn: \(loan.isbn) - Estado: \(loan.health) - Fecha de prestamo: \(loan.loanDate)")
//                                                            .font(.subheadline)
//                                                            .foregroundColor(.gray)
                                                    }
                                                    Spacer()
                                            }
                                            .padding()
                                            .background(Color(.systemGray6))
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                
                                        }
                                    }
                                    .listStyle(InsetGroupedListStyle())
                                    .background(Color.white)
                                    //.navigationTitle("Lista de prestamos")
                                }
                                .onAppear(perform: {
                                    self.finesModels = DB_FinesManager().getFines().sorted(by: {$0.idFine < $1.idFine})
                                })
                            }
                        .padding(20)
                
                        NavigationLink(destination: ReportsView()) {
                            Image(systemName:"arrowshape.turn.up.right.fill")
                                .font(.title2.bold())
                                .frame(width: 30, height: 10)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(15)
                            }
                        .position(x: UISW * 0.95, y: UISH * 0.04)
                    }
                .preferredColorScheme(.light)
            }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
}

struct  FinesListview_Provider: PreviewProvider {
    static var previews: some View{
        FinesListView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
