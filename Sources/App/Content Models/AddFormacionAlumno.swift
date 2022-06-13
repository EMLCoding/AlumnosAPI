//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 4/6/22.
//

import Vapor

struct AddFormacionAlumnos: Content {
    let formacionID: UUID
    let alumnos: [Int]
}
