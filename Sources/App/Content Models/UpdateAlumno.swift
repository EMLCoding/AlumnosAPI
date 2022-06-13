//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 4/6/22.
//

import Vapor

struct UpdateAlumno: Content {
    let nombre: String?
    let apellidos: String?
    let nacimiento: Date?
    let empresa: UUID?
}
