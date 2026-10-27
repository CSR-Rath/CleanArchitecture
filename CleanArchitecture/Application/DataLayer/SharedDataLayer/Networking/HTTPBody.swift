//
//  HTTPBody.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/27/26.
//

import Foundation

enum HTTPBody {
    case parameters(Parameters)
    case encodable(Encodable)
    
    /// Encodes the body into `Data` and determines the corresponding `Content-Type` header.
    func encode() throws -> (data: Data, contentType: String) {
        switch self {
        case .parameters(let params):
            guard JSONSerialization.isValidJSONObject(params) else {
                throw NetworkError.invalidRequestBody
            }
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            return (data, "application/json; charset=UTF-8")
            
        case .encodable(let encodable):
            // Type eraser wrapper to encode existential Encodable
            let data = try JSONEncoder().encode(AnyEncodable(encodable))
            return (data, "application/json; charset=UTF-8")
        }
    }
}


private struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        self._encode = encodable.encode
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
