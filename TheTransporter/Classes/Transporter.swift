//
//  Transporter.swift
//  TheTransporter
//
//  Created by Parveen Khatkar on 05/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

open class Transporter {
    public lazy var headers = [String: String]();
    
    public lazy var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder();
        jsonDecoder.dataDecodingStrategy = .deferredToData;
        return jsonDecoder;
    }()
    
    public typealias CompletionBlock<T> = (T?) -> Void
    public typealias EmptyCompletionBlock = (Bool?) -> Void
    
    public private(set) var endpoint: EndpointProtocol!

    public init() {
    }
    
    public func set(endpoint: EndpointProtocol) {
        self.endpoint = endpoint;
    }
    
    public func getUrl<T>(_ modelType: T.Type, for controllerType: AnyClass? = nil, httpMethod: HttpMethod, pathVars: PathVars? = nil, queryParams: QueryParams? = nil) -> URL where T: Codable {
        var segment = endpoint.segmentOf(modelType.typeName, for: controllerType, httpMethod: httpMethod);
        
        if let pathVars = pathVars {
            segment = String(format: segment, arguments: pathVars.vars.map({String(describing: $0)}));
        }
        
        var urlComponents = URLComponents(string: endpoint.apiUrl.absoluteString + "/" + segment)!
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = [];
        }
        
        let queries = try! queryParams?.toDictionary();
        queries?.forEach({urlComponents.appendQuery(name: $0.key, value: String(describing: $0.value))});
        
        return urlComponents.url!
    }
    
    public func getUrl<T, E>(_ modelType: T.Type, for controllerType: AnyClass? = nil, to action: E, httpMethod: HttpMethod, pathVars: PathVars? = nil, queryParams: QueryParams? = nil) -> URL where T: Codable, E: RawRepresentable, E.RawValue == Int  {
        var segment = endpoint.segmentOf(modelType.typeName, for: controllerType, to: action, httpMethod: httpMethod);
        if let pathVars = pathVars {
            segment = String(format: segment, arguments: pathVars.vars.map({String(describing: $0)}));
        }
        
        var urlComponents = URLComponents(string: endpoint.apiUrl.absoluteString + "/" + segment)!
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = [];
        }
        
        let queries = try! queryParams?.toDictionary();
        queries?.forEach({urlComponents.appendQuery(name: $0.key, value: String(describing: $0.value))});
        
        return urlComponents.url!
    }
    
    // MARK: GET
    
    @discardableResult
    public func get<T>(_ modelType: T.Type, for controllerType: AnyClass? = nil, pathVars: PathVars? = nil, queryParams: QueryParams? = nil, completionHandler: @escaping CompletionBlock<T>) -> URLSessionTask where T: Codable {
        let url = getUrl(modelType, for: controllerType, httpMethod: .get, pathVars: pathVars, queryParams: queryParams);
        let request = URLRequest(url: url);
        return executeRequest(request, completionHandler: completionHandler);
    }
    
    // MARK: POST
    
    @discardableResult
    public func post<T>(_ model: T, for controllerType: AnyClass? = nil, pathVars: PathVars? = nil, queryParams: QueryParams? = nil, completionHandler: @escaping EmptyCompletionBlock) -> URLSessionTask where T: Codable {
        let url = getUrl(T.self, for: controllerType, httpMethod: .post, pathVars: pathVars, queryParams: queryParams);
        return postToURL(url, model: model, completionHandler: completionHandler);
    }

    @discardableResult
    public func post<T, R>(_ model: T, returnType: R.Type, for controllerType: AnyClass? = nil, pathVars: PathVars? = nil, queryParams: QueryParams? = nil, completionHandler: @escaping CompletionBlock<R>) -> URLSessionTask where T: Codable, R: Decodable {
        let url = getUrl(T.self, for: controllerType, httpMethod: .post, pathVars: pathVars, queryParams: queryParams);
        return postToURL(url, model: model, completionHandler: completionHandler);
    }
    
    @discardableResult
    public func post<T, E>(_ model: T, for controllerType: AnyClass? = nil, to action: E, pathVars: PathVars? = nil, queryParams: QueryParams? = nil, completionHandler: @escaping EmptyCompletionBlock) -> URLSessionTask where T: Codable, E: RawRepresentable, E.RawValue == Int {
        let url = getUrl(T.self, for: controllerType, to: action, httpMethod: .post, pathVars: pathVars, queryParams: queryParams);
        return postToURL(url, model: model, completionHandler: completionHandler);
    }
    
    @discardableResult
    public func post<T, E, R>(_ model: T, returnType: R.Type, for controllerType: AnyClass? = nil, to action: E, pathVars: PathVars? = nil, queryParams: QueryParams? = nil, completionHandler: @escaping CompletionBlock<R>) -> URLSessionTask where T: Codable, E: RawRepresentable, E.RawValue == Int, R: Decodable {
        let url = getUrl(T.self, for: controllerType, to: action, httpMethod: .post, pathVars: pathVars, queryParams: queryParams);
        return postToURL(url, model: model, completionHandler: completionHandler);
    }

    private func postToURL<T>(_ url: URL, model: Codable, completionHandler: @escaping CompletionBlock<T>) -> URLSessionTask where T: Decodable {
        var request = URLRequest(url: url);
        request.httpMethod = HttpMethod.post.rawValue;
        request.httpBody = try! model.toData();
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return executeRequest(request, completionHandler: completionHandler);
    }
    
    //MARK: PUT
    
    @discardableResult
    public func put<T>(_ model: T, for controllerType: AnyClass? = nil, pathVars: PathVars? = nil, queryParams: QueryParams? = nil, completionHandler: @escaping EmptyCompletionBlock) -> URLSessionTask where T: Codable {
        let url = getUrl(T.self, for: controllerType, httpMethod: .put, pathVars: pathVars, queryParams: queryParams);
        
        var request = URLRequest(url: url);
        request.httpMethod = HttpMethod.put.rawValue;
        request.httpBody = try! model.toData();
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        return executeRequest(request, completionHandler: completionHandler);
    }
    
    @discardableResult
    public func put<T, R>(_ model: T, returnType: R.Type, for controllerType: AnyClass? = nil, pathVars: PathVars? = nil, queryParams: QueryParams? = nil, completionHandler: @escaping CompletionBlock<R>) -> URLSessionTask where T: Codable, R: Decodable {
        let url = getUrl(T.self, for: controllerType, httpMethod: .put, pathVars: pathVars, queryParams: queryParams);
        
        var request = URLRequest(url: url);
        request.httpMethod = HttpMethod.put.rawValue;
        request.httpBody = try! model.toData();
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        return executeRequest(request, completionHandler: completionHandler);
    }
    
    //MARK: DELETE
    
    @discardableResult
    public func delete<T>(_ modelType: T.Type, for controllerType: AnyClass? = nil, pathVars: PathVars? = nil, queryParams: QueryParams? = nil, completionHandler: @escaping EmptyCompletionBlock) -> URLSessionTask where T: Codable {
        let url = getUrl(modelType, for: controllerType, httpMethod: .delete, pathVars: pathVars, queryParams: queryParams);
        
        var request = URLRequest(url: url);
        request.httpMethod = HttpMethod.delete.rawValue;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        return executeRequest(request, completionHandler: completionHandler);
    }
    
    @discardableResult
    public func delete<T, R>(_ modelType: T.Type, returnType: R.Type, for controllerType: AnyClass? = nil, pathVars: PathVars? = nil, queryParams: QueryParams? = nil, completionHandler: @escaping CompletionBlock<R>) -> URLSessionTask where T: Codable, R: Decodable {
        let url = getUrl(modelType, for: controllerType, httpMethod: .delete, pathVars: pathVars, queryParams: queryParams);
        
        var request = URLRequest(url: url);
        request.httpMethod = HttpMethod.delete.rawValue;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        return executeRequest(request, completionHandler: completionHandler);
    }
    
    // MARK: Execution
    
    @discardableResult
    public func executeRequest<T>(_ request: URLRequest, completionHandler: @escaping CompletionBlock<T>) -> URLSessionTask where T: Decodable {
        var request = request;
        headers.forEach({request.addValue($0.value, forHTTPHeaderField: $0.key)});
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            self.handleResponse(forRequest: request, data: data, response: response, error: error, completionHandler: completionHandler);
        })

        task.resume();
        return task;
    }
    
    open func handleResponse<T>(forRequest request: URLRequest, data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping CompletionBlock<T>) where T: Decodable {
        #if DEBUG
        print("\n\n\n");
        print("url:", request.url!.absoluteString, "\nresponse:", data != nil ? String(bytes: data!, encoding: .utf8)! : " response is nil");
        #endif
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            DispatchQueue.main.sync {
                completionHandler(false as? T);
            }
            return;
        }
        if let object: T = try! true as? T ?? data?.convert(jsonDecoder: self.jsonDecoder) {
            DispatchQueue.main.sync {
                completionHandler(object);
            }
        }
    }
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
