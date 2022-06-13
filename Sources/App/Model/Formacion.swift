//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent
import Foundation

final class Formacion: Model, Content {
    static let schema = "formaciones"
    
    @ID(key: .id) var id:UUID?
    @Field(key: .nombre) var nombre: String
    @Field(key: .duracion) var duracion: Int
    @Field(key: .fechaInicio) var fechaInicio: Date
    @Parent(key: .nivel) var nivel: Nivel
    @Siblings(through: FormacionesAlumnos.self, from: \.$formacion, to: \.$alumno) var alumnos:[Alumno]
}
