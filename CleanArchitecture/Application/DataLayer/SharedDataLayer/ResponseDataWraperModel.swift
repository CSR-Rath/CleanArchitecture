//
//  ResponseDataWraperModel.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/7/26.
//

import Foundation

struct ResponseDataWraperModel<T: Codable>: Codable {
    let data: T?
}
