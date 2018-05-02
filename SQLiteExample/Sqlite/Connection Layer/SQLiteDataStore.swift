//
//  SQLiteDataStore.swift
//  SQLiteExample
//
//  Created by iDeveloper2 on 26/02/18.
//  Copyright © 2018 Vincent Garrigues. All rights reserved.
//

import Foundation
import SQLite

final class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    var db:Connection? = nil
    
    private init() {
        
        var path = "store.sqlite"
        
        guard let dir:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        
        path = dir.appending(path)

        do
        {
             db = try Connection(path)
            print("---------Connection success-------",db ?? "000")
        }catch(let error) {
            print(error)
        }
    }
    
    func createTables() throws {
        do {
            try TeamDataHelper.createTable()
        }catch {
            throw DataAccessError.Datastore_Connection_Error
        }
    }
}

enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Table_All_Ready_Exists
    case Insert_Error
    case Delete_Error
    case Update_Error
    case Search_Error
    case Nil_In_Data
}
