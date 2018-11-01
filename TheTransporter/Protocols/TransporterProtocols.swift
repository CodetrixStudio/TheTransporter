//
//  TransporterProtocols.swift
//  TheTransporter
//
//  Created by Parveen Khatkar on 31/10/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

public protocol PathVars {
    var vars: [Any] {get}
}

public protocol QueryParams: Codable {
}
