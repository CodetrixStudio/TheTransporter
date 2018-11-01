//
//  CodableExtensions.swift
//  TheTransporter
//
//  Created by Parveen Khatkar on 01/11/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

extension Encodable {
    func toData() throws -> Data {
        let jsonEncoder = JSONEncoder();
        let data = try jsonEncoder.encode(self);
        return data;
    }
    
    func toDictionary() throws -> [String: Any] {
        let data = try self.toData();
        let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any];
        return dictionary;
    }
}
