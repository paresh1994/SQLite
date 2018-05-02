//
//  TeamDataHelper.swift
//  SQLiteExample
//
//  Created by iDeveloper2 on 26/02/18.
//  Copyright © 2018 Vincent Garrigues. All rights reserved.
//

import Foundation
import SQLite

class TeamDataHelper: DataHelperProtocol {
    
    typealias T = Team
    
    static let TABLE_NAME = "Teams"

    static let table = Table(TABLE_NAME)
    static let teamID = Expression<Int64>("teamID")
    static let city = Expression<String>("city")
    static let nickName = Expression<String>("nickName")
    static let abbreviation = Expression<String>("abbreviation")
    
    static func createTable() throws {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try db.run(table.create(ifNotExists: true) {
                t in
                t.column(teamID, primaryKey: true)
                t.column(city)
                t.column(nickName)
                t.column(abbreviation)
            })
        }catch _ {
            throw DataAccessError.Table_All_Ready_Exists
        }
    }
    
    static func insert(item: Team) throws -> Int64 {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.city != nil && item.nickName != nil &&  item.abbreviation != nil) {
            let insert = table.insert(city <- item.city!, nickName <- item.nickName!, abbreviation <- item.abbreviation!)
            do {
                let rowid = try db.run(insert)
                guard rowid > 0 else {
                    return 0
                }
                return rowid
            }catch _ {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
    }
    
    static func update(item: Team) throws {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.teamID {
            let query = table.filter(teamID == id)
            do {
                let tmp = try db.run(query.update(city <- item.city!, nickName <- item.nickName!, abbreviation <- item.abbreviation!))
                guard tmp == 1 else {
                    throw DataAccessError.Update_Error
                }
            }catch {
                throw DataAccessError.Update_Error
            }
        }
    }
    
    static func delete(item: Team) throws {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
    
        if let id = item.teamID {
            let query = table.filter(teamID == id)
            do {
                let tmp = try db.run(query.delete())
                guard tmp == 1 else {
                    throw DataAccessError.Delete_Error
                }
            }catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    static func findAll() throws -> [Team]? {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        var retArray = [Team]()
        do {
            let items = try db.prepare(table)
            
            for row in items {
                retArray.append(Team(teamID: row[teamID], city: row[city], nickName: row[nickName], abbreviation: row[abbreviation]))
            }
            return retArray
        }catch _ {
            throw DataAccessError.Search_Error
        }
    }
    
    static func find(id: Int64) throws -> Team? {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(teamID == id)
        
        do {
            let items = try db.prepare(query)
            
            for row in items {
                return Team(teamID: row[teamID], city: row[city], nickName: row[nickName], abbreviation: row[abbreviation])
            }
        }catch _ {
            throw DataAccessError.Search_Error
        }
        return nil
    }
}
