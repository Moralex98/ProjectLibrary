//
//  BookListView.swift
//  ProjectLibrary
//
//  Created by Freddy Morales on 21/10/24.
//
import SwiftUI

struct BookListView: View  {
    @State private var bookModels: [BooksModel] = []
    @State private var isEditing: Bool = false
    @State private var selectedBook: Int64 = 0
        
    var categories: [String] = ["Cuentos de Animales", "Educativo", "Ficción", "Fantasia", "Libros Ilustrados"]
    
    var totalBooks: Int {
        bookModels.count
    }
        
    var body: some View {
        NavigationView {
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(destination: EditBookView(isbn: self.$selectedBook), isActive: self.$isEditing) {
                        EmptyView()
                    }
                    
                    List {
                        ForEach(categories, id: \.self) { category in
                            Section(header: Text(category).font(.headline).padding()) {
                                ForEach(filteredBooks(for: category).sorted(by: { $0.nameBook < $1.nameBook }), id: \.isbn) { book in
                                    HStack {
                                        NavigationLink(destination: BookDetailView(book: book)) {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text("Nombre del libro: \(book.nameBook)")
                                                        .font(.headline)
                                                        .foregroundColor(.blue)
                                                    Text("ISBN: \(book.isbn)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                        }
                                        .background(Color(.systemGray6)) // Fondo gris claro para cada libro
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                        .listRowBackground(Color.white) // Fondo blanco para la fila
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            let dbBookManager: DB_BookManager = DB_BookManager()
                                            dbBookManager.deleteBook(isbnValue: book.isbn)
                                            self.bookModels = dbBookManager.getBooks() // Actualizar lista
                                        } label: {
                                            Label("Eliminar", systemImage: "trash.fill")
                                        }
                                        .tint(.red)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            self.selectedBook = book.isbn
                                            self.isEditing = true
                                        } label: {
                                            Label("Editar", systemImage: "pencil")
                                        }
                                        .tint(.orange)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .background(Color.white)
                    .navigationTitle("Lista de Libros")
                    .navigationBarItems(trailing: HStack {
                        Text("Total: \(totalBooks) libros")
                            .foregroundColor(.gray)
                        NavigationLink(destination: AddBookView()) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                        }
                    })
                }
                .onAppear(perform: {
                    self.bookModels = DB_BookManager().getBooks() // Obtener todos los libros
                })
            }
            .preferredColorScheme(.light)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
    
    private func filteredBooks(for category: String) -> [BooksModel] {
        return bookModels.filter { $0.category == category }
    }
}

struct BookDetailView: View {
    var book: BooksModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Nombre: \(book.nameBook)")
                .font(.title.bold())
            Text("ISBN: \(book.isbn)")
                .font(.title.bold())
            Text("Autor: \(book.author)")
                .font(.title.bold())
            Text("Editorial: \(book.editorial)")
                .font(.title.bold())
            Text("Edition: \(book.edition)")
                .font(.title.bold())
            Text("Categoría: \(book.category)")
                .font(.title.bold())
            Text("Cantidad de libros: \(book.numberBooks)")
                .font(.title.bold())
            Spacer()
        }
        .padding()
        .navigationTitle("Detalles del Libro")
        
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
