//
//  BooksModel.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import Foundation

class BooksModel:Identifiable {
    public var isbn: Int64 = 0
    public var nameBook: String = ""
    public var author: String = ""
    public var editorial: String = ""
    public var edition: Int64 = 0
    public var category: String = ""
    public var numberBooks: Int64 = 0
}
