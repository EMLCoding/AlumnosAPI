//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent

final class Empresa:Model, Content {
    static let schema = "empresas"
    
    @ID(key: .id) var id: UUID?
    @Field(key: .direccion) var direccion: String
    @Field(key: .contacto) var contacto: String
    
    @Children(for: \.$empresa) var alumnosEmpresa:[Alumno]
}
