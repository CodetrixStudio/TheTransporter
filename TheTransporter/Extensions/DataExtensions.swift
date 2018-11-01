//
//  DataExtensions.swift
//  TheTransporter
//
//  Created by Parveen Khatkar on 01/11/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

extension Data {
    func convert<T>(_ type: T.Type = T.self) throws -> T where T: Decodable {
        let data = self;
        let jsonDecoder = JSONDecoder();
        let object = try jsonDecoder.decode(type, from: data);
        return object;
    }
}
