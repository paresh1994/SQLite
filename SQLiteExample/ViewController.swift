import UIKit
import SQLite

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Database.storeURL()
        let db = try! Connection("\(path)")
        
        let id = Expression<Int64>("id")
        let email = Expression<String>("email")
        let balance = Expression<Double?>("balance")
        //let verified = Expression<Bool?>("verified")
        let name = Expression<String?>("name")
        
        let users = Table("users")
        
        //MARK: - Create Table
        print("==========Create Table===========")
        do
        {
            let c = try db.run(users.create(ifNotExists: false) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(email, unique: true)
                t.column(name)
            })
            print(c)
        }catch (let error){
            print(error)
        }
        
        //MARK: - Add Column
        print("==========Add Column===========")
        do
        {
            try db.run(users.addColumn(balance))
           
        }catch(let error) {
            print(error)
        }
        
        //MARK: - Insert Record
        print("==========Insert Record===========")
        do
        {
           let rowid = try db.run(users.insert(email <- "abc2@gmail.com", name <- "Abc B", balance <- 15000.0))
            print(rowid)
        }catch(let error) {
            print(error)
        }
    
        // MARK: - Update Row
        print("==========Update Row===========")
        do {
            let id = users.filter(id == 1)
            let update = try db.run(id.update(balance <- 20000.0))
            print("Update At==>",update)
        }catch(let error){
            print(error)
        }
        
        
        //MARK: - Select row
        print("==========Select row===========")
        do
        {
            for row in try db.prepare(users) {
                print("id: \(row[id]), email: \(row[email]), name: \(String(describing: row[name]))")
            }
        }catch(let error) {
            print(error)
        }
        
        //MARK: - Plucking Rows
        print("==========Plucking Rows===========")
        do
        {
            if let user = try db.pluck(users) {
                print(user)
            }
        }catch (let error){
            print(error)
        }
        
        //MARK: - Building Complex Queries
        print("==========Building Complex Queries===========")
        //let query = users.select(email,name)
                        
        do{
            for row in try db.prepare(users.filter(name != nil)) {
                print("id: \(row[id]), email: \(row[email]), name: \(String(describing: row[name]))")
            }
        }catch (let error) {
            print(error)
        }
        
        //MARK: - Selecting Columns
        print("==========Selecting Columns===========")
        do
        {
            for row in try db.prepare(users.select(email, name)){
                print(row)
            }
        }catch(let error) {
            print(error)
        }
        
        //MARK: - Filtering Rows
        print("==========Filtering Rows===========")
        do
        {
            let query = users.filter(id == 1)
            let user = try db.prepare(query)
            
            for row in user {
                print(row)
            }
        }catch(let error) {
            print(error)
        }
        
        //MARK: - Aggregation
        print("==========Aggregation===========")
        do {
            let count = try db.scalar(users.select(id.count))
            print("Count==>",count)
            
            let max = try db.scalar(users.select(id.max))
            print("Max==>",max  ?? 0)
            
            let min = try db.scalar(users.select(id.min))
            print("Min==>", min ?? 0)
            
            let avg = try db.scalar(users.select(balance.average))
            print("Average==>", avg ?? 0)
            
            let sum = try db.scalar(users.select(balance.sum))
            print("Sum==>", sum ?? 0)
            
            let disCount = try db.scalar(users.select(name.distinct.count))
            print("DISTINCT Name count==>", disCount)
            
        }catch(let error) {
            print(error)
        }
        
        // MARK: - Delete Row
        print("==========Delete Row===========")
        do
        {
            let deleteid = users.filter(id == 2)
            let id = try db.run(deleteid.delete())
            print("Deleter row At==>",id)
        }catch(let error) {
            print(error)
        }
        
        
        //MARK: - Insert Team record
        print("======Insert Team record=========")
       /* do {
            let bosID = try TeamDataHelper.insert(
                item: Team(
                    teamID: 0,
                    city: "Boston",
                    nickName: "Red Box",
                    abbreviation: "BOS"
                ))
            print("=====>",bosID)
        }catch(let error) {
            print(error)
        }*/
        
        // MARK: Find Recond in Team Table
        do
        {
            if let teams = try TeamDataHelper.findAll() {
                for team in teams {
                    print("\(team.city!) \(team.nickName!)")
                }
            }
        }catch (let error) {
            print(error)
        }
    }
}
