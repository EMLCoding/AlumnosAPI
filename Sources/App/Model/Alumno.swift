//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent

final class Alumno: Model, Content {
    static let schema = "alumnos"
    
    @ID(custom: .id) var id: Int?
    @Field(key: .nombre) var nombre: String
    @Field(key: .apellidos) var apellidos: String
    @Field(key: .nacimiento) var nacimiento: Date?
    @Parent(key: .empresa) var empresa: Empresa
    @Siblings(through: FormacionesAlumnos.self, from: \.$alumno, to: \.$formacion) var formaciones: [Formacion]
}
