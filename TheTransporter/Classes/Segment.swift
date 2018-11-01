//
//  Segment.swift
//  TheTransporter
//
//  Created by Parveen Khatkar on 15/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

public class Segment {
    var string: String!
    var modelType: String!
    var controllerType: String?
    var action: Int?
    var httpMethods: [HttpMethod]
    
    public init(_ string: String, modelType: String, controllerType: String? = nil, httpMethods: [HttpMethod] = [.get]) {
        self.string = string;
        self.modelType = modelType;
        self.controllerType = controllerType;
        self.httpMethods = httpMethods;
    }
    
    public init<E: RawRepresentable>(_ string: String, modelType: String, controllerType: String? = nil, action: E? = nil, httpMethods: [HttpMethod] = [.get]) where E.RawValue == Int {
        self.string = string;
        self.modelType = modelType;
        self.controllerType = controllerType;
        self.action = action?.rawValue;
        self.httpMethods = httpMethods;
    }
}
