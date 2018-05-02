//
//  DataHelperProtocol.swift
//  SQLiteExample
//
//  Created by iDeveloper2 on 26/02/18.
//  Copyright © 2018 Vincent Garrigues. All rights reserved.
//

import Foundation

protocol DataHelperProtocol {
    associatedtype T
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func update(item: T) throws -> Void
    static func delete(item: T) throws -> Void
    static func findAll() throws -> [T]?
    static func find(id: Int64) throws -> T?
}
