//
//  AddBookView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//
import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var isbn: String = ""
    @State private var nameBook: String = ""
    @State private var author: String = ""
    @State private var editorial: String = ""
    @State private var edition: String = ""
    @State private var category: String = ""
    @State private var numberBooks: String = ""
    
    @State private var showPopup = false
    @State private var popupMessage = ""
    @State private var popupSuccess = false
    
    @State private var isSelected = false
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    let categories: [String] = ["Educativo", "Ficción", "Fantasia", "Libros Ilustrados"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo degradado
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 150) // Añadir espacio adicional arriba del contenido
                    
                    ScrollView {
                        VStack(alignment: .center, spacing: 20) {
                            Text("Agregar nuevos libros")
                                .font(.custom("Avenir Next", size: 36)) // Fuente estilizada para el título
                                .foregroundColor(.black)
                            
                            VStack(spacing: 20) {
                                HStack {
                                    TextField("Ingresa el nombre del libro", text: $nameBook)
                                        .padding(15)
                                        .frame(width: 500)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(5)
                                        .font(.custom("Avenir Next", size: 30))
                                        .disableAutocorrection(true)
                                        .onChange(of: nameBook) { newValue in
                                            self.nameBook = newValue.capitalized
                                        }
                                    
                                    TextField("Ingresa el autor", text: $author)
                                        .padding(15)
                                        .frame(width: 500)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(5)
                                        .font(.custom("Avenir Next", size: 30))
                                        .disableAutocorrection(true)
                                        .onChange(of: author) { newValue in
                                            self.author = newValue.capitalized
                                        }
                                }
                                
                                HStack {
                                    TextField("Ingresa la editorial", text: $editorial)
                                        .padding(15)
                                        .frame(width: 500)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(5)
                                        .font(.custom("Avenir Next", size: 30))
                                        .disableAutocorrection(true)
                                        .onChange(of: editorial) { newValue in
                                            self.editorial = newValue.capitalized
                                        }
                                    
                                    TextField("Ingresa el ISBN", text: $isbn)
                                        .keyboardType(.numberPad)
                                        .padding(15)
                                        .frame(width: 500)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(5)
                                        .font(.custom("Avenir Next", size: 30))
                                        .disableAutocorrection(true)
                                }
                                
                                HStack {
                                    TextField("Ingresa el año de la edición", text: $edition)
                                        .keyboardType(.numberPad)
                                        .padding(15)
                                        .frame(width: 500)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(5)
                                        .font(.custom("Avenir Next", size: 30))
                                        .disableAutocorrection(true)
                                    
                                    TextField("Ingresa la cantidad de libros", text: $numberBooks)
                                        .keyboardType(.numberPad)
                                        .padding(15)
                                        .frame(width: 500)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(5)
                                        .font(.custom("Avenir Next", size: 30))
                                        .disableAutocorrection(true)
                                }
                                
                                VStack(alignment: .center, spacing: 10) {
                                    HStack {
                                        Text("Selecciona una categoría del libro: ")
                                        Text(category)
                                    }
                                    .cornerRadius(10)
                                    .font(.title)
                                    
                                    Picker("", selection: $category) {
                                        ForEach(categories, id: \.self) { category in
                                            Text(category).tag(category)
                                                .font(.title.bold())
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(height: 170)
                                }
                                
                                Button(action: {
                                    handleBookAction()
                                }, label: {
                                    Text("Guardar Libro")
                                        .padding()
                                        .background(Color.purple.opacity(0.8)) // Botón en color púrpura
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .font(.custom("Avenir Next", size: 30))
                                })
                                .padding(.top)
                            }
                            .padding(20)
                        }
                    }
                    
                    Spacer() // Añade espacio debajo del contenido
                }
                
                NavigationLink(destination: BookListView()) {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .font(.title2.bold())
                        .frame(width: 30, height: 10)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(15)
                }
                .position(x: UISW * 0.95, y: UISH * 0.04)
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
                }
            )
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .preferredColorScheme(.light)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
    
    // Función para manejar la validación y agregar el libro
    func handleBookAction() {
        if isbn.isEmpty || nameBook.isEmpty || author.isEmpty || editorial.isEmpty || edition.isEmpty || numberBooks.isEmpty {
            popupMessage = "Por favor, complete todos los campos."
            popupSuccess = false
            showPopup = true
        } else {
            let dbManager = DB_BookManager()
            if dbManager.isISBNRegistered(isbnValue: Int64(self.isbn) ?? 0) {
                popupMessage = "El ISBN ya está registrado."
                popupSuccess = false
                showPopup = true
            } else {
                dbManager.addBook(
                    isbnValue: Int64(self.isbn) ?? 0,
                    nameValue: self.nameBook,
                    authorValue: self.author,
                    editorialValue: self.editorial,
                    editionValue: Int64(self.edition) ?? 0,
                    categoryValue: self.category,
                    numberBookValue: Int64(self.numberBooks) ?? 0
                )
                
                self.isbn = ""
                self.nameBook = ""
                self.author = ""
                self.editorial = ""
                self.edition = ""
                self.category = ""
                self.numberBooks = ""
                
                popupMessage = "Libro agregado correctamente."
                popupSuccess = true
                showPopup = true
            }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
