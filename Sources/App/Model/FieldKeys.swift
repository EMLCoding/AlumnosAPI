//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import FluentKit

extension FieldKey {
    static let direccion = FieldKey("direccion")
    static let contacto = FieldKey("contacto")
    static let nombre = FieldKey("nombre")
    static let apellidos = FieldKey("apellidos")
    static let nacimiento = FieldKey("nacimiento")
    static let empresa = FieldKey("empresa")
    static let nivel = FieldKey("nivel")
    static let duracion = FieldKey("duracion")
    static let fechaInicio = FieldKey("fecha_inicio")
    static let alumnoID = FieldKey("alumno_id")
    static let formacionID = FieldKey("formacion_id")
}
