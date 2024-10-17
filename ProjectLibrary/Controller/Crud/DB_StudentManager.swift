//
//  DB_StudentManager.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import Foundation
import SQLite
 
class DB_StudentManager {
    private let db: Connection
        
        // Tablas
        private let students: Table
        
        // Columnas para la tabla de estudiantes
        private let idStudent: Expression<Int64>
        private let name: Expression<String>
        private let lastName: Expression<String>
        private let grade: Expression<Int64>
        private let group: Expression<String>
        private let phoneNumber: Expression<Int64>
    
    init() {
            // Usa la conexión compartida desde DBConnectionManager
            db = DBManager.shared.getConnection()
            
            // Inicializa las tablas y columnas
            students = Table("students")
            idStudent = Expression<Int64>("id")
            name = Expression<String>("name")
            lastName = Expression<String>("last_name")
            grade = Expression<Int64>("grade")
            group = Expression<String>("group")
            phoneNumber = Expression<Int64>("phone_number")
            
            // Crea las tablas si no existen
            do {
                try createTablesIfNeeded()
            } catch {
                print("Error al crear las tablas: \(error.localizedDescription)")
            }
        }
        
        private func createTablesIfNeeded() throws {
            // Crea la tabla de estudiantes si no existe
            try db.run(students.create(ifNotExists: true) { t in
                t.column(idStudent, primaryKey: true)
                t.column(name)
                t.column(lastName)
                t.column(grade)
                t.column(group)
                t.column(phoneNumber)
            })
            
        }

    // Método para verificar si un Alumno NO está registrado
    public func isIdStudentNotRegistered(idStudentValue: Int64) -> Bool {
        do {
            // Filtrar por el ID de estudiante
            let student = try db.pluck(students.filter(idStudent == idStudentValue))
            
            // Si student es nil, significa que no está registrado
            return student == nil
        } catch {
            print("Error al verificar si el estudiante está registrado: \(error.localizedDescription)")
            return true // En caso de error, asumimos que no está registrado
        }
    }
    
    //funcion para añadir estudiantes
    public func addStudent(nameValue: String, lastNameValue: String, gradeValue: Int64, groupValue: String, phoneNumberValue: Int64) {
        do {
            // Inserción en la tabla de estudiantes
            try db.run(students.insert(name <- nameValue, lastName <- lastNameValue, grade <- gradeValue, group <- groupValue, phoneNumber <- phoneNumberValue))
            print("Estudiante agregado exitosamente: \(nameValue) \(lastNameValue)")
        } catch {
            print("Error al agregar estudiante: \(error.localizedDescription)")
        }
    }

    
    // rfunction read
    public func getStudents() -> [StudentModel] {
        var studentModels: [StudentModel] = []
        
        do {
            // Loop a través de todos los usuarios
            for student in try db.prepare(students.order(idStudent.desc)) {
                let studentModel = StudentModel()
                studentModel.idStudent = student[idStudent]
                studentModel.name = student[name]
                studentModel.lastName = student[lastName]
                studentModel.grade = student[grade]
                studentModel.group = student[group]
                studentModel.phoneNumber = student[phoneNumber]
                
                print("Student: \(studentModel.idStudent), \(studentModel.name), \(studentModel.lastName), \(studentModel.grade), \(studentModel.group), \(studentModel.phoneNumber)")
                
                studentModels.append(studentModel)
            }
            print("Total estudiantes recuperados: \(studentModels.count)")
        } catch {
            print("Error al obtener estudiantes: \(error.localizedDescription)")
        }
        
        return studentModels
    }
    //get single student data
    public func getStudent(idValue: Int64) -> StudentModel? {
        // create an empty object
        let studentModel: StudentModel = StudentModel()
                
        //exception handling
               do {
                   //get student using id
                   let student: AnySequence<Row> = try db.prepare(students.filter(idStudent == idValue))
                   
                   // get row
                   try student.forEach({ (rowValue) in
                       //set values in model
                       studentModel.idStudent = try rowValue.get(idStudent)
                       studentModel.name = try rowValue.get(name)
                       studentModel.lastName = try rowValue.get(lastName)
                       studentModel.grade = try rowValue.get(grade)
                       studentModel.group = try rowValue.get(group)
                       studentModel.phoneNumber = try rowValue.get(phoneNumber)
                   })
        } catch {
            print("Error retrieving student: \(error.localizedDescription)")
            return nil
        }
        return studentModel
    }
    //function to update student
    public func updateStudent(idValue: Int64, nameValue: String, lastNameValue: String, gradeValue: Int64, groupValue: String, phoneNumberValue: Int64) {
        do {
            //get user using ID
            let student: Table = students.filter(idStudent == idValue)
            
            //run the update query
            try db.run(students.update(name <- nameValue, lastName <- lastNameValue, grade <- gradeValue, group <- groupValue, phoneNumber <- phoneNumberValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    //function delete
    public func deleteStudent(idValue: Int64) {
        do {
            //get user ID
            let student: Table = students.filter(idStudent == idValue)
            
            // run the delete query
            try db.run(student.delete())
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
