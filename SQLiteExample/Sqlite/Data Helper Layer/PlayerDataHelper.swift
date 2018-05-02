//
//  PlayerDataHelper.swift
//  SQLiteExample
//
//  Created by iDeveloper2 on 26/02/18.
//  Copyright © 2018 Vincent Garrigues. All rights reserved.
//

import Foundation
import SQLite

class PlayerDataHelper: DataHelperProtocol {
    
    typealias T = Player
    
    static let TABLE_NAME = "Player"
    
    static let table = Table(TABLE_NAME)
    static let playerid = Expression<Int64>("playerID")
    static let firstname = Expression<String>("firstname")
    static let lastname = Expression<String>("lastname")
    static let number = Expression<Int>("number")
    static let teamID = Expression<Int64>("teamID")
    static let position = Expression<String>("position")
    
    static func createTable() throws {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            _ = try db.run(table.create(ifNotExists: true){t in
                t.column(playerid, primaryKey: true)
                t.column(firstname)
                t.column(lastname)
                t.column(number)
                t.column(teamID)
                t.column(position)
            })
        }catch {
            throw DataAccessError.Table_All_Ready_Exists
        }
    }
    
    static func insert(item: Player) throws -> Int64 {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        if (item.firstName != nil && item.lastName != nil && item.teamID != nil && item.position != nil) {
            let insert = table.insert(firstname <- item.firstName!, lastname <- item.lastName!, teamID <- item.teamID!, position <- item.position!.rawValue)
            
            do {
                let rowid = try db.run(insert)
                guard rowid >= 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowid
                
            }catch {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
    }
    
    static func update(item: Player) throws {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        if let id = item.playerID {
            let query = table.filter(playerid == id)
            do {
                let tmp = try db.run(query.update(firstname <- item.firstName!, lastname <- item.lastName!, teamID <- item.teamID!, position <- item.position!.rawValue))
               
                guard tmp == 1 else {
                    throw DataAccessError.Update_Error
                }
                
            }catch {
                throw DataAccessError.Update_Error
            }
        }
    }
    
    static func delete(item: Player) throws {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        if let id = item.playerID {
            let query = table.filter(playerid == id)
            do {
                let tmp = try db.run(query.delete())
                guard tmp == 1 else {
                    throw DataAccessError.Delete_Error
                }
            }catch {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    static func findAll() throws -> [Player]? {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        var array = [Player]()
        
        do {
            let items = try db.prepare(table)
            
            for item in items {
                array.append(Player(playerID: item[playerid], firstName: item[firstname], lastName: item[lastname], number: item[number], teamID: item[teamID], position: Positions(rawValue: item[position])))
            }
            return array
            
        }catch {
            throw DataAccessError.Search_Error
        }
        
        
    }
    
    static func find(id: Int64) throws -> Player? {
        guard let db = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(playerid == id)
        do {
            let items = try db.prepare(query)
            for item in items {
                return Player(playerID: item[playerid], firstName: item[firstname], lastName: item[lastname], number: item[number], teamID: item[teamID], position: Positions(rawValue: item[position]))
            }
        }catch {
            throw DataAccessError.Search_Error
        }
        return nil
    }
}
