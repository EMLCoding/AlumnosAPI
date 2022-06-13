//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent

final class Nivel: Model, Content {
    static let schema = "niveles"
    
    @ID(key: .id) var id: UUID?
    @Field(key: .nombre) var nombre: String
}
