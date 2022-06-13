//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent

final class FormacionesAlumnos: Model {
    static let schema = "formaciones+alumnos"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: .alumnoID) var alumno: Alumno
    @Parent(key: .formacionID) var formacion: Formacion
}
