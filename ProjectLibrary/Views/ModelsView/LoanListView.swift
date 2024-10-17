//
//  LoanListView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 18/09/24.
//

import SwiftUI

struct LoanListView: View {
    @State private var loanModels: [LoanModel] = []
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.white
                    .ignoresSafeArea()
               
                
                VStack(alignment: .leading) {
                    Text("Lista de Prestamos")
                        .font(.title.bold())
                        .padding(30)
                    VStack{
                        List{
                            ForEach(self.loanModels.sorted(by: { $0.idLoan < $1.idLoan })) { loan in
                                HStack{
                                    VStack{
                                        Text("ID: \(loan.idLoan) - Matricula: \(loan.idStudent)")
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                        Text("Isbn: \(loan.isbn) - Estado: \(loan.health) - Fecha de prestamo: \(loan.loanDate)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
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
                        self.loanModels = DB_LoanManager().getLoans().sorted(by: {$0.idLoan < $1.idLoan})
                    })
                }
                .padding(20)
                
                NavigationLink(destination: ReportsView()) {
                    Image(systemName: "arrowshape.turn.up.right.fill")
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

struct LoanListView_Previews: PreviewProvider{
    static var previews: some View{
        LoanListView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
