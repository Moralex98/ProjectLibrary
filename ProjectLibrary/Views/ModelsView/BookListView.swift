//
//  BookListView.swift
//  ProjectLibrary
//
//  Created by Freddy Morales on 21/10/24.
//
import SwiftUI

struct BookListView: View {
    @State private var bookModels: [BooksModel] = []
    @State private var isEditing: Bool = false
    @State private var selectedBook: Int64 = 0
    @State private var searchText: String = ""

    var categories: [String] = ["Educativo", "Ficción", "Fantasia", "Libros Ilustrados"]

    var totalBooks: Int {
        bookModels.count
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Fondo degradado
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Lista de Libros")
                        .font(.custom("AvenirNext-Bold", size: 35))
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    TextField("Buscar libro por nombre, ISBN o autor...", text: $searchText)
                        .padding(10)
                        .font(.custom("AvenirNext-Regular", size: 18))
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onChange(of: searchText) { _ in
                            self.bookModels = DB_BookManager().getBooks()
                        }
                    
                    VStack(spacing: 10) {
                        List {
                            if searchText.isEmpty {
                                // Mostrar libros por categoría si no hay texto de búsqueda
                                ForEach(categories, id: \.self) { category in
                                    Section(header: Text(category)
                                        .font(.custom("AvenirNext-Bold", size: 18))
                                        .foregroundColor(.blue)
                                        .padding(.vertical)) {
                                            ForEach(filteredBooks(forCategory: category).sorted(by: { $0.nameBook < $1.nameBook }), id: \.isbn) { book in
                                                BookRowView(book: book, isEditing: $isEditing, selectedBook: $selectedBook, refreshList: {
                                                    self.bookModels = DB_BookManager().getBooks()
                                                })
                                            }
                                        }
                                }
                            } else {
                                // Mostrar resultados de búsqueda sin filtrar por categoría
                                ForEach(filteredBooksBySearchText().sorted(by: { $0.nameBook < $1.nameBook }), id: \.isbn) { book in
                                    BookRowView(book: book, isEditing: $isEditing, selectedBook: $selectedBook, refreshList: {
                                        self.bookModels = DB_BookManager().getBooks()
                                    })
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .background(Color.clear)
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
                }
                .onAppear {
                    self.bookModels = DB_BookManager().getBooks()
                }
            }
            .preferredColorScheme(.light)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }

    private func filteredBooks(forCategory category: String) -> [BooksModel] {
        return bookModels
            .filter { $0.category == category }
    }
    
    private func filteredBooksBySearchText() -> [BooksModel] {
        return bookModels
            .filter {
                searchText.isEmpty ||
                $0.nameBook.localizedCaseInsensitiveContains(searchText) ||   // Filtra por nombre
                $0.author.localizedCaseInsensitiveContains(searchText) ||      // Filtra por autor
                String($0.isbn).contains(searchText)                           // Filtra por ISBN
            }
    }
}

// Vista auxiliar para representar cada libro en la lista
struct BookRowView: View {
    var book: BooksModel
    @Binding var isEditing: Bool
    @Binding var selectedBook: Int64
    var refreshList: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Nombre del libro: \(book.nameBook) - ISBN: \(book.isbn) - Autor: \(book.author)")
                    .font(.headline)
                    .foregroundColor(.blue)
                Text("Editorial: \(book.editorial) - Edición: \(book.edition) - Cantidad: \(book.numberBooks)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
        .listRowBackground(Color.white)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                let dbBookManager = DB_BookManager()
                dbBookManager.deleteBook(isbnValue: book.isbn)
                refreshList() // Actualizar lista
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

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
