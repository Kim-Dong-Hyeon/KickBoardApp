//
//  DataManager.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/24/24.
//

import UIKit
import CoreData

protocol ReadCoreData {
  func readCoreData<T: NSManagedObject>(entityType: T.Type) -> [T]
  func readUserDefault(key: String) -> String?
  func deleteUserDefault(key: String)
}

class CoreDataManager: ReadCoreData {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  func readCoreData<T: NSManagedObject>(entityType: T.Type) -> [T] {
    let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
    
    do {
      let results = try context.fetch(fetchRequest)
      return results
    } catch {
      print("Failed to fetch data: \(error)")
      return []
    }
  }
  
  func deleteUserDefault(key: String) -> String? {
    return UserDefaults.standard.removeObject(forKey: key)
  }
  
  func readUserDefault(key: String) -> String? {
    return UserDefaults.standard.object(forKey: key) as? String
  }
  
  
  
  //  저장은 필요없나..?
  //  func saveData(key: String, value: Any) {
  //    if context.hasChanges {
  //      do {
  //        try context.save()
  //      } catch {
  //        print(#function)
  //      }
  //    }
  //  }
}


