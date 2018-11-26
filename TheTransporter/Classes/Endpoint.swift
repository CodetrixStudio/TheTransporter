//
//  Endpoint.swift
//  TheTransporter
//
//  Created by Parveen Khatkar on 05/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

public protocol EndpointProtocol {
    var apiUrl: URL {get};
    var segments: [Segment] {get}
}

extension EndpointProtocol {
    public func segmentOf(_ modelType: String, for controllerType: AnyClass? = nil, httpMethod: HttpMethod = .get) -> String {
        let controllerTypeName = controllerType != nil ? String(describing: controllerType!) : nil;
        
        let segment = segments.first(where: {
            $0.modelType == modelType && $0.controllerType == controllerTypeName && $0.httpMethods.contains(httpMethod)
        })
        
        if segment == nil {
            assert(true, "No endpoint found");
            return "";
        }
        
        return segment!.string;
    }
    
    public func segmentOf<E>(_ modelType: String, for controllerType: AnyClass? = nil, to action: E, httpMethod: HttpMethod = .get) -> String where E: RawRepresentable, E.RawValue == Int {
        let controllerTypeName = controllerType != nil ? String(describing: controllerType!) : nil;
        
        let segment = segments.first(where: {
            $0.modelType == modelType && $0.controllerType == controllerTypeName && $0.action == action.rawValue && $0.httpMethods.contains(httpMethod)
        })
        
        if segment == nil {
            assert(true, "No endpoint found");
            return "";
        }
        
        return segment!.string;
    }
    
    public func of(_ modelType: String, for controllerType: AnyClass? = nil, httpMethod: HttpMethod = .get) -> URL {
        let controllerTypeName = controllerType != nil ? String(describing: controllerType!) : nil;
        
        let segment = segments.first(where: {
            $0.modelType == modelType && $0.controllerType == controllerTypeName && $0.httpMethods.contains(httpMethod)
        })
        
        if segment == nil {
            assert(true, "No endpoint found");
            return URL(string: "")!
        }
        
        return URL(string: segment!.string, relativeTo: apiUrl)!
    }
    
    public func of<E: RawRepresentable>(_ modelType: String, for controllerType: AnyClass? = nil, to action: E, httpMethod: HttpMethod = .get) -> URL where E.RawValue == Int {
        let controllerTypeName = controllerType != nil ? String(describing: controllerType!) : nil;
        
        let segment = segments.first(where: {
            $0.modelType == modelType && $0.controllerType == controllerTypeName && $0.action == action.rawValue && $0.httpMethods.contains(httpMethod)
        })
        
        if segment == nil {
            assert(true, "No endpoint found");
            return URL(string: "")!
        }
        
        return URL(string: segment!.string, relativeTo: apiUrl)!
    }
}

public extension Decodable {
    static var typeName: String {
        return String(describing: self);
    }
}

public extension NSObject {
    static var typeName: String {
        return String(describing: self);
    }
}

extension URLComponents {
    public mutating func appendQuery<T>(name: String, value: T?) where T : LosslessStringConvertible {
        guard let value = value else {return}
        
        if queryItems == nil {
            queryItems = [];
        }
        
        let urlQueryItem = URLQueryItem(name: name, value: String(value));
        queryItems?.append(urlQueryItem);
    }
}
